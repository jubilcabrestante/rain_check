import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/features/predict/domain/models/barangay_flood_risk.dart';
import 'package:rain_check/features/predict/widgets/barangay_info_pin.dart';
import 'package:rain_check/features/predict/widgets/barangay_polygon.dart';

class FloodRiskMap extends StatefulWidget {
  final BarangayBoundariesCollection boundaries;
  final Map<String, BarangayFloodRisk> riskDataMap;

  /// Controlled selection from parent (Cubit)
  final String? selectedBarangayName;

  /// Controlled pin visibility from parent (Cubit)
  final bool showInfoPin;

  /// Map -> parent callback (tap polygon)
  final ValueChanged<String?>? onBarangaySelected;

  /// Pin close callback
  final VoidCallback? onClosePin;

  const FloodRiskMap({
    super.key,
    required this.boundaries,
    required this.riskDataMap,
    this.selectedBarangayName,
    this.showInfoPin = false,
    this.onBarangaySelected,
    this.onClosePin,
  });

  @override
  State<FloodRiskMap> createState() => _FloodRiskMapState();
}

class _FloodRiskMapState extends State<FloodRiskMap> {
  final MapController _mapController = MapController();

  late List<_TapPolygon> _tapPolygons;

  @override
  void initState() {
    super.initState();
    _tapPolygons = _buildTapPolygons();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitBounds(_boundsOfAllFeatures());
    });
  }

  @override
  void didUpdateWidget(covariant FloodRiskMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Rebuild tap polygons if inputs changed
    if (oldWidget.boundaries != widget.boundaries ||
        oldWidget.riskDataMap != widget.riskDataMap) {
      _tapPolygons = _buildTapPolygons();
    }

    // Dropdown (or external) selection changed -> zoom to barangay
    if (oldWidget.selectedBarangayName != widget.selectedBarangayName &&
        (widget.selectedBarangayName ?? '').isNotEmpty) {
      final f = _findFeature(widget.selectedBarangayName!);
      if (f != null) _fitBounds(_boundsOfFeature(f));
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = (widget.selectedBarangayName ?? '').trim();
    final hasSelected = selected.isNotEmpty;

    final pinFeature = hasSelected ? _findFeature(selected) : null;
    final pinPos = pinFeature != null ? _centerOfFeature(pinFeature) : null;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(9.7402, 118.7354),
        initialZoom: 12,
        minZoom: 10,
        maxZoom: 18,
        onTap: (tapPosition, latLng) => _handleTap(latLng),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.rain_check',
        ),

        PolygonLayer(polygons: _buildPolygons()),
        MarkerLayer(markers: _buildBarangayLabels()),

        // ✅ Info pin (controlled by Cubit)
        if (widget.showInfoPin && hasSelected && pinPos != null)
          MarkerLayer(
            markers: [
              Marker(
                point: pinPos,
                width: 300,
                height: 210,
                child: BarangayInfoPin(
                  riskData:
                      widget.riskDataMap[selected] ??
                      BarangayFloodRisk.defaultLow(selected),
                  onClose: widget.onClosePin,
                ),
              ),
            ],
          ),
      ],
    );
  }

  // --------------------------
  // Tap -> select barangay
  // --------------------------
  void _handleTap(LatLng tap) {
    final hit = _tapPolygons.firstWhere(
      (p) => _pointInPolygon(tap, p.points),
      orElse: () => const _TapPolygon.empty(),
    );

    if (!hit.isValid) {
      widget.onBarangaySelected?.call(null);
      return;
    }

    // ✅ Select barangay in Cubit -> dropdown updates + pin can show
    widget.onBarangaySelected?.call(hit.name);
  }

  // --------------------------
  // Build polygons
  // --------------------------
  List<Polygon> _buildPolygons() {
    final polygons = <Polygon>[];

    for (final feature in widget.boundaries.features) {
      final name = feature.properties.brgyName;
      final risk =
          widget.riskDataMap[name] ?? BarangayFloodRisk.defaultLow(name);

      final poly = BarangayPolygon(feature: feature, riskData: risk);

      for (final ring in poly.polygonPoints) {
        polygons.add(
          Polygon(
            points: ring,
            color: poly.fillColor,
            isFilled: true,
            borderColor: poly.borderColor,
            borderStrokeWidth: 2.0,
          ),
        );
      }
    }

    return polygons;
  }

  // --------------------------
  // Labels
  // --------------------------
  List<Marker> _buildBarangayLabels() {
    final markers = <Marker>[];

    for (final feature in widget.boundaries.features) {
      final name = feature.properties.brgyName;
      final center = _centerOfFeature(feature);

      markers.add(
        Marker(
          point: center,
          width: 120,
          height: 28,
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  // --------------------------
  // Feature lookup
  // --------------------------
  BarangayBoundaryFeature? _findFeature(String name) {
    final n = name.trim().toLowerCase();
    for (final f in widget.boundaries.features) {
      if (f.properties.brgyName.trim().toLowerCase() == n) return f;
    }
    return null;
  }

  // --------------------------
  // Tap polygons for hit-testing
  // --------------------------
  List<_TapPolygon> _buildTapPolygons() {
    final list = <_TapPolygon>[];

    for (final feature in widget.boundaries.features) {
      final name = feature.properties.brgyName;
      final risk =
          widget.riskDataMap[name] ?? BarangayFloodRisk.defaultLow(name);

      final poly = BarangayPolygon(feature: feature, riskData: risk);

      for (final ring in poly.polygonPoints) {
        final center = _centerOfPoints(ring);
        list.add(_TapPolygon(name: name, points: ring, center: center));
      }
    }

    // Prefer smaller polygons first? Usually you want smaller “inside” polygons to win.
    // Sorting by area ASC helps inner polygons be hit first.
    list.sort(
      (a, b) => _polygonArea(a.points).compareTo(_polygonArea(b.points)),
    );
    return list;
  }

  bool _pointInPolygon(LatLng p, List<LatLng> poly) {
    if (poly.length < 3) return false;

    final x = p.longitude;
    final y = p.latitude;

    var inside = false;
    for (int i = 0, j = poly.length - 1; i < poly.length; j = i++) {
      final xi = poly[i].longitude, yi = poly[i].latitude;
      final xj = poly[j].longitude, yj = poly[j].latitude;

      final denom = (yj - yi) == 0 ? 1e-12 : (yj - yi);
      final intersect =
          ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / denom + xi);

      if (intersect) inside = !inside;
    }
    return inside;
  }

  LatLng _centerOfPoints(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(9.7402, 118.7354);
    var sumLat = 0.0;
    var sumLng = 0.0;
    for (final p in points) {
      sumLat += p.latitude;
      sumLng += p.longitude;
    }
    return LatLng(sumLat / points.length, sumLng / points.length);
  }

  double _polygonArea(List<LatLng> poly) {
    if (poly.length < 3) return 0;
    var area = 0.0;
    for (int i = 0, j = poly.length - 1; i < poly.length; j = i++) {
      area +=
          (poly[j].longitude + poly[i].longitude) *
          (poly[j].latitude - poly[i].latitude);
    }
    return area.abs() / 2.0;
  }

  LatLng _centerOfFeature(BarangayBoundaryFeature feature) {
    final b = _boundsOfFeature(feature);
    final sw = b.southWest;
    final ne = b.northEast;
    return LatLng(
      (sw.latitude + ne.latitude) / 2,
      (sw.longitude + ne.longitude) / 2,
    );
  }

  LatLngBounds _boundsOfAllFeatures() {
    LatLng? first;
    double minLat = 0, maxLat = 0, minLng = 0, maxLng = 0;

    for (final feature in widget.boundaries.features) {
      for (final polygon in feature.geometry.coordinates) {
        for (final ring in polygon) {
          for (final coord in ring) {
            final lng = coord[0];
            final lat = coord[1];

            if (first == null) {
              first = LatLng(lat, lng);
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
    }

    if (first == null) {
      return LatLngBounds(
        const LatLng(9.65, 118.60),
        const LatLng(9.90, 118.90),
      );
    }

    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }

  LatLngBounds _boundsOfFeature(BarangayBoundaryFeature feature) {
    LatLng? first;
    double minLat = 0, maxLat = 0, minLng = 0, maxLng = 0;

    for (final polygon in feature.geometry.coordinates) {
      for (final ring in polygon) {
        for (final coord in ring) {
          final lng = coord[0];
          final lat = coord[1];

          if (first == null) {
            first = LatLng(lat, lng);
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

    if (first == null) {
      return LatLngBounds(
        const LatLng(9.65, 118.60),
        const LatLng(9.90, 118.90),
      );
    }

    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }

  void _fitBounds(LatLngBounds bounds) {
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(24)),
    );
  }
}

class _TapPolygon {
  final String name;
  final List<LatLng> points;
  final LatLng center;

  const _TapPolygon({
    required this.name,
    required this.points,
    required this.center,
  });

  const _TapPolygon.empty()
    : name = '',
      points = const [],
      center = const LatLng(0, 0);

  bool get isValid => name.isNotEmpty && points.isNotEmpty;
}
