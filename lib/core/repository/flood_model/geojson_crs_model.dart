import 'package:json_annotation/json_annotation.dart';

part 'geojson_crs_model.g.dart';

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
