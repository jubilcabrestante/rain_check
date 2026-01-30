import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:rain_check/core/constant/geojson_data.dart';
import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';
import 'package:rain_check/core/utils/flood_data_extensions.dart';
import 'package:rain_check/features/calculate/flood_risk_logistic_regression_calibrated.dart';

enum RainfallIntensity {
  low(min: 170, max: 200, display: 'Low (170-200 mm)'),
  moderate(min: 200, max: 300, display: 'Moderate (200-300 mm)'),
  high(min: 300, max: 400, display: 'High (300-400 mm)');

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
    if (_floodData == null) {
      throw StateError('FloodDataService not initialized');
    }
    return _floodData!;
  }

  BarangayBoundariesCollection get boundaries {
    if (_boundaries == null) {
      throw StateError('FloodDataService not initialized');
    }
    return _boundaries!;
  }

  /// Calculate flood risk using ML model
  LogisticFloodResult calculateFloodRiskML({
    required String barangayName,
    required RainfallIntensity intensity,
  }) {
    final floodFeatures = floodData.getFeaturesForBarangay(barangayName);
    final boundary = boundaries.findByName(barangayName);

    if (boundary == null) {
      throw Exception('Barangay boundary not found for $barangayName');
    }

    final totalArea = boundary.properties.areaInHect;
    final isUrban = boundary.properties.brgyType.toLowerCase() == 'urban';
    final rainfallMm = intensity.midpoint;

    // ✅ Calculate probability
    final probability = _model.predictFloodProbability(
      rainfallInMm: rainfallMm,
      floodFeatures: floodFeatures,
      totalBarangayArea: totalArea,
      isUrban: isUrban,
    );

    final riskLevel = _model.classifyRisk(probability);
    final confidence = _model.getRiskConfidence(probability);

    // ✅ Calculate affected area
    final affectedArea = floodFeatures.fold<double>(
      0.0,
      (sum, feature) => sum + feature.properties.areaInHas,
    );

    // ✅ Generate appropriate message
    final message = _generateRiskMessage(riskLevel, probability);

    return LogisticFloodResult(
      barangayName: barangayName,
      rainfallInMm: rainfallMm,
      floodProbability: probability,
      predictedRiskLevel: riskLevel,
      riskConfidence: confidence,
      message: message,
      affectedAreaHectares: affectedArea,
    );
  }

  String _generateRiskMessage(FloodRiskLevel level, double probability) {
    final pct = (probability * 100).toStringAsFixed(0);

    switch (level) {
      case FloodRiskLevel.high:
        return 'There is a $pct% chance of flooding in your area. Stay safe and contact your local emergency services. At this risk level, keep monitoring updates, secure important items, unplug all appliances, and prepare an emergency go bag. Avoid low-lying areas and be ready to evacuate if authorities issue an alert and prepared.';

      case FloodRiskLevel.moderate:
        return 'There is a $pct% chance of flooding. Monitor weather updates and prepare for potential evacuation. Secure outdoor items and avoid low-lying areas.';

      case FloodRiskLevel.low:
        return 'There is a $pct% chance of flooding. Risk is low but stay alert to changing conditions. Avoid unnecessary travel to flood-prone areas.';

      default:
        return 'There is a $pct% chance of flooding. Conditions are currently favorable but continue to monitor weather updates.';
    }
  }

  List<String> getAllBarangayNames() {
    return floodData.uniqueBarangayNames;
  }

  BarangayBoundaryFeature? getBarangayBoundary(String barangayName) {
    return boundaries.findByName(barangayName);
  }
}
