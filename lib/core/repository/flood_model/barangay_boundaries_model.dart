// lib/core/repository/flood_model/barangay_boundaries_model.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:rain_check/core/repository/flood_model/geojson_crs_model.dart';

part 'barangay_boundaries_model.g.dart';

@JsonSerializable()
class BarangayBoundariesCollection {
  final String type;
  final String name;
  final CoordinateReferenceSystem crs;
  final List<BarangayBoundaryFeature> features;

  const BarangayBoundariesCollection({
    required this.type,
    required this.name,
    required this.crs,
    required this.features,
  });

  factory BarangayBoundariesCollection.fromJson(Map<String, dynamic> json) =>
      _$BarangayBoundariesCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$BarangayBoundariesCollectionToJson(this);
}

@JsonSerializable()
class BarangayBoundaryFeature {
  final String type;
  final BarangayBoundaryProperties properties;
  final BarangayGeometry geometry;

  const BarangayBoundaryFeature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  factory BarangayBoundaryFeature.fromJson(Map<String, dynamic> json) =>
      _$BarangayBoundaryFeatureFromJson(json);

  Map<String, dynamic> toJson() => _$BarangayBoundaryFeatureToJson(this);
}

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

  const BarangayBoundaryProperties({
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

@JsonSerializable()
class BarangayGeometry {
  final String type;

  @JsonKey(fromJson: _coordsFromJson, toJson: _coordsToJson)
  final List<List<List<List<double>>>> coordinates;

  const BarangayGeometry({required this.type, required this.coordinates});

  factory BarangayGeometry.fromJson(Map<String, dynamic> json) =>
      _$BarangayGeometryFromJson(json);

  Map<String, dynamic> toJson() => _$BarangayGeometryToJson(this);

  // --------------------------
  // ✅ Accept Polygon OR MultiPolygon
  // --------------------------
  static List<List<List<List<double>>>> _coordsFromJson(dynamic raw) {
    if (raw is! List) return const [];

    // Polygon: [[[x,y],...], ...]
    // MultiPolygon: [[[[x,y],...], ...], ...]
    final bool isPolygon =
        raw.isNotEmpty &&
        raw[0] is List &&
        (raw[0] as List).isNotEmpty &&
        (raw[0] as List)[0] is List &&
        ((raw[0] as List)[0] as List).isNotEmpty &&
        (((raw[0] as List)[0] as List)[0] is num);

    if (isPolygon) {
      // Wrap polygon into MultiPolygon
      final poly = (raw)
          .map<List<List<double>>>(
            (ring) => (ring as List)
                .map<List<double>>(
                  (pt) =>
                      (pt as List).map((e) => (e as num).toDouble()).toList(),
                )
                .toList(),
          )
          .toList();

      return [poly];
    }

    // MultiPolygon
    return (raw)
        .map<List<List<List<double>>>>(
          (polygon) => (polygon as List)
              .map<List<List<double>>>(
                (ring) => (ring as List)
                    .map<List<double>>(
                      (pt) => (pt as List)
                          .map((e) => (e as num).toDouble())
                          .toList(),
                    )
                    .toList(),
              )
              .toList(),
        )
        .toList();
  }

  static dynamic _coordsToJson(List<List<List<List<double>>>> value) => value;
}
