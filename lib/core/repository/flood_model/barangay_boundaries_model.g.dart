// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barangay_boundaries_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarangayBoundariesCollection _$BarangayBoundariesCollectionFromJson(
  Map<String, dynamic> json,
) => BarangayBoundariesCollection(
  type: json['type'] as String,
  name: json['name'] as String,
  crs: CoordinateReferenceSystem.fromJson(json['crs'] as Map<String, dynamic>),
  features: (json['features'] as List<dynamic>)
      .map((e) => BarangayBoundaryFeature.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BarangayBoundariesCollectionToJson(
  BarangayBoundariesCollection instance,
) => <String, dynamic>{
  'type': instance.type,
  'name': instance.name,
  'crs': instance.crs,
  'features': instance.features,
};

BarangayBoundaryFeature _$BarangayBoundaryFeatureFromJson(
  Map<String, dynamic> json,
) => BarangayBoundaryFeature(
  type: json['type'] as String,
  properties: BarangayBoundaryProperties.fromJson(
    json['properties'] as Map<String, dynamic>,
  ),
  geometry: BarangayGeometry.fromJson(json['geometry'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BarangayBoundaryFeatureToJson(
  BarangayBoundaryFeature instance,
) => <String, dynamic>{
  'type': instance.type,
  'properties': instance.properties,
  'geometry': instance.geometry,
};

BarangayBoundaryProperties _$BarangayBoundaryPropertiesFromJson(
  Map<String, dynamic> json,
) => BarangayBoundaryProperties(
  id: (json['ID'] as num).toInt(),
  brgyName: json['BRGY_NAME'] as String,
  brgyType: json['BRGY_TYPE'] as String,
  areaHas: (json['Area_has'] as num).toDouble(),
  areaInHect: (json['AreaInHect'] as num).toDouble(),
);

Map<String, dynamic> _$BarangayBoundaryPropertiesToJson(
  BarangayBoundaryProperties instance,
) => <String, dynamic>{
  'ID': instance.id,
  'BRGY_NAME': instance.brgyName,
  'BRGY_TYPE': instance.brgyType,
  'Area_has': instance.areaHas,
  'AreaInHect': instance.areaInHect,
};

BarangayGeometry _$BarangayGeometryFromJson(Map<String, dynamic> json) =>
    BarangayGeometry(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map(
            (e) => (e as List<dynamic>)
                .map(
                  (e) => (e as List<dynamic>)
                      .map(
                        (e) => (e as List<dynamic>)
                            .map((e) => (e as num).toDouble())
                            .toList(),
                      )
                      .toList(),
                )
                .toList(),
          )
          .toList(),
    );

Map<String, dynamic> _$BarangayGeometryToJson(BarangayGeometry instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
