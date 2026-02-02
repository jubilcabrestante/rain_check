// lib/features/calculate/widgets/flood_data_service.dart

import 'package:rain_check/core/enum/flood_risk_level.dart';
import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';
import 'package:rain_check/core/utils/data_loader.dart';
import 'package:rain_check/core/utils/flood_data_extensions.dart';
import 'package:rain_check/features/calculate/widgets/flood_risk_logistic_regression_calibrated.dart';

class FloodDataService {
  static final FloodDataService _instance = FloodDataService._internal();
  factory FloodDataService() => _instance;
  FloodDataService._internal();

  final DataLoader _loader = const DataLoader();

  FloodDataCollection? _floodData;
  BarangayBoundariesCollection? _boundaries;
  late final FloodRiskLogisticRegression _model;

  bool get isLoaded => _floodData != null && _boundaries != null;

  Future<void> initialize() async {
    if (isLoaded) return;

    final results = await Future.wait([
      _loader.loadFloodAreas(
        assetPath: 'assets/data/ppc_flooding_area_wgs84.geojson',
      ),
      _loader.loadBarangayBoundaries(
        assetPath: 'assets/data/ppc_boundaries_wgs84.geojson',
      ),
    ]);

    _floodData = results[0] as FloodDataCollection;
    _boundaries = results[1] as BarangayBoundariesCollection;

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
    required double rainfallInMm,
  }) {
    final boundary = boundaries.findByName(barangayName);
    if (boundary == null) {
      throw StateError('Boundary not found for $barangayName');
    }

    final floodFeatures = floodData.getFeaturesForBarangay(barangayName);
    final totalArea = boundary.properties.areaInHect;

    final probability = _model.predictFloodProbability(
      rainfallInMm: rainfallInMm,
      floodFeatures: floodFeatures,
      totalBarangayArea: totalArea,
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

  List<String> getAllBarangayNames() => floodData.uniqueBarangayNames;
}
