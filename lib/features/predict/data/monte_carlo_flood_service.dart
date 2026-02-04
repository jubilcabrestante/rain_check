import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rain_check/core/enum/flood_risk_level.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';
import 'package:rain_check/core/repository/rain_fall_model/rainfall_data_model.dart';
import 'package:rain_check/core/utils/flood_data_extensions.dart';
import 'package:rain_check/features/predict/domain/models/barangay_flood_risk.dart';

class MonteCarloFloodService {
  final Random _random;
  final int iterations;

  // ✅ NOT const (because Random() isn't const)
  MonteCarloFloodService({Random? random, this.iterations = 500})
    : _random = random ?? Random();

  Map<String, BarangayFloodRisk> monteCarlo({
    required DateTimeRange range,
    required List<String> barangayNames,
    required FloodDataCollection floodData,
    required RainfallDataCollection rainfallData,
  }) {
    final dayCount = range.duration.inDays + 1;
    final rainfallPool = _buildRainfallPool(range, rainfallData);

    final map = <String, BarangayFloodRisk>{};
    for (final name in barangayNames) {
      final features = floodData.getFeaturesForBarangay(name);
      map[name] = _simulateBarangay(
        barangayName: name,
        dayCount: dayCount,
        rainfallPool: rainfallPool,
        floodFeatures: features,
      );
    }
    return map;
  }

  BarangayFloodRisk _simulateBarangay({
    required String barangayName,
    required int dayCount,
    required List<RainfallDataPoint> rainfallPool,
    required List<FloodFeature> floodFeatures,
  }) {
    if (dayCount <= 0 || rainfallPool.isEmpty || iterations <= 0) {
      return BarangayFloodRisk.defaultLow(barangayName);
    }

    final baseRisk = _baseRiskScore(floodFeatures);
    var totalRainfall = 0.0;
    var totalProbability = 0.0;

    for (var i = 0; i < iterations; i++) {
      final avgRain = _simulateAverageRainfall(dayCount, rainfallPool);
      final probability = _probabilityFrom(baseRisk, avgRain);
      totalRainfall += avgRain;
      totalProbability += probability;
    }

    final avgRainfall = totalRainfall / iterations;
    final avgProbability = totalProbability / iterations;

    return BarangayFloodRisk(
      barangayName: barangayName,
      riskLevel: _riskLevelFromProbability(avgProbability),
      floodProbability: avgProbability * 100,
      rainfallIntensity: avgRainfall,
      rainfallCategory: _rainCategoryFromIntensity(avgRainfall),
    );
  }

  double _simulateAverageRainfall(
    int dayCount,
    List<RainfallDataPoint> rainfallPool,
  ) {
    var sum = 0.0;
    for (var d = 0; d < dayCount; d++) {
      final pick = rainfallPool[_random.nextInt(rainfallPool.length)];
      sum += pick.rainfall;
    }
    return sum / dayCount;
  }

  List<RainfallDataPoint> _buildRainfallPool(
    DateTimeRange range,
    RainfallDataCollection rainfallData,
  ) {
    final filtered = rainfallData.data
        .where((point) => _dateMatchesRange(point, range))
        .toList();

    return filtered.isNotEmpty ? filtered : rainfallData.data;
  }

  bool _dateMatchesRange(RainfallDataPoint point, DateTimeRange range) {
    final pointDay = DateTime(2000, point.month, point.day);
    final startDay = DateTime(2000, range.start.month, range.start.day);
    final endDay = DateTime(2000, range.end.month, range.end.day);

    if (endDay.isBefore(startDay)) {
      return _isOnOrAfter(pointDay, startDay) ||
          _isOnOrBefore(pointDay, endDay);
    }
    return _isOnOrAfter(pointDay, startDay) && _isOnOrBefore(pointDay, endDay);
  }

  bool _isOnOrAfter(DateTime a, DateTime b) =>
      a.isAfter(b) || a.isAtSameMomentAs(b);

  bool _isOnOrBefore(DateTime a, DateTime b) =>
      a.isBefore(b) || a.isAtSameMomentAs(b);

  double _baseRiskScore(List<FloodFeature> floodFeatures) {
    if (floodFeatures.isEmpty) return 0.15;

    var totalArea = 0.0;
    var weighted = 0.0;

    for (final feature in floodFeatures) {
      final area = feature.properties.areaInHas;
      totalArea += area;
      weighted += area * _riskWeight(feature.properties.riskLevel);
    }

    if (totalArea <= 0) return 0.15;
    return (weighted / totalArea).clamp(0.05, 0.95);
  }

  double _riskWeight(FloodRiskLevel level) {
    return switch (level) {
      FloodRiskLevel.low => 0.25,
      FloodRiskLevel.moderate => 0.55,
      FloodRiskLevel.high => 0.85,
    };
  }

  double _probabilityFrom(double baseRisk, double avgRainfall) {
    final rainFactor = (avgRainfall / 120).clamp(0.0, 1.0);
    return (baseRisk * 0.65 + rainFactor * 0.35).clamp(0.0, 1.0);
  }

  FloodRiskLevel _riskLevelFromProbability(double probability) {
    if (probability >= 0.6) return FloodRiskLevel.high;
    if (probability >= 0.3) return FloodRiskLevel.moderate;
    return FloodRiskLevel.low;
  }

  RainAmount _rainCategoryFromIntensity(double intensity) {
    if (intensity >= 30) return RainAmount.high;
    if (intensity >= 10) return RainAmount.moderate;
    return RainAmount.low;
  }
}
