import 'dart:math';

import 'package:rain_check/core/enum/flood_risk_level.dart';
import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';
import 'package:rain_check/core/repository/rain_fall_model/rainfall_data_model.dart';
import 'package:rain_check/core/utils/flood_data_extensions.dart';

class FloodRiskLogisticRegression {
  // You can tweak these after you see real outputs
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
    return _LogRegMath.sigmoid(z).clamp(0.0, 1.0);
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
}

/// Feature keys
class _F {
  // Use log rainfall to avoid runaway logits at 50/100+
  static const rainLog = 'rain_log_mm';

  // Use FRACTIONS (0..1), not 0..100 percent
  static const highFrac = 'high_risk_area_frac';
  static const modFrac = 'moderate_risk_area_frac';
  static const lowFrac = 'low_risk_area_frac';

  // polygon parts per hectare (from flood geojson multipolygons)
  static const density = 'flood_poly_density';

  static const urban = 'is_urban';

  // interactions (still stable because rain is log, area is fraction)
  static const rXHigh = 'rainlog_x_highfrac';
  static const rXMod = 'rainlog_x_modfrac';
  static const rXLow = 'rainlog_x_lowfrac';

  static const all = <String>[
    rainLog,
    highFrac,
    modFrac,
    lowFrac,
    density,
    urban,
    rXHigh,
    rXMod,
    rXLow,
  ];
}

/// Extract raw features from your files
class FeatureExtractor {
  static Map<String, double> extract({
    required double rainfallInMm,
    required List<FloodFeature> floodFeatures,
    required double totalBarangayAreaHa,
    required bool isUrban,
  }) {
    final areaHa = totalBarangayAreaHa;

    final rainMm = rainfallInMm.isNaN ? 0.0 : max(0.0, rainfallInMm);
    final rainLog = log(1.0 + rainMm);

    if (areaHa <= 0) {
      return _zero(rainLog, isUrban);
    }

    if (floodFeatures.isEmpty) {
      return _zero(rainLog, isUrban);
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

    // FRACTIONS (0..1)
    final hiFrac = (hi / areaHa).clamp(0.0, 1.0);
    final midFrac = (mid / areaHa).clamp(0.0, 1.0);
    final lowFrac = (low / areaHa).clamp(0.0, 1.0);

    // density = polygon parts per hectare (from flood geometry)
    final polygonParts = _countPolygonParts(floodFeatures);
    final density = (polygonParts / areaHa).clamp(0.0, 9999.0);

    return {
      _F.rainLog: rainLog,
      _F.highFrac: hiFrac,
      _F.modFrac: midFrac,
      _F.lowFrac: lowFrac,
      _F.density: density,
      _F.urban: isUrban ? 1.0 : 0.0,
      _F.rXHigh: rainLog * hiFrac,
      _F.rXMod: rainLog * midFrac,
      _F.rXLow: rainLog * lowFrac,
    };
  }

  static int _countPolygonParts(List<FloodFeature> floodFeatures) {
    var count = 0;
    for (final f in floodFeatures) {
      final parts = f.geometry.coordinates.length; // MultiPolygon parts
      if (parts > 0) count += parts;
    }
    return count;
  }

  static Map<String, double> _zero(double rainLog, bool isUrban) => {
    _F.rainLog: rainLog,
    _F.highFrac: 0,
    _F.modFrac: 0,
    _F.lowFrac: 0,
    _F.density: 0,
    _F.urban: isUrban ? 1 : 0,
    _F.rXHigh: 0,
    _F.rXMod: 0,
    _F.rXLow: 0,
  };
}

/// Model params used at runtime
class ModelParams {
  final double intercept;
  final Map<String, double> coef; // learned from files (proxy training)
  final Map<String, double> mean; // from files
  final Map<String, double> std; // from files

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

/// Builds mean/std + learns coefficients from YOUR FILES (proxy targets).
/// NOTE: Without real “actual flood happened” labels, this is a risk score model.
class ModelParamsBuilder {
  static ModelParams trainFromFiles({
    required BarangayBoundariesCollection boundaries,
    required FloodDataCollection floodData,

    /// Optional: station-wide rainfall CSV (PPC). Used only for quantiles/scaling.
    RainfallDataCollection? rainfallData,

    /// Keep this small so it won’t lag on mobile
    int iterations = 2500,
    double learningRate = 0.12,
    double l2 = 1e-2,
  }) {
    final rainValues = (rainfallData == null)
        ? <double>[]
        : _cleanRainfallValues(rainfallData);

    final samples = _rainSamples(rainValues);

    final rainRef =
        _positiveQuantile(rainValues, 0.995) ?? 100.0; // ~100mm target
    final p95 = _positiveQuantile(rainValues, 0.95);

    // Gamma derived from CSV: make p95 roughly “half strength” vs p99.5
    final gamma = (p95 != null && p95 > 0 && rainRef > p95)
        ? (log(0.5) / log(p95 / rainRef)).abs()
        : 1.0;

    final rows = <Map<String, double>>[];
    final targets = <double>[];

    for (final b in boundaries.features) {
      final name = b.properties.brgyName;
      final areaHa = max(b.properties.areaHas, b.properties.areaInHect);
      if (areaHa <= 0) continue;

      final isUrban = b.isUrban;
      final features = floodData.getFeaturesForBarangay(name);

      for (final r in samples) {
        final raw = FeatureExtractor.extract(
          rainfallInMm: r,
          floodFeatures: features,
          totalBarangayAreaHa: areaHa,
          isUrban: isUrban,
        );

        final y = _proxyTarget(raw, r, rainRef, gamma);

        rows.add(raw);
        targets.add(y);
      }
    }

    if (rows.isEmpty) {
      throw StateError('No training rows produced. Check parsing/data.');
    }

    // mean/std
    final mean = <String, double>{};
    final std = <String, double>{};

    for (final key in _F.all) {
      final values = rows.map((row) => row[key] ?? 0.0).toList();
      final m = _mean(values);
      var s = _std(values, m);
      if (s < 1e-6) s = 1.0;
      mean[key] = m;
      std[key] = s;
    }

    // standardized matrix
    final n = rows.length;
    final d = _F.all.length;

    final X = List.generate(n, (i) {
      final row = rows[i];
      return List.generate(d, (j) {
        final k = _F.all[j];
        final v = row[k] ?? 0.0;
        final m = mean[k] ?? 0.0;
        final s = std[k] ?? 1.0;
        return (v - m) / s;
      });
    });

    final fit = _LogisticTrainer.fit(
      X: X,
      y: targets,
      iterations: iterations,
      learningRate: learningRate,
      l2: l2,
    );

    final coef = <String, double>{};
    for (var j = 0; j < d; j++) {
      coef[_F.all[j]] = fit.weights[j];
    }

    return ModelParams(
      intercept: fit.intercept,
      coef: coef,
      mean: mean,
      std: std,
    );
  }

