import 'dart:math';

import 'package:rain_check/core/enum/flood_risk_level.dart';
import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';
import 'package:rain_check/core/repository/rain_fall_model/rainfall_data_model.dart';
import 'package:rain_check/core/utils/flood_data_extensions.dart';

/// Logistic regression model:
/// ✅ Raw inputs are computed from GeoJSON features (HF/MF/LF areas) + boundary area.
/// ✅ Rainfall input is provided by user (or could be taken from CSV if you add date selection).
/// ✅ Normalization stats (mean/std) are computed from your actual files (NOT random).
class FloodRiskLogisticRegression {
  static const double lowToModerate = 0.33;
  static const double moderateToHigh = 0.66;

  static const double confHigh = 0.20;
  static const double confModerate = 0.10;

  final ModelParams params;

  FloodRiskLogisticRegression({required this.params});

  double predictFloodProbability({
    required double rainfallInMm,
    required List<FloodFeature> floodFeatures,
    required double totalBarangayAreaHa,
    required bool isUrban,
  }) {
    final raw = FeatureExtractor.extract(
      rainfallInMm: rainfallInMm,
      floodFeatures: floodFeatures,
      totalBarangayAreaHa: totalBarangayAreaHa,
      isUrban: isUrban,
    );

    final z = params.logit(raw);
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

  double _sigmoid(double z) {
    // numerically stable sigmoid
    if (z >= 0) {
      final ez = exp(-z);
      return 1.0 / (1.0 + ez);
    } else {
      final ez = exp(z);
      return ez / (1.0 + ez);
    }
  }
}

/// All feature keys (stable)
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

/// Feature extraction:
/// ✅ Uses ONLY flood polygons + barangay area + urban flag + rainfall input.
class FeatureExtractor {
  static Map<String, double> extract({
    required double rainfallInMm,
    required List<FloodFeature> floodFeatures,
    required double totalBarangayAreaHa,
    required bool isUrban,
  }) {
    if (totalBarangayAreaHa <= 0) {
      return _zeroFeatures(rainfallInMm, isUrban);
    }

    if (floodFeatures.isEmpty) {
      // no hazard polygons inside barangay
      return _zeroFeatures(rainfallInMm, isUrban);
    }

    double hi = 0, mid = 0, low = 0;

    for (final f in floodFeatures) {
      final a = f.properties.areaInHas;
      if (a <= 0) continue;

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

    // percent of total barangay area (0..100)
    final hiPct = ((hi / totalBarangayAreaHa) * 100).clamp(0.0, 100.0);
    final midPct = ((mid / totalBarangayAreaHa) * 100).clamp(0.0, 100.0);
    final lowPct = ((low / totalBarangayAreaHa) * 100).clamp(0.0, 100.0);

    // density = polygons per hectare
    final density = (floodFeatures.length / totalBarangayAreaHa).clamp(
      0.0,
      9999.0,
    );

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

  static Map<String, double> _zeroFeatures(double rainfall, bool isUrban) => {
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
}

/// Coefficients container (your calibrated values; not random)
class ModelCoefficients {
  final Map<String, double> coef;

  const ModelCoefficients(this.coef);

  factory ModelCoefficients.calibratedPpc() => ModelCoefficients({
    _F.rain: 0.018,
    _F.highPct: 3.2,
    _F.modPct: 1.5,
    _F.lowPct: 0.8,
    _F.density: 1.2,
    _F.urban: 0.6,
    _F.rXHigh: 0.010,
    _F.rXMod: 0.006,
    _F.rXLow: 0.003,
  });
}

/// Params used at runtime
class ModelParams {
  final double intercept;
  final Map<String, double> coef;
  final Map<String, double> mean;
  final Map<String, double> std;

  ModelParams({
    required this.intercept,
    required this.coef,
    required this.mean,
    required this.std,
  }) {
    _validate();
  }

  double logit(Map<String, double> raw) {
    var z = intercept;

    for (final k in _F.all) {
      final v = raw[k] ?? 0.0;
      final m = mean[k] ?? 0.0;
      final s = std[k] ?? 1.0;

      // standardize
      final x = (s == 0) ? 0.0 : (v - m) / s;
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

/// Builds mean/std from your real dataset:
/// - For every barangay:
///   - compute HF/MF/LF%, density, urban from GeoJSON
/// - For rainfall:
///   - use several representative values sampled from the CSV distribution (p25/p50/p75/p90)
/// This creates many rows => good mean/std without randomness.
class ModelParamsBuilder {
  static ModelParams buildFromFiles({
    required BarangayBoundariesCollection boundaries,
    required FloodDataCollection floodData,
    required RainfallDataCollection rainfallData,
    required ModelCoefficients baseCoefficients,
    required double intercept,
  }) {
    final rainValues = _cleanRainfallValues(rainfallData);

    // Fallback if CSV is empty/broken
    final samples = (rainValues.isEmpty)
        ? <double>[20, 50, 120, 250]
        : _representativeRainfallSamples(rainValues);

    final rows = <Map<String, double>>[];

    for (final b in boundaries.features) {
      final name = b.properties.brgyName;
      final areaHa = max(b.properties.areaHas, b.properties.areaInHect);
      final isUrban = b.isUrban;

      if (areaHa <= 0) continue;

      final features = floodData.getFeaturesForBarangay(name);

      for (final r in samples) {
        rows.add(
          FeatureExtractor.extract(
            rainfallInMm: r,
            floodFeatures: features,
            totalBarangayAreaHa: areaHa,
            isUrban: isUrban,
          ),
        );
      }
    }

    // Compute mean/std per feature key
    final mean = <String, double>{};
    final std = <String, double>{};

    for (final key in _F.all) {
      final values = rows.map((row) => row[key] ?? 0.0).toList();
      final m = _mean(values);
      var s = _std(values, m);

      // Prevent divide-by-zero
      if (s < 1e-6) s = 1.0;

      mean[key] = m;
      std[key] = s;
    }

    return ModelParams(
      intercept: intercept,
      coef: baseCoefficients.coef,
      mean: mean,
      std: std,
    );
  }

  static List<double> _cleanRainfallValues(
    RainfallDataCollection rainfallData,
  ) {
    final vals = <double>[];
    for (final p in rainfallData.data) {
      final v = p.rainfallMm; // uses your cleaned getter
      if (v == null) continue;
      if (v.isNaN) continue;
      if (v < 0) continue;
      vals.add(v);
    }
    return vals;
  }

  static List<double> _representativeRainfallSamples(List<double> values) {
    final sorted = [...values]..sort();

    double q(double p) {
      if (sorted.isEmpty) return 0;
      final idx = (p * (sorted.length - 1)).round();
      return sorted[idx.clamp(0, sorted.length - 1)];
    }

    // p25, p50, p75, p90 from real CSV distribution
    final p25 = q(0.25);
    final p50 = q(0.50);
    final p75 = q(0.75);
    final p90 = q(0.90);

    // Ensure unique-ish (avoid all equal on weird datasets)
    final out = <double>{p25, p50, p75, p90}.toList()..sort();
    return out.isEmpty ? <double>[20, 50, 120, 250] : out;
  }

  static double _mean(List<double> a) {
    if (a.isEmpty) return 0;
    var s = 0.0;
    for (final v in a) {
      s += v;
    }
    return s / a.length;
  }

  static double _std(List<double> a, double m) {
    if (a.length < 2) return 0;
    var ss = 0.0;
    for (final v in a) {
      final d = v - m;
      ss += d * d;
    }
    return sqrt(ss / (a.length - 1));
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
