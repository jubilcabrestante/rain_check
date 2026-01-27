import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:rain_check/core/constant/geojson_data.dart';
import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';
import 'package:rain_check/core/utils/flood_data_extensions.dart';

/// Rainfall intensity thresholds (in mm)
enum RainfallIntensity {
  low(min: 170, max: 200),
  moderate(min: 200, max: 300),
  high(min: 300, max: 400);

  final double min;
  final double max;

  const RainfallIntensity({required this.min, required this.max});

  bool contains(double rainfall) => rainfall >= min && rainfall <= max;

  static RainfallIntensity? fromValue(double rainfall) {
    if (rainfall < 170) return null; // Too low to calculate
    if (rainfall > 400) return high; // Cap at high

    return RainfallIntensity.values.firstWhere(
      (intensity) => intensity.contains(rainfall),
      orElse: () => high, // Default to high if above range
    );
  }
}

/// Service for loading and querying flood data
/// This is a SINGLETON - only loads data once
class FloodDataService {
  // Singleton instance
  static final FloodDataService _instance = FloodDataService._internal();
  factory FloodDataService() => _instance;
  FloodDataService._internal();

  // Cached data (loaded once)
  FloodDataCollection? _floodData;
  BarangayBoundariesCollection? _boundaries;

  // Asset paths

  /// Check if data is loaded
  bool get isLoaded => _floodData != null && _boundaries != null;

  /// Initialize - call this once at app start
  Future<void> initialize() async {
    if (isLoaded) return; // Already loaded

    // Load both JSON files in parallel
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
  }

  /// Get flood data (ensures data is loaded)
  FloodDataCollection get floodData {
    if (_floodData == null) {
      throw StateError(
        'FloodDataService not initialized. Call initialize() first.',
      );
    }
    return _floodData!;
  }

  /// Get boundaries data (ensures data is loaded)
  BarangayBoundariesCollection get boundaries {
    if (_boundaries == null) {
      throw StateError(
        'FloodDataService not initialized. Call initialize() first.',
      );
    }
    return _boundaries!;
  }

  /// Calculate flood risk for a barangay based on rainfall
  FloodCalculationResult calculateFloodRisk({
    required String barangayName,
    required double rainfallInMm,
  }) {
    // Get rainfall intensity level
    final intensity = RainfallIntensity.fromValue(rainfallInMm);

    if (intensity == null) {
      return FloodCalculationResult(
        barangayName: barangayName,
        rainfallInMm: rainfallInMm,
        hasFloodRisk: false,
        message: 'Rainfall too low ($rainfallInMm mm) to calculate flood risk.',
      );
    }

    // Get flood features for this barangay
    final floodFeatures = floodData.getFeaturesForBarangay(barangayName);

    if (floodFeatures.isEmpty) {
      return FloodCalculationResult(
        barangayName: barangayName,
        rainfallInMm: rainfallInMm,
        hasFloodRisk: false,
        message: 'No flood data available for $barangayName.',
      );
    }

    // Determine if there's flood risk based on intensity and flood susceptibility
    final hasHighRisk = floodFeatures.any(
      (f) => f.properties.riskLevel == FloodRiskLevel.high,
    );
    final hasModerateRisk = floodFeatures.any(
      (f) => f.properties.riskLevel == FloodRiskLevel.moderate,
    );

    // Calculate risk based on rainfall intensity + area susceptibility
    bool hasFloodRisk = false;
    FloodRiskLevel? overallRisk;
    String message = '';

    switch (intensity) {
      case RainfallIntensity.low:
        // Low rainfall only triggers if there's high susceptibility areas
        hasFloodRisk = hasHighRisk;
        overallRisk = hasHighRisk
            ? FloodRiskLevel.moderate
            : FloodRiskLevel.low;
        message = hasHighRisk
            ? 'Low rainfall detected. Flooding possible in high-risk zones.'
            : 'Low rainfall. Minimal flood risk.';
        break;

      case RainfallIntensity.moderate:
        // Moderate rainfall triggers if moderate or high susceptibility
        hasFloodRisk = hasModerateRisk || hasHighRisk;
        overallRisk = hasHighRisk
            ? FloodRiskLevel.high
            : FloodRiskLevel.moderate;
        message = hasFloodRisk
            ? 'Moderate rainfall detected. Flooding likely in susceptible areas.'
            : 'Moderate rainfall. Low flood risk.';
        break;

      case RainfallIntensity.high:
        // High rainfall always triggers flood risk
        hasFloodRisk = true;
        overallRisk = FloodRiskLevel.high;
        message = 'High rainfall detected! Flooding highly probable.';
        break;
    }

    // Calculate affected area
    final totalAffectedArea = floodFeatures.fold<double>(
      0.0,
      (sum, feature) => sum + feature.properties.areaInHas,
    );

    return FloodCalculationResult(
      barangayName: barangayName,
      rainfallInMm: rainfallInMm,
      rainfallIntensity: intensity,
      hasFloodRisk: hasFloodRisk,
      overallRiskLevel: overallRisk,
      affectedAreaHectares: totalAffectedArea,
      highRiskZones: floodFeatures
          .where((f) => f.properties.riskLevel == FloodRiskLevel.high)
          .length,
      moderateRiskZones: floodFeatures
          .where((f) => f.properties.riskLevel == FloodRiskLevel.moderate)
          .length,
      lowRiskZones: floodFeatures
          .where((f) => f.properties.riskLevel == FloodRiskLevel.low)
          .length,
      message: message,
      floodFeatures: floodFeatures,
    );
  }

  /// Get all unique barangay names
  List<String> getAllBarangayNames() {
    return floodData.uniqueBarangayNames;
  }

  /// Get barangay boundary
  BarangayBoundaryFeature? getBarangayBoundary(String barangayName) {
    return boundaries.findByName(barangayName);
  }
}

/// Result of flood risk calculation
class FloodCalculationResult {
  final String barangayName;
  final double rainfallInMm;
  final RainfallIntensity? rainfallIntensity;
  final bool hasFloodRisk;
  final FloodRiskLevel? overallRiskLevel;
  final double? affectedAreaHectares;
  final int? highRiskZones;
  final int? moderateRiskZones;
  final int? lowRiskZones;
  final String message;
  final List<FloodFeature>? floodFeatures;

  FloodCalculationResult({
    required this.barangayName,
    required this.rainfallInMm,
    this.rainfallIntensity,
    required this.hasFloodRisk,
    this.overallRiskLevel,
    this.affectedAreaHectares,
    this.highRiskZones,
    this.moderateRiskZones,
    this.lowRiskZones,
    required this.message,
    this.floodFeatures,
  });

  String get formattedAffectedArea {
    if (affectedAreaHectares == null) return 'N/A';
    return '${affectedAreaHectares!.toStringAsFixed(2)} hectares';
  }

  String get riskLevelDisplay {
    return overallRiskLevel?.displayName ?? 'Unknown';
  }

  String get rainfallIntensityDisplay {
    return rainfallIntensity?.name.toUpperCase() ?? 'N/A';
  }
}
