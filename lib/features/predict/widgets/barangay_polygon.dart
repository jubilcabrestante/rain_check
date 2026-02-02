import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:rain_check/core/enum/flood_risk_level.dart';

import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/features/predict/domain/models/barangay_flood_risk.dart';

class BarangayPolygon {
  final BarangayBoundaryFeature feature;
  final BarangayFloodRisk riskData;

  const BarangayPolygon({required this.feature, required this.riskData});

  /// Returns list of rings (MultiPolygon support).
  /// ✅ Ensures ring is closed (first == last).
  List<List<LatLng>> get polygonPoints {
    final all = <List<LatLng>>[];

    for (final polygon in feature.geometry.coordinates) {
      for (final ring in polygon) {
        final pts = ring.map((coord) {
          final lng = coord[0];
          final lat = coord[1];
          return LatLng(lat, lng);
        }).toList();

        if (pts.length >= 4) {
          // ✅ better: polygon needs at least 4 points when closed
          final first = pts.first;
          final last = pts.last;
          if (first.latitude != last.latitude ||
              first.longitude != last.longitude) {
            pts.add(first);
          }
          all.add(pts);
        }
      }
    }

    return all;
  }

  Color get fillColor {
    final base = _hexToColor(riskData.riskLevel.colorHex);
    return base.withValues(alpha: 0.40);
  }

  Color get borderColor {
    final base = _hexToColor(riskData.riskLevel.colorHex);
    return base.withValues(alpha: 0.95);
  }

  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
