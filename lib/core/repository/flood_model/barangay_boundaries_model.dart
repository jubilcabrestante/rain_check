import 'package:json_annotation/json_annotation.dart';

part 'barangay_boundaries_model.g.dart';

/// Root model for barangay boundaries data
@JsonSerializable()
class BarangayBoundariesCollection {
  final String type;
  final String name;
  final CoordinateReferenceSystem crs;
  final List<BarangayBoundaryFeature> features;

  BarangayBoundariesCollection({
    required this.type,
    required this.name,
    required this.crs,
    required this.features,
  });

  factory BarangayBoundariesCollection.fromJson(Map<String, dynamic> json) =>
      _$BarangayBoundariesCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$BarangayBoundariesCollectionToJson(this);
}

/// Individual barangay boundary feature
@JsonSerializable()
class BarangayBoundaryFeature {
  final String type;
  final BarangayBoundaryProperties properties;
  final BarangayGeometry geometry;

  BarangayBoundaryFeature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  factory BarangayBoundaryFeature.fromJson(Map<String, dynamic> json) =>
      _$BarangayBoundaryFeatureFromJson(json);

  Map<String, dynamic> toJson() => _$BarangayBoundaryFeatureToJson(this);
}

/// Properties of a barangay boundary
@JsonSerializable()
class BarangayBoundaryProperties {
  @JsonKey(name: 'ID')
  final int id;

  @JsonKey(name: 'BRGY_NAME')
  final String brgyName;

  @JsonKey(name: 'BRGY_TYPE')
  final String brgyType;

  @JsonKey(name: 'Area_has')
  final double areaHas;

  @JsonKey(name: 'AreaInHect')
  final double areaInHect;

  BarangayBoundaryProperties({
    required this.id,
    required this.brgyName,
    required this.brgyType,
    required this.areaHas,
    required this.areaInHect,
  });

  factory BarangayBoundaryProperties.fromJson(Map<String, dynamic> json) =>
      _$BarangayBoundaryPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$BarangayBoundaryPropertiesToJson(this);
}

/// Geometry for barangay boundaries (MultiPolygon)
@JsonSerializable()
class BarangayGeometry {
  final String type;
  final List<List<List<List<double>>>> coordinates;

  BarangayGeometry({required this.type, required this.coordinates});

  factory BarangayGeometry.fromJson(Map<String, dynamic> json) =>
      _$BarangayGeometryFromJson(json);

  Map<String, dynamic> toJson() => _$BarangayGeometryToJson(this);
}

/// Coordinate Reference System
@JsonSerializable()
class CoordinateReferenceSystem {
  final String type;
  final CrsProperties properties;

  CoordinateReferenceSystem({required this.type, required this.properties});

  factory CoordinateReferenceSystem.fromJson(Map<String, dynamic> json) =>
      _$CoordinateReferenceSystemFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinateReferenceSystemToJson(this);
}

@JsonSerializable()
class CrsProperties {
  final String name;

  CrsProperties({required this.name});

  factory CrsProperties.fromJson(Map<String, dynamic> json) =>
      _$CrsPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$CrsPropertiesToJson(this);
}
