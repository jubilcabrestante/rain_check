// lib/features/calculate/flood_risk_logistic_regression_calibrated.dart

import 'dart:math';

import 'package:rain_check/core/enum/flood_risk_level.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';
import 'package:rain_check/core/utils/flood_data_extensions.dart';

class FloodRiskLogisticRegression {
  static const double lowToModerate = 0.33;
  static const double moderateToHigh = 0.66;

  static const double confHigh = 0.20;
  static const double confModerate = 0.10;

  late final _ModelParams _params;

  FloodRiskLogisticRegression() {
    _params = _ModelParams.defaultParams();
  }

  double predictFloodProbability({
    required double rainfallInMm,
    required List<FloodFeature> floodFeatures,
    required double totalBarangayArea,
    required bool isUrban,
  }) {
    final raw = _extractFeatures(
      rainfallInMm: rainfallInMm,
      floodFeatures: floodFeatures,
      totalBarangayArea: totalBarangayArea,
      isUrban: isUrban,
    );

    final z = _params.logit(raw);
    return _sigmoid(z).clamp(0.0, 1.0);
  }

  FloodRiskLevel classify(double p) {
    if (p >= moderateToHigh) return FloodRiskLevel.high;
    if (p >= lowToModerate) return FloodRiskLevel.moderate;
    return FloodRiskLevel.low;
  }

  String confidence(double p) {
    final d = min((p - lowToModerate).abs(), (p - moderateToHigh).abs());
    if (d >= confHigh) return 'High';
    if (d >= confModerate) return 'Moderate';
    return 'Low';
  }

  Map<String, double> _extractFeatures({
    required double rainfallInMm,
    required List<FloodFeature> floodFeatures,
    required double totalBarangayArea,
    required bool isUrban,
  }) {
    if (floodFeatures.isEmpty || totalBarangayArea <= 0) {
      return _params.zeroFeatures(rainfallInMm, isUrban);
    }

    double hi = 0, mid = 0, low = 0;

    for (final f in floodFeatures) {
      final a = f.properties.areaInHas;
      switch (f.properties.riskLevel) {
        case FloodRiskLevel.high:
          hi += a;
          break;
        case FloodRiskLevel.moderate:
          mid += a;
          break;
        case FloodRiskLevel.low:
          low += a;
          break;
      }
    }

    final hiPct = (hi / totalBarangayArea) * 100;
    final midPct = (mid / totalBarangayArea) * 100;
    final lowPct = (low / totalBarangayArea) * 100;

    final density = floodFeatures.length / totalBarangayArea;

    return {
      _F.rain: rainfallInMm,
      _F.highPct: hiPct,
      _F.modPct: midPct,
      _F.lowPct: lowPct,
      _F.density: density,
      _F.urban: isUrban ? 1.0 : 0.0,
      _F.rXHigh: rainfallInMm * hiPct,
      _F.rXMod: rainfallInMm * midPct,
      _F.rXLow: rainfallInMm * lowPct,
    };
  }

  double _sigmoid(double z) {
    if (z >= 0) {
      final ez = exp(-z);
      return 1.0 / (1.0 + ez);
    } else {
      final ez = exp(z);
      return ez / (1.0 + ez);
    }
  }
}

class _F {
  static const rain = 'rainfall_mm';
  static const highPct = 'high_risk_area_pct';
  static const modPct = 'moderate_risk_area_pct';
  static const lowPct = 'low_risk_area_pct';
  static const density = 'area_density';
  static const urban = 'is_urban';
  static const rXHigh = 'rainfall_x_high_risk';
  static const rXMod = 'rainfall_x_moderate_risk';
  static const rXLow = 'rainfall_x_low_risk';

  static const all = <String>[
    rain,
    highPct,
    modPct,
    lowPct,
    density,
    urban,
    rXHigh,
    rXMod,
    rXLow,
  ];
}

class _ModelParams {
  final double intercept;
  final Map<String, double> coef;
  final Map<String, double> mean;
  final Map<String, double> std;

  _ModelParams({
    required this.intercept,
    required this.coef,
    required this.mean,
    required this.std,
  }) {
    _validate();
  }

  factory _ModelParams.defaultParams() {
    return _ModelParams(
      intercept: -4.2,
      coef: {
        _F.rain: 0.018,
        _F.highPct: 3.2,
        _F.modPct: 1.5,
        _F.lowPct: 0.8,
        _F.density: 1.2,
        _F.urban: 0.6,
        _F.rXHigh: 0.010,
        _F.rXMod: 0.006,
        _F.rXLow: 0.003,
      },
      mean: {
        _F.rain: 250.0,
        _F.highPct: 9.73,
        _F.modPct: 13.67,
        _F.lowPct: 8.40,
        _F.density: 0.0923,
        _F.urban: 0.516,
        _F.rXHigh: 2432.5,
        _F.rXMod: 3417.5,
        _F.rXLow: 2100.0,
      },
      std: {
        _F.rain: 75.0,
        _F.highPct: 11.40,
        _F.modPct: 18.29,
        _F.lowPct: 10.50,
        _F.density: 0.1738,
        _F.urban: 0.50,
        _F.rXHigh: 2850.0,
        _F.rXMod: 4575.0,
        _F.rXLow: 1575.0,
      },
    );
  }

  Map<String, double> zeroFeatures(double rainfall, bool isUrban) => {
    _F.rain: rainfall,
    _F.highPct: 0,
    _F.modPct: 0,
    _F.lowPct: 0,
    _F.density: 0,
    _F.urban: isUrban ? 1 : 0,
    _F.rXHigh: 0,
    _F.rXMod: 0,
    _F.rXLow: 0,
  };

  double logit(Map<String, double> raw) {
    var z = intercept;

    for (final k in _F.all) {
      final v = raw[k] ?? 0.0;
      final m = mean[k]!;
      final s = std[k]!;
      final x = s == 0 ? 0.0 : (v - m) / s;
      z += (coef[k] ?? 0.0) * x;
    }
    return z;
  }

  void _validate() {
    final keys = _F.all.toSet();
    if (!coef.keys.toSet().containsAll(keys) ||
        !mean.keys.toSet().containsAll(keys) ||
        !std.keys.toSet().containsAll(keys)) {
      throw StateError('Model params missing keys. Expected: $keys');
    }
  }
}

/// Result class for flood prediction
class LogisticFloodResult {
  final String barangayName;
  final double rainfallInMm;
  final double floodProbability;
  final FloodRiskLevel predictedRiskLevel;
  final String riskConfidence;
  final String message;
  final double? affectedAreaHectares;

  const LogisticFloodResult({
    required this.barangayName,
    required this.rainfallInMm,
    required this.floodProbability,
    required this.predictedRiskLevel,
    required this.riskConfidence,
    required this.message,
    this.affectedAreaHectares,
  });

  String get formattedProbability =>
      '${(floodProbability * 100).toStringAsFixed(1)}%';

  String get riskLevelDisplay => predictedRiskLevel.displayName;

  bool get hasFloodRisk =>
      floodProbability >= FloodRiskLogisticRegression.lowToModerate;
}
