// lib/core/utils/flood_data_extensions.dart

import 'package:rain_check/core/enum/flood_risk_level.dart';
import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';

extension FloodPropertiesX on FloodProperties {
  FloodRiskLevel get riskLevel => switch (floodSusc) {
    'HF' => FloodRiskLevel.high,
    'MF' => FloodRiskLevel.moderate,
    'LF' => FloodRiskLevel.low,
    _ => FloodRiskLevel.low,
  };

  bool get isFromMgb => sourceDat == 'MGB';
  bool get isFromDostNoah => sourceDat == 'DOST-NOAH';
  String get formattedArea => '${areaInHas.toStringAsFixed(2)} hectares';
}

extension FloodFeatureX on FloodFeature {
  bool isForBarangay(String barangayName) =>
      properties.brgyName.toLowerCase() == barangayName.toLowerCase();
}

extension FloodDataCollectionX on FloodDataCollection {
  List<FloodFeature> getFeaturesForBarangay(String barangayName) =>
      features.where((f) => f.isForBarangay(barangayName)).toList();

  List<String> get uniqueBarangayNames =>
      (features.map((f) => f.properties.brgyName).toSet().toList()..sort());

  double get totalFloodProneArea =>
      features.fold(0.0, (sum, f) => sum + f.properties.areaInHas);
}

extension BarangayBoundaryFeatureX on BarangayBoundaryFeature {
  bool get isUrban => properties.brgyType.toLowerCase() == 'urban';
  bool get isRural => properties.brgyType.toLowerCase() == 'rural';
  String get formattedArea => '${properties.areaHas.toStringAsFixed(2)} ha';
}

extension BarangayBoundariesCollectionX on BarangayBoundariesCollection {
  BarangayBoundaryFeature? findByName(String name) {
    final n = name.toLowerCase();
    for (final f in features) {
      if (f.properties.brgyName.toLowerCase() == n) return f;
    }
    return null;
  }

  List<BarangayBoundaryFeature> get urbanBarangays =>
      features.where((f) => f.isUrban).toList();

  List<BarangayBoundaryFeature> get ruralBarangays =>
      features.where((f) => f.isRural).toList();

  double get totalArea =>
      features.fold(0.0, (sum, f) => sum + f.properties.areaHas);
}
