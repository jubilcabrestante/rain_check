import 'package:json_annotation/json_annotation.dart';

part 'flood_data_model.g.dart';

/// Root model for flood susceptibility data
@JsonSerializable()
class FloodDataCollection {
  @JsonKey(name: 'type')
  final String type; // "FeatureCollection"

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'crs')
  final CoordinateReferenceSystem crs;

  @JsonKey(name: 'features')
  final List<FloodFeature> features;

  FloodDataCollection({
    required this.type,
    required this.name,
    required this.crs,
    required this.features,
  });

  factory FloodDataCollection.fromJson(Map<String, dynamic> json) =>
      _$FloodDataCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$FloodDataCollectionToJson(this);
}

/// Individual flood feature/area
@JsonSerializable()
class FloodFeature {
  @JsonKey(name: 'type')
  final String type; // "Feature"

  @JsonKey(name: 'properties')
  final FloodProperties properties;

  @JsonKey(name: 'geometry')
  final FloodGeometry geometry;

  FloodFeature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  factory FloodFeature.fromJson(Map<String, dynamic> json) =>
      _$FloodFeatureFromJson(json);

  Map<String, dynamic> toJson() => _$FloodFeatureToJson(this);
}

/// Properties of a flood-prone area
@JsonSerializable()
class FloodProperties {
  @JsonKey(name: 'fid')
  final double fid;

  @JsonKey(name: 'ID')
  final double id;

  @JsonKey(name: 'Var')
  final String variation; // "1", "2", "3"

  @JsonKey(name: 'FloodSusc')
  final String floodSusc; // HF, MF, LF

  @JsonKey(name: 'Source_Dat')
  final String sourceDat; // MGB, DOST-NOAH

  @JsonKey(name: 'BRGY_NAME')
  final String brgyName;

  @JsonKey(name: 'BRGY_TYPE')
  final String brgyType; // urban/rural

  @JsonKey(name: 'brgyid')
  final String brgyid;

  @JsonKey(name: 'Final_Clus')
  final String finalClus;

  @JsonKey(name: 'AreaInHas')
  final double areaInHas;

  @JsonKey(name: 'Composite_')
  final String composite;

  FloodProperties({
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

/// Geometry for flood areas (MultiPolygon)
@JsonSerializable()
class FloodGeometry {
  @JsonKey(name: 'type')
  final String type; // "MultiPolygon"

  @JsonKey(name: 'coordinates')
  final List<List<List<List<double>>>> coordinates;

  FloodGeometry({required this.type, required this.coordinates});

  factory FloodGeometry.fromJson(Map<String, dynamic> json) =>
      _$FloodGeometryFromJson(json);

  Map<String, dynamic> toJson() => _$FloodGeometryToJson(this);
}

/// Coordinate Reference System
@JsonSerializable()
class CoordinateReferenceSystem {
  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'properties')
  final CrsProperties properties;

  CoordinateReferenceSystem({required this.type, required this.properties});

  factory CoordinateReferenceSystem.fromJson(Map<String, dynamic> json) =>
      _$CoordinateReferenceSystemFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinateReferenceSystemToJson(this);
}

@JsonSerializable()
class CrsProperties {
  @JsonKey(name: 'name')
  final String name;

  CrsProperties({required this.name});

  factory CrsProperties.fromJson(Map<String, dynamic> json) =>
      _$CrsPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$CrsPropertiesToJson(this);
}

/// Enums for type safety
enum FloodSusceptibility {
  @JsonValue('HF')
  high,
  @JsonValue('MF')
  moderate,
  @JsonValue('LF')
  low,
}

enum DataSource {
  @JsonValue('MGB')
  mgb,
  @JsonValue('DOST-NOAH')
  dostNoah,
}

enum BarangayType {
  @JsonValue('urban')
  urban,
  @JsonValue('rural')
  rural,
}
