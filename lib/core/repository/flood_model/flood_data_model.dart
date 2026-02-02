// lib/core/repository/flood_model/flood_data_model.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:rain_check/features/calculate/model/geojson_crs_model.dart';

part 'flood_data_model.g.dart';

@JsonSerializable()
class FloodDataCollection {
  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'crs')
  final CoordinateReferenceSystem crs;

  @JsonKey(name: 'features')
  final List<FloodFeature> features;

  const FloodDataCollection({
    required this.type,
    required this.name,
    required this.crs,
    required this.features,
  });

  factory FloodDataCollection.fromJson(Map<String, dynamic> json) =>
      _$FloodDataCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$FloodDataCollectionToJson(this);
}

@JsonSerializable()
class FloodFeature {
  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'properties')
  final FloodProperties properties;

  @JsonKey(name: 'geometry')
  final FloodGeometry geometry;

  const FloodFeature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  factory FloodFeature.fromJson(Map<String, dynamic> json) =>
      _$FloodFeatureFromJson(json);

  Map<String, dynamic> toJson() => _$FloodFeatureToJson(this);
}

@JsonSerializable()
class FloodProperties {
  @JsonKey(name: 'fid')
  final double fid;

  @JsonKey(name: 'ID')
  final double id;

  @JsonKey(name: 'Var')
  final String variation;

  @JsonKey(name: 'FloodSusc')
  final String floodSusc; // HF / MF / LF

  @JsonKey(name: 'Source_Dat')
  final String sourceDat;

  @JsonKey(name: 'BRGY_NAME')
  final String brgyName;

  @JsonKey(name: 'BRGY_TYPE')
  final String brgyType;

  @JsonKey(name: 'brgyid')
  final String brgyid;

  @JsonKey(name: 'Final_Clus')
  final String finalClus;

  @JsonKey(name: 'AreaInHas')
  final double areaInHas;

  @JsonKey(name: 'Composite_')
  final String composite;

  const FloodProperties({
    required this.fid,
    required this.id,
    required this.variation,
    required this.floodSusc,
    required this.sourceDat,
    required this.brgyName,
    required this.brgyType,
    required this.brgyid,
    required this.finalClus,
    required this.areaInHas,
    required this.composite,
  });

  factory FloodProperties.fromJson(Map<String, dynamic> json) =>
      _$FloodPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$FloodPropertiesToJson(this);
}

@JsonSerializable()
class FloodGeometry {
  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'coordinates')
  final List<List<List<List<double>>>> coordinates;

  const FloodGeometry({required this.type, required this.coordinates});

  factory FloodGeometry.fromJson(Map<String, dynamic> json) =>
      _$FloodGeometryFromJson(json);

  Map<String, dynamic> toJson() => _$FloodGeometryToJson(this);
}
