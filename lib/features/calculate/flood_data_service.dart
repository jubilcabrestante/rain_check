// lib/features/calculate/flood_data_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:rain_check/core/constant/geojson_data.dart';
import 'package:rain_check/core/enum/flood_risk_level.dart';
import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';
import 'package:rain_check/core/utils/flood_data_extensions.dart';
import 'package:rain_check/features/calculate/flood_risk_logistic_regression_calibrated.dart';

enum RainfallIntensity {
  low(min: 0, max: 150, display: 'Low (0-150 mm)'),
  moderate(min: 150, max: 300, display: 'Moderate (150-300 mm)'),
  high(min: 300, max: 450, display: 'High (300-450 mm)');

  final double min;
  final double max;
  final String display;

  const RainfallIntensity({
    required this.min,
    required this.max,
    required this.display,
  });

  double get midpoint => (min + max) / 2;
}

class FloodDataService {
  static final FloodDataService _instance = FloodDataService._internal();
  factory FloodDataService() => _instance;
  FloodDataService._internal();

  FloodDataCollection? _floodData;
  BarangayBoundariesCollection? _boundaries;
  late final FloodRiskLogisticRegression _model;

  bool get isLoaded => _floodData != null && _boundaries != null;

  Future<void> initialize() async {
    if (isLoaded) return;

    final results = await Future.wait([
      rootBundle.loadString(floodingAreaPath),
      rootBundle.loadString(boundariesPath),
    ]);

    _floodData = FloodDataCollection.fromJson(
      json.decode(results[0]) as Map<String, dynamic>,
    );
    _boundaries = BarangayBoundariesCollection.fromJson(
      json.decode(results[1]) as Map<String, dynamic>,
    );

    _model = FloodRiskLogisticRegression();
  }

  FloodDataCollection get floodData {
    final v = _floodData;
    if (v == null) throw StateError('FloodDataService not initialized');
    return v;
  }

  BarangayBoundariesCollection get boundaries {
    final v = _boundaries;
    if (v == null) throw StateError('FloodDataService not initialized');
    return v;
  }

  LogisticFloodResult calculateFloodRiskML({
    required String barangayName,
    required RainfallIntensity intensity,
  }) {
    final boundary = boundaries.findByName(barangayName);
    if (boundary == null) {
      throw StateError('Boundary not found for $barangayName');
    }

    final floodFeatures = floodData.getFeaturesForBarangay(barangayName);
    final rainfallMm = intensity.midpoint;
    final totalArea = boundary.properties.areaInHect;

    final probability = _model.predictFloodProbability(
      rainfallInMm: rainfallMm,
      floodFeatures: floodFeatures,
      totalBarangayArea: totalArea,
      isUrban: boundary.isUrban,
    );

    final riskLevel = _model.classify(probability);
    final confidence = _model.confidence(probability);

    final affectedArea = floodFeatures.fold<double>(
      0.0,
      (sum, feature) => sum + feature.properties.areaInHas,
    );

    return LogisticFloodResult(
      barangayName: barangayName,
      rainfallInMm: rainfallMm,
      floodProbability: probability,
      predictedRiskLevel: riskLevel,
      riskConfidence: confidence,
      message: _generateRiskMessage(riskLevel, probability),
      affectedAreaHectares: affectedArea,
    );
  }

  String _generateRiskMessage(FloodRiskLevel level, double probability) {
    final pct = (probability * 100).toStringAsFixed(0);

    switch (level) {
      case FloodRiskLevel.high:
        return 'There is a $pct% chance of flooding in your area. Stay safe and contact your local emergency services. Monitor updates, secure important items, unplug appliances, and prepare an emergency go bag. Avoid low-lying areas and be ready to evacuate if authorities issue an alert.';
      case FloodRiskLevel.moderate:
        return 'There is a $pct% chance of flooding. Monitor weather updates and prepare for possible evacuation. Secure outdoor items and avoid low-lying areas.';
      case FloodRiskLevel.low:
        return 'There is a $pct% chance of flooding. Risk is low but stay alert to changing conditions. Avoid unnecessary travel to flood-prone areas.';
    }
  }

  List<String> getAllBarangayNames() => floodData.uniqueBarangayNames;

  BarangayBoundaryFeature? getBarangayBoundary(String barangayName) =>
      boundaries.findByName(barangayName);
}