  /// Proxy target using ONLY your files:
  /// susceptibility = HF+MF+LF coverage (0..1)
  /// rainFactor = (rain / rainRef)^gamma, clamped 0..1
  static double _proxyTarget(
    Map<String, double> raw,
    double rainMm,
    double rainRef,
    double gamma,
  ) {
    final susc =
        ((raw[_F.highFrac] ?? 0) +
                (raw[_F.modFrac] ?? 0) +
                (raw[_F.lowFrac] ?? 0))
            .clamp(0.0, 1.0);

    final r = max(0.0, rainMm);
    final rf = (rainRef <= 0)
        ? 0.0
        : pow((r / rainRef).clamp(0.0, 1.0), gamma).toDouble();

    return (susc * rf).clamp(0.0, 1.0);
  }

  static List<double> _cleanRainfallValues(
    RainfallDataCollection rainfallData,
  ) {
    final vals = <double>[];
    for (final p in rainfallData.data) {
      final v = p.rainfallMm;
      if (v == null) continue;
      if (v.isNaN) continue;
      if (v < 0) continue;
      vals.add(v);
    }
    return vals;
  }

  static double? _positiveQuantile(List<double> values, double p) {
    final pos = values.where((v) => v > 0).toList()..sort();
    if (pos.isEmpty) return null;
    final idx = (p * (pos.length - 1)).round();
    return pos[idx.clamp(0, pos.length - 1)];
  }

  static List<double> _rainSamples(List<double> values) {
    final pos = values.where((v) => v > 0).toList()..sort();
    if (pos.isEmpty) {
      // fallback if CSV missing
      return <double>[0, 10, 30, 50, 80, 100];
    }

    double q(double p) {
      final idx = (p * (pos.length - 1)).round();
      return pos[idx.clamp(0, pos.length - 1)];
    }

    // IMPORTANT: include high quantiles so 50/100 are not out-of-distribution
    final out = <double>{
      0.0,
      q(0.50),
      q(0.75),
      q(0.90),
      q(0.95),
      q(0.99),
      q(0.995),
    }.toList()..sort();

    return out;
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

class _LogisticFit {
  final double intercept;
  final List<double> weights;
  const _LogisticFit({required this.intercept, required this.weights});
}

class _LogRegMath {
  static double sigmoid(double z) {
    if (z >= 0) {
      final ez = exp(-z);
      return 1.0 / (1.0 + ez);
    } else {
      final ez = exp(z);
      return ez / (1.0 + ez);
    }
  }
}

class _LogisticTrainer {
  static _LogisticFit fit({
    required List<List<double>> X, // standardized
    required List<double> y, // 0..1 (proxy ok)
    int iterations = 2500,
    double learningRate = 0.12,
    double l2 = 1e-2,
  }) {
    final n = X.length;
    final d = X.first.length;

    final yMean = (y.reduce((a, b) => a + b) / max(1, n)).clamp(1e-6, 1 - 1e-6);
    var b0 = log(yMean / (1 - yMean));

    final w = List<double>.filled(d, 0.0);

    for (var it = 0; it < iterations; it++) {
      var db = 0.0;
      final dw = List<double>.filled(d, 0.0);

      for (var i = 0; i < n; i++) {
        var z = b0;
        final xi = X[i];
        for (var j = 0; j < d; j++) {
          z += w[j] * xi[j];
        }

        final p = _LogRegMath.sigmoid(z);
        final diff = p - y[i];

        db += diff;
        for (var j = 0; j < d; j++) {
          dw[j] += diff * xi[j];
        }
      }

      db /= n;
      for (var j = 0; j < d; j++) {
        dw[j] = (dw[j] / n) + (l2 * w[j]);
      }

      b0 -= learningRate * db;
      for (var j = 0; j < d; j++) {
        w[j] -= learningRate * dw[j];
      }
    }

    return _LogisticFit(intercept: b0, weights: w);
  }
}

/// Result class
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
