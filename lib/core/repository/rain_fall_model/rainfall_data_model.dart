import 'package:json_annotation/json_annotation.dart';

part 'rainfall_data_model.g.dart';

@JsonSerializable()
class RainfallDataPoint {
  @JsonKey(name: 'YEAR', fromJson: _intFromCsv)
  final int year;

  @JsonKey(name: 'MONTH', fromJson: _intFromCsv)
  final int month;

  @JsonKey(name: 'DAY', fromJson: _intFromCsv)
  final int day;

  /// Raw rainfall from CSV:
  /// -999.0 = missing
  /// -1.0   = trace (<0.1mm)
  @JsonKey(name: 'RAINFALL', fromJson: _doubleFromCsv)
  final double rainfall;

  @JsonKey(name: 'TMAX', fromJson: _nullableDoubleFromCsv)
  final double? tmax;

  @JsonKey(name: 'TMIN', fromJson: _nullableDoubleFromCsv)
  final double? tmin;

  @JsonKey(name: 'RH', fromJson: _nullableDoubleFromCsv)
  final double? relativeHumidity;

  @JsonKey(name: 'WIND_SPEED', fromJson: _nullableDoubleFromCsv)
  final double? windSpeed;

  @JsonKey(name: 'WIND_DIRECTION', fromJson: _nullableDoubleFromCsv)
  final double? windDirection;

  const RainfallDataPoint({
    required this.year,
    required this.month,
    required this.day,
    required this.rainfall,
    this.tmax,
    this.tmin,
    this.relativeHumidity,
    this.windSpeed,
    this.windDirection,
  });

  @JsonKey()
  DateTime get date => DateTime(year, month, day);

  /// ✅ Cleaned rainfall for modeling:
  /// - missing -> null
  /// - trace (-1) -> 0.05mm
  /// - negative -> null
  double? get rainfallMm {
    if (rainfall == -999.0) return null;
    if (rainfall == -1.0) return 0.05;
    if (rainfall < 0) return null;
    return rainfall;
  }

  factory RainfallDataPoint.fromJson(Map<String, dynamic> json) =>
      _$RainfallDataPointFromJson(json);

  Map<String, dynamic> toJson() => _$RainfallDataPointToJson(this);

  static int _intFromCsv(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      final s = v.trim();
      if (s.isEmpty) return 0;
      return int.tryParse(s) ?? 0;
    }
    return 0;
  }

  static double _doubleFromCsv(dynamic v) {
    final d = _doubleOrNull(v);
    return d ?? 0.0;
  }

  static double? _nullableDoubleFromCsv(dynamic v) {
    final d = _doubleOrNull(v);
    if (d == null) return null;
    if (d == -999.0) return null;
    if (d == -1.0) return 0.0;
    return d;
  }

  static double? _doubleOrNull(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) {
      final s = v.trim();
      if (s.isEmpty) return null;
      return double.tryParse(s);
    }
    return null;
  }
}

@JsonSerializable()
class RainfallDataCollection {
  @JsonKey(name: 'data')
  final List<RainfallDataPoint> data;

  final String source;
  final String station;
  final double latitude;
  final double longitude;
  final double elevation;

  const RainfallDataCollection({
    required this.data,
    required this.source,
    required this.station,
    required this.latitude,
    required this.longitude,
    required this.elevation,
  });

  factory RainfallDataCollection.fromJson(Map<String, dynamic> json) =>
      _$RainfallDataCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$RainfallDataCollectionToJson(this);
}
