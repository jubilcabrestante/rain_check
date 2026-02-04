import 'dart:math';

import 'package:rain_check/core/enum/flood_risk_level.dart';
import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';
import 'package:rain_check/core/repository/rain_fall_model/rainfall_data_model.dart';
import 'package:rain_check/core/utils/data_loader.dart';
import 'package:rain_check/core/utils/flood_data_extensions.dart';
import 'package:rain_check/features/calculate/widgets/flood_risk_logistic_regression_calibrated.dart';

/// Service responsible for:
/// ✅ Loading GeoJSON + CSV from assets
/// ✅ Computing barangay flood features (HF/MF/LF %, density, urban)
/// ✅ Calibrating normalization stats (mean/std) FROM FILES (not random)
class FloodDataService {
  static final FloodDataService _instance = FloodDataService._internal();
  factory FloodDataService() => _instance;
  FloodDataService._internal();

  final DataLoader _loader = const DataLoader();

  FloodDataCollection? _floodData;
  BarangayBoundariesCollection? _boundaries;
  RainfallDataCollection? _rainfall;

  late FloodRiskLogisticRegression _model;

  bool get isLoaded =>
      _floodData != null && _boundaries != null && _rainfall != null;

  Future<void> initialize() async {
    if (isLoaded) return;

    final results = await Future.wait([
      _loader.loadFloodAreas(
        assetPath: 'assets/data/ppc_flooding_area_wgs84.geojson',
      ),
      _loader.loadBarangayBoundaries(
        assetPath: 'assets/data/ppc_boundaries_wgs84.geojson',
      ),
      _loader.loadRainfallCsv(assetPath: 'assets/data/ppc_daily_data.csv'),
    ]);

    _floodData = results[0] as FloodDataCollection;
    _boundaries = results[1] as BarangayBoundariesCollection;
    _rainfall = results[2] as RainfallDataCollection;

    // ✅ Build model params using your real dataset distributions (files).
    final params = ModelParamsBuilder.buildFromFiles(
      boundaries: boundaries,
      floodData: floodData,
      rainfallData: rainfallData,
      // keep your calibrated coefficients (not random)
      baseCoefficients: ModelCoefficients.calibratedPpc(),
      intercept: -4.2,
    );

    _model = FloodRiskLogisticRegression(params: params);
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

  RainfallDataCollection get rainfallData {
    final v = _rainfall;
    if (v == null) throw StateError('FloodDataService not initialized');
    return v;
  }

  /// Main calculate using ML logistic regression
  LogisticFloodResult calculateFloodRiskML({
    required String barangayName,
    required double rainfallInMm,
  }) {
    final boundary = boundaries.findByName(barangayName);
    if (boundary == null) {
      throw StateError('Boundary not found for $barangayName');
    }

    final floodFeatures = floodData.getFeaturesForBarangay(barangayName);

    final totalAreaHa = _bestAreaHa(boundary);
    if (totalAreaHa <= 0) {
      throw StateError('Invalid barangay area for $barangayName');
    }

    final probability = _model.predictFloodProbability(
      rainfallInMm: rainfallInMm,
      floodFeatures: floodFeatures,
      totalBarangayAreaHa: totalAreaHa,
      isUrban: boundary.isUrban,
    );

    final riskLevel = _model.classify(probability);
    final confidence = _model.confidence(probability);

    final affectedArea = floodFeatures.fold<double>(
      0.0,
      (sum, f) => sum + f.properties.areaInHas,
    );

    return LogisticFloodResult(
      barangayName: barangayName,
      rainfallInMm: rainfallInMm,
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
        return 'There is a $pct% chance of flooding in your area...';
      case FloodRiskLevel.moderate:
        return 'There is a $pct% chance of flooding...';
      case FloodRiskLevel.low:
        return 'There is a $pct% chance of flooding...';
    }
  }

  /// ✅ Better barangay list:
  /// - uses boundaries list (complete)
  /// - not only those with flood features
  List<String> getAllBarangayNames() {
    final names =
        boundaries.features.map((f) => f.properties.brgyName).toSet().toList()
          ..sort();
    return names;
  }

  double _bestAreaHa(BarangayBoundaryFeature b) {
    // Some datasets use Area_has, others AreaInHect, sometimes one is 0.
    final a1 = b.properties.areaHas;
    final a2 = b.properties.areaInHect;
    return max(a1, a2);
  }
}
