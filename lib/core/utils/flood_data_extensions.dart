import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';

/// Extensions for FloodProperties
extension FloodPropertiesX on FloodProperties {
  /// Get flood risk level
  FloodRiskLevel get riskLevel {
    switch (floodSusc) {
      case 'HF':
        return FloodRiskLevel.high;
      case 'MF':
        return FloodRiskLevel.moderate;
      case 'LF':
        return FloodRiskLevel.low;
      default:
        return FloodRiskLevel.unknown;
    }
  }

  /// Get color for flood risk (for map visualization)
  String get riskColor {
    switch (riskLevel) {
      case FloodRiskLevel.high:
        return '#D32F2F'; // Red
      case FloodRiskLevel.moderate:
        return '#FBC02D'; // Yellow
      case FloodRiskLevel.low:
        return '#388E3C'; // Green
      case FloodRiskLevel.unknown:
        return '#757575'; // Grey
    }
  }

  /// Check if data is from MGB
  bool get isFromMgb => sourceDat == 'MGB';

  /// Check if data is from DOST-NOAH
  bool get isFromDostNoah => sourceDat == 'DOST-NOAH';

  /// Get formatted area string
  String get formattedArea => '${areaInHas.toStringAsFixed(2)} hectares';
}

/// Extensions for FloodFeature
extension FloodFeatureX on FloodFeature {
  /// Check if this feature is for a specific barangay
  bool isForBarangay(String barangayName) {
    return properties.brgyName.toLowerCase() == barangayName.toLowerCase();
  }
}

/// Extensions for FloodDataCollection
extension FloodDataCollectionX on FloodDataCollection {
  /// Get all features for a specific barangay
  List<FloodFeature> getFeaturesForBarangay(String barangayName) {
    return features
        .where((feature) => feature.isForBarangay(barangayName))
        .toList();
  }

  /// Get all high-risk areas
  List<FloodFeature> get highRiskAreas {
    return features
        .where((feature) => feature.properties.riskLevel == FloodRiskLevel.high)
        .toList();
  }

  /// Get all moderate-risk areas
  List<FloodFeature> get moderateRiskAreas {
    return features
        .where(
          (feature) => feature.properties.riskLevel == FloodRiskLevel.moderate,
        )
        .toList();
  }

  /// Get all low-risk areas
  List<FloodFeature> get lowRiskAreas {
    return features
        .where((feature) => feature.properties.riskLevel == FloodRiskLevel.low)
        .toList();
  }

  /// Calculate total flood-prone area
  double get totalFloodProneArea {
    return features.fold(
      0.0,
      (sum, feature) => sum + feature.properties.areaInHas,
    );
  }

  /// Get unique barangay names
  List<String> get uniqueBarangayNames {
    return features
        .map((feature) => feature.properties.brgyName)
        .toSet()
        .toList()
      ..sort();
  }
}

/// Extensions for BarangayBoundaryFeature
extension BarangayBoundaryFeatureX on BarangayBoundaryFeature {
  /// Check if barangay is urban
  bool get isUrban => properties.brgyType.toLowerCase() == 'urban';

  /// Check if barangay is rural
  bool get isRural => properties.brgyType.toLowerCase() == 'rural';

  /// Get formatted area
  String get formattedArea => '${properties.areaHas.toStringAsFixed(2)} ha';
}

/// Extensions for BarangayBoundariesCollection
extension BarangayBoundariesCollectionX on BarangayBoundariesCollection {
  /// Find barangay by name
  BarangayBoundaryFeature? findByName(String name) {
    try {
      return features.firstWhere(
        (feature) =>
            feature.properties.brgyName.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all urban barangays
  List<BarangayBoundaryFeature> get urbanBarangays {
    return features.where((feature) => feature.isUrban).toList();
  }

  /// Get all rural barangays
  List<BarangayBoundaryFeature> get ruralBarangays {
    return features.where((feature) => feature.isRural).toList();
  }

  /// Calculate total area
  double get totalArea {
    return features.fold(
      0.0,
      (sum, feature) => sum + feature.properties.areaHas,
    );
  }
}

/// Enum for flood risk levels
enum FloodRiskLevel { high, moderate, low, unknown }

/// Extension for FloodRiskLevel
extension FloodRiskLevelX on FloodRiskLevel {
  String get displayName {
    switch (this) {
      case FloodRiskLevel.high:
        return 'High Risk';
      case FloodRiskLevel.moderate:
        return 'Moderate Risk';
      case FloodRiskLevel.low:
        return 'Low Risk';
      case FloodRiskLevel.unknown:
        return 'Unknown';
    }
  }

  String get description {
    switch (this) {
      case FloodRiskLevel.high:
        return 'Areas with high probability of flooding';
      case FloodRiskLevel.moderate:
        return 'Areas with moderate probability of flooding';
      case FloodRiskLevel.low:
        return 'Areas with low probability of flooding';
      case FloodRiskLevel.unknown:
        return 'Risk level not determined';
    }
  }
}
