import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:rain_check/core/enum/flood_risk_level.dart';
import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';
import 'package:rain_check/core/repository/rain_fall_model/rainfall_data_model.dart';
import 'package:rain_check/core/utils/flood_data_extensions.dart';
import 'package:rain_check/features/predict/domain/models/barangay_flood_risk.dart';

class MonteCarloFloodService {
  final int iterations;

  /// iterations controls stability/smoothness.
  /// 500–2000 is usually fine for mobile.
  const MonteCarloFloodService({this.iterations = 1000});

  /// ✅ Data-driven Monte Carlo:
  /// - Rainfall samples come from your CSV (month/day filtered)
  /// - Hazard base is from HF/MF/LF polygon areas vs barangay area
  /// - Rain normalization thresholds come from the rainPool (not constants)
  /// - Heavy loop runs in background isolate (`compute`)
  Future<BarangayFloodRisk> simulateBarangay({
    required String barangayName,
    required DateTimeRange range,
    required BarangayBoundaryFeature boundary,
    required List<FloodFeature> floodFeatures,
    required RainfallDataCollection rainfallData,
  }) async {
    final dayCount = range.duration.inDays + 1;
    if (dayCount <= 0 || iterations <= 0) {
      return BarangayFloodRisk.defaultLow(barangayName);
    }

    final areaHa = _barangayAreaHa(boundary);
    final hazard = _hazardPercents(
      floodFeatures: floodFeatures,
      barangayAreaHa: areaHa,
    );

    final pool = _buildRainfallPoolMm(range, rainfallData);
    if (pool.isEmpty) {
      return BarangayFloodRisk.defaultLow(barangayName);
    }

    // ✅ Dynamic thresholds from the selected date-window pool
    final heavyDailyRef = _percentile(pool, 0.90); // P90 daily rainfall
    final spikeRef = _maxOf(pool); // max daily rainfall

    // safety against divide-by-zero
    final safeHeavyDailyRef = heavyDailyRef > 0 ? heavyDailyRef : 1.0;
    final safeSpikeRef = spikeRef > 0 ? spikeRef : 1.0;

    // Deterministic seed so results are stable for same inputs
    final seed = _stableSeed(barangayName, range, iterations);

    final out = await compute(_mcWorker, <String, Object?>{
      'iterations': iterations,
      'dayCount': dayCount,
      'seed': seed,
      'rainPool': pool,
      'hfPct': hazard.hfPct,
      'mfPct': hazard.mfPct,
      'lfPct': hazard.lfPct,

      // ✅ pass dynamic refs to worker
      'heavyDailyRef': safeHeavyDailyRef,
      'spikeRef': safeSpikeRef,
    });

    final avgRain = (out['avgRain'] as double).clamp(0.0, 10000.0);
    final avgProb = (out['avgProb'] as double).clamp(0.0, 1.0);

    return BarangayFloodRisk(
      barangayName: barangayName,
      riskLevel: _riskLevelFromProbability(avgProb),
      floodProbability: avgProb * 100,
      rainfallIntensity: avgRain,
      rainfallCategory: _rainCategoryFromIntensity(avgRain),
    );
  }

  // --------------------------
  // Hazard from HF/MF/LF coverage
  // --------------------------
  _Hazard _hazardPercents({
    required List<FloodFeature> floodFeatures,
    required double barangayAreaHa,
  }) {
    if (barangayAreaHa <= 0 || floodFeatures.isEmpty) {
      return const _Hazard();
    }

    var hf = 0.0;
    var mf = 0.0;
    var lf = 0.0;

    for (final f in floodFeatures) {
      final a = f.properties.areaInHas;
      if (a <= 0) continue;

      switch (f.properties.riskLevel) {
        case FloodRiskLevel.high:
          hf += a;
          break;
        case FloodRiskLevel.moderate:
          mf += a;
          break;
        case FloodRiskLevel.low:
          lf += a;
          break;
      }
    }

    return _Hazard(
      hfPct: (hf / barangayAreaHa).clamp(0.0, 1.0),
      mfPct: (mf / barangayAreaHa).clamp(0.0, 1.0),
      lfPct: (lf / barangayAreaHa).clamp(0.0, 1.0),
    );
  }

  double _barangayAreaHa(BarangayBoundaryFeature b) {
    // Prefer Area_has (already ha) then fallback AreaInHect
    final a1 = b.properties.areaHas;
    if (a1 > 0) return a1;
    final a2 = b.properties.areaInHect;
    return a2 > 0 ? a2 : 0.0;
  }

