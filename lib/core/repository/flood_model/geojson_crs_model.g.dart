// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geojson_crs_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoordinateReferenceSystem _$CoordinateReferenceSystemFromJson(
  Map<String, dynamic> json,
) => CoordinateReferenceSystem(
  type: json['type'] as String,
  properties: CrsProperties.fromJson(
    json['properties'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CoordinateReferenceSystemToJson(
  CoordinateReferenceSystem instance,
) => <String, dynamic>{
  'type': instance.type,
  'properties': instance.properties,
};

CrsProperties _$CrsPropertiesFromJson(Map<String, dynamic> json) =>
    CrsProperties(name: json['name'] as String);

Map<String, dynamic> _$CrsPropertiesToJson(CrsProperties instance) =>
    <String, dynamic>{'name': instance.name};
