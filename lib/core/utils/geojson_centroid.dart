import 'package:latlong2/latlong.dart';
import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';

class GeoJsonCentroid {
  const GeoJsonCentroid._();

  /// Bounds-center centroid (fast, stable for UI/weather).
  static LatLng boundsCenter(BarangayBoundaryFeature feature) {
    LatLng? firstPoint;

    double minLat = 0, maxLat = 0, minLng = 0, maxLng = 0;

    for (final polygon in feature.geometry.coordinates) {
      for (final ring in polygon) {
        for (final coord in ring) {
          final lng = coord[0];
          final lat = coord[1];

          if (firstPoint == null) {
            firstPoint = LatLng(lat, lng);
            minLat = maxLat = lat;
            minLng = maxLng = lng;
          } else {
            if (lat < minLat) minLat = lat;
            if (lat > maxLat) maxLat = lat;
            if (lng < minLng) minLng = lng;
            if (lng > maxLng) maxLng = lng;
          }
        }
      }
    }

    if (firstPoint == null) return const LatLng(9.7402, 118.7354);

    return LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);
  }
}
