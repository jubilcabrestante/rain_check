// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rainfall_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RainfallDataPoint _$RainfallDataPointFromJson(Map<String, dynamic> json) =>
    RainfallDataPoint(
      year: (json['YEAR'] as num).toInt(),
      month: (json['MONTH'] as num).toInt(),
      day: (json['DAY'] as num).toInt(),
      rainfall: RainfallDataPoint._rainfallFromCsv(json['RAINFALL']),
      tmax: RainfallDataPoint._nullableDoubleFromCsv(json['TMAX']),
      tmin: RainfallDataPoint._nullableDoubleFromCsv(json['TMIN']),
      relativeHumidity: RainfallDataPoint._nullableDoubleFromCsv(json['RH']),
      windSpeed: RainfallDataPoint._nullableDoubleFromCsv(json['WIND_SPEED']),
      windDirection: RainfallDataPoint._nullableDoubleFromCsv(
        json['WIND_DIRECTION'],
      ),
    );

Map<String, dynamic> _$RainfallDataPointToJson(RainfallDataPoint instance) =>
    <String, dynamic>{
      'YEAR': instance.year,
      'MONTH': instance.month,
      'DAY': instance.day,
      'RAINFALL': instance.rainfall,
      'TMAX': instance.tmax,
      'TMIN': instance.tmin,
      'RH': instance.relativeHumidity,
      'WIND_SPEED': instance.windSpeed,
      'WIND_DIRECTION': instance.windDirection,
    };

RainfallDataCollection _$RainfallDataCollectionFromJson(
  Map<String, dynamic> json,
) => RainfallDataCollection(
  data: (json['data'] as List<dynamic>)
      .map((e) => RainfallDataPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
  source: json['source'] as String,
  station: json['station'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  elevation: (json['elevation'] as num).toDouble(),
);

Map<String, dynamic> _$RainfallDataCollectionToJson(
  RainfallDataCollection instance,
) => <String, dynamic>{
  'data': instance.data,
  'source': instance.source,
  'station': instance.station,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'elevation': instance.elevation,
};