  // --------------------------
  // Rainfall pool (mm) from CSV
  // --------------------------
  List<double> _buildRainfallPoolMm(
    DateTimeRange range,
    RainfallDataCollection data,
  ) {
    final picked = <double>[];

    for (final p in data.data) {
      if (!_dateMatchesRange(p, range)) continue;

      final mm = p.rainfallMm; // cleaned (handles -999/-1)
      if (mm != null) picked.add(mm);
    }

    if (picked.isNotEmpty) return picked;

    // Fallback: use all available cleaned rainfall
    for (final p in data.data) {
      final mm = p.rainfallMm;
      if (mm != null) picked.add(mm);
    }

    return picked;
  }

  bool _dateMatchesRange(RainfallDataPoint point, DateTimeRange range) {
    // Compare by month/day only (climatology style)
    final pointDay = DateTime(2000, point.month, point.day);
    final startDay = DateTime(2000, range.start.month, range.start.day);
    final endDay = DateTime(2000, range.end.month, range.end.day);

    // Wrap-around ranges (Dec -> Jan)
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

  int _stableSeed(String name, DateTimeRange r, int iters) {
    final s =
        '${name.trim().toLowerCase()}|${r.start.month}-${r.start.day}|${r.end.month}-${r.end.day}|$iters';
    // simple stable hash
    var h = 0;
    for (final c in s.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return h;
  }

  FloodRiskLevel _riskLevelFromProbability(double p) {
    if (p >= 0.60) return FloodRiskLevel.high;
    if (p >= 0.30) return FloodRiskLevel.moderate;
    return FloodRiskLevel.low;
  }

  RainAmount _rainCategoryFromIntensity(double intensity) {
    if (intensity >= 30) return RainAmount.high;
    if (intensity >= 10) return RainAmount.moderate;
    return RainAmount.low;
  }

  // --------------------------
  // ✅ Helpers for dynamic thresholds
  // --------------------------
  double _maxOf(List<double> xs) {
    var m = double.negativeInfinity;
    for (final v in xs) {
      if (v > m) m = v;
    }
    return m.isFinite ? m : 0.0;
  }

  /// p in [0..1], ex: 0.90 for P90
  double _percentile(List<double> xs, double p) {
    if (xs.isEmpty) return 0.0;
    final sorted = List<double>.from(xs)..sort();
    final pos = (p.clamp(0.0, 1.0) * (sorted.length - 1));
    final lo = pos.floor();
    final hi = pos.ceil();
    if (lo == hi) return sorted[lo];
    final w = pos - lo;
    return sorted[lo] * (1 - w) + sorted[hi] * w;
  }
}

class _Hazard {
  final double hfPct;
  final double mfPct;
  final double lfPct;
  const _Hazard({this.hfPct = 0, this.mfPct = 0, this.lfPct = 0});
}

/// Runs in background isolate.
/// Input/Output must be sendable => Map/List/num/bool/String only.
Map<String, double> _mcWorker(Map<String, Object?> job) {
  final iterations = job['iterations'] as int;
  final dayCount = job['dayCount'] as int;
  final seed = job['seed'] as int;
  final rainPool = (job['rainPool'] as List).cast<double>();

  final hfPct = job['hfPct'] as double;
  final mfPct = job['mfPct'] as double;
  final lfPct = job['lfPct'] as double;

  // ✅ dynamic refs
  final heavyDailyRef = job['heavyDailyRef'] as double;
  final spikeRef = job['spikeRef'] as double;

  final rng = Random(seed);

  // Hazard-based base risk (HF dominates)
  final hazardScore = (0.75 * hfPct + 0.20 * mfPct + 0.05 * lfPct).clamp(
    0.0,
    1.0,
  );
  final baseRisk = (0.05 + 0.95 * hazardScore).clamp(0.05, 0.95);

  var sumAvgRain = 0.0;
  var sumProb = 0.0;

  for (var i = 0; i < iterations; i++) {
    var sum = 0.0;
    var max1d = 0.0;

    for (var d = 0; d < dayCount; d++) {
      final v = rainPool[rng.nextInt(rainPool.length)];
      sum += v;
      if (v > max1d) max1d = v;
    }

    final avg = sum / dayCount;

    // ✅ Rain signal: weekly total + 1-day spike (DATA-DRIVEN)
    final sumFactor = (sum / (dayCount * heavyDailyRef)).clamp(0.0, 1.0);
    final spikeFactor = (max1d / spikeRef).clamp(0.0, 1.0);
    final rainSignal = (0.65 * sumFactor + 0.35 * spikeFactor).clamp(0.0, 1.0);

    final prob = (0.70 * baseRisk + 0.30 * rainSignal).clamp(0.0, 1.0);

    sumAvgRain += avg;
    sumProb += prob;
  }

  return {'avgRain': sumAvgRain / iterations, 'avgProb': sumProb / iterations};
}
