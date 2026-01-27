// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flood_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloodDataCollection _$FloodDataCollectionFromJson(Map<String, dynamic> json) =>
    FloodDataCollection(
      type: json['type'] as String,
      name: json['name'] as String,
      crs: CoordinateReferenceSystem.fromJson(
        json['crs'] as Map<String, dynamic>,
      ),
      features: (json['features'] as List<dynamic>)
          .map((e) => FloodFeature.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FloodDataCollectionToJson(
  FloodDataCollection instance,
) => <String, dynamic>{
  'type': instance.type,
  'name': instance.name,
  'crs': instance.crs,
  'features': instance.features,
};

FloodFeature _$FloodFeatureFromJson(Map<String, dynamic> json) => FloodFeature(
  type: json['type'] as String,
  properties: FloodProperties.fromJson(
    json['properties'] as Map<String, dynamic>,
  ),
  geometry: FloodGeometry.fromJson(json['geometry'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FloodFeatureToJson(FloodFeature instance) =>
    <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
      'geometry': instance.geometry,
    };

FloodProperties _$FloodPropertiesFromJson(Map<String, dynamic> json) =>
    FloodProperties(
      fid: (json['fid'] as num).toDouble(),
      id: (json['ID'] as num).toDouble(),
      variation: json['Var'] as String,
      floodSusc: json['FloodSusc'] as String,
      sourceDat: json['Source_Dat'] as String,
      brgyName: json['BRGY_NAME'] as String,
      brgyType: json['BRGY_TYPE'] as String,
      brgyid: json['brgyid'] as String,
      finalClus: json['Final_Clus'] as String,
      areaInHas: (json['AreaInHas'] as num).toDouble(),
      composite: json['Composite_'] as String,
    );

Map<String, dynamic> _$FloodPropertiesToJson(FloodProperties instance) =>
    <String, dynamic>{
      'fid': instance.fid,
      'ID': instance.id,
      'Var': instance.variation,
      'FloodSusc': instance.floodSusc,
      'Source_Dat': instance.sourceDat,
      'BRGY_NAME': instance.brgyName,
      'BRGY_TYPE': instance.brgyType,
      'brgyid': instance.brgyid,
      'Final_Clus': instance.finalClus,
      'AreaInHas': instance.areaInHas,
      'Composite_': instance.composite,
    };

FloodGeometry _$FloodGeometryFromJson(Map<String, dynamic> json) =>
    FloodGeometry(
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

Map<String, dynamic> _$FloodGeometryToJson(FloodGeometry instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

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
