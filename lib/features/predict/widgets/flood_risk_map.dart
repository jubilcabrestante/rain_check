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

  /// ✅ currently selected from dropdown (optional)
  final String? selectedBarangayName;

  const FloodRiskMap({
    super.key,
    required this.boundaries,
    required this.riskDataMap,
    this.selectedBarangayName,
  });

  @override
  State<FloodRiskMap> createState() => _FloodRiskMapState();
}

class _FloodRiskMapState extends State<FloodRiskMap> {
  final MapController _mapController = MapController();

  String? _selectedBarangay;
  LatLng? _pinPosition;

  late List<_TapPolygon> _tapPolygons;

  // simple double-tap detector
  DateTime? _lastTapAt;
  LatLng? _lastTapLatLng;

  @override
  void initState() {
    super.initState();
    _tapPolygons = _buildTapPolygons();

    // ✅ Fit to Puerto Princesa bounds at start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bounds = _boundsOfAllFeatures();
      _fitBounds(bounds);
    });
  }

  @override
  void didUpdateWidget(covariant FloodRiskMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.boundaries != widget.boundaries ||
        oldWidget.riskDataMap != widget.riskDataMap) {
      _tapPolygons = _buildTapPolygons();
      setState(() {});
    }

    // ✅ If dropdown selects a barangay → zoom to that barangay bounds
    if (oldWidget.selectedBarangayName != widget.selectedBarangayName &&
        widget.selectedBarangayName != null &&
        widget.selectedBarangayName!.isNotEmpty) {
      final feature = widget.boundaries.features.firstWhere(
        (f) =>
            f.properties.brgyName.toLowerCase() ==
            widget.selectedBarangayName!.toLowerCase(),
        orElse: () => widget.boundaries.features.first,
      );

      final b = _boundsOfFeature(feature);
      _fitBounds(b);

      // also “select” it (so single tap isn’t required)
      setState(() {
        _selectedBarangay = feature.properties.brgyName;
        _pinPosition = null; // info only on double tap
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(9.7402, 118.7354),
        initialZoom: 12,
        minZoom: 10,
        maxZoom: 18,

        // ✅ Prevent flutter_map default double-tap zoom (we want double tap = show info)
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.doubleTapZoom,
        ),

        onTap: (tapPosition, latLng) => _handleTapOrDoubleTap(latLng),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.rain_check',
        ),

        // ✅ Polygons should be on TOP of tiles (tile behind)
        PolygonLayer(polygons: _buildPolygons()),

        // ✅ Barangay name labels
        MarkerLayer(markers: _buildBarangayLabels()),

        // ✅ Info pin on double tap
        if (_selectedBarangay != null && _pinPosition != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _pinPosition!,
                width: 300,
                height: 210,
                child: BarangayInfoPin(
                  riskData:
                      widget.riskDataMap[_selectedBarangay!] ??
                      BarangayFloodRisk.defaultLow(_selectedBarangay!),
                  onClose: () => setState(() {
                    _selectedBarangay = null;
                    _pinPosition = null;
                  }),
                ),
              ),
            ],
          ),
      ],
    );
  }

  // ------------------------------------------------------------
  // Tap logic: single tap selects barangay, double tap shows info
  // ------------------------------------------------------------
  void _handleTapOrDoubleTap(LatLng tap) {
    final now = DateTime.now();
    final isDoubleTap =
        _lastTapAt != null &&
        now.difference(_lastTapAt!).inMilliseconds <= 300 &&
        _lastTapLatLng != null &&
        _distanceMeters(_lastTapLatLng!, tap) <= 25;

    _lastTapAt = now;
    _lastTapLatLng = tap;

    final hit = _tapPolygons.firstWhere(
      (p) => _pointInPolygon(tap, p.points),
      orElse: () => const _TapPolygon.empty(),
    );

    if (!hit.isValid) {
      setState(() {
        _selectedBarangay = null;
        _pinPosition = null;
      });
      return;
    }

    if (isDoubleTap) {
      // ✅ show info
      setState(() {
        _selectedBarangay = hit.name;
        _pinPosition = hit.center;
      });
      return;
    }

    // ✅ single tap just selects
    setState(() {
      _selectedBarangay = hit.name;
      _pinPosition = null;
    });
  }

  double _distanceMeters(LatLng a, LatLng b) {
    const distance = Distance();
    return distance(a, b);
  }

  // --------------------------
  // Build polygons
  // --------------------------
  List<Polygon> _buildPolygons() {
    final polygons = <Polygon>[];

    for (final feature in widget.boundaries.features) {
      final name = feature.properties.brgyName;
      final riskData =
          widget.riskDataMap[name] ?? BarangayFloodRisk.defaultLow(name);

      final barangayPolygon = BarangayPolygon(
        feature: feature,
        riskData: riskData,
      );

      for (final ring in barangayPolygon.polygonPoints) {
        polygons.add(
          Polygon(
            points: ring,
            color: barangayPolygon.fillColor,
            borderColor: barangayPolygon.borderColor,
            borderStrokeWidth: 2.0,
          ),
        );
      }
    }

    return polygons;
  }

  // --------------------------
  // Labels at centroid
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

  LatLng _centerOfFeature(BarangayBoundaryFeature feature) {
    final b = _boundsOfFeature(feature);
    // In older versions: use the two corners you gave to LatLngBounds
    final sw = b.southWest;
    final ne = b.northEast;
    return LatLng(
      (sw.latitude + ne.latitude) / 2,
      (sw.longitude + ne.longitude) / 2,
    );
  }

  // --------------------------
  // Tap polygons
  // --------------------------
  List<_TapPolygon> _buildTapPolygons() {
    final list = <_TapPolygon>[];

    for (final feature in widget.boundaries.features) {
      final name = feature.properties.brgyName;
      final riskData =
          widget.riskDataMap[name] ?? BarangayFloodRisk.defaultLow(name);

      final poly = BarangayPolygon(feature: feature, riskData: riskData);

      for (final ring in poly.polygonPoints) {
        final center = _centerOfPoints(ring);
        list.add(_TapPolygon(name: name, points: ring, center: center));
      }
    }

    list.sort(
      (a, b) => _polygonArea(b.points).compareTo(_polygonArea(a.points)),
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

    double sumLat = 0;
    double sumLng = 0;
    for (final p in points) {
      sumLat += p.latitude;
      sumLng += p.longitude;
    }
    return LatLng(sumLat / points.length, sumLng / points.length);
  }

  double _polygonArea(List<LatLng> poly) {
    if (poly.length < 3) return 0;
    double area = 0;
    for (int i = 0, j = poly.length - 1; i < poly.length; j = i++) {
      area +=
          (poly[j].longitude + poly[i].longitude) *
          (poly[j].latitude - poly[i].latitude);
    }
    return area.abs() / 2.0;
  }

  LatLngBounds _boundsOfAllFeatures() {
    // start with a dummy, then expand
    LatLng? firstPoint;

    double minLat = 0, maxLat = 0, minLng = 0, maxLng = 0;

    for (final feature in widget.boundaries.features) {
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
    }

    // fallback if file is empty / broken
    if (firstPoint == null) {
      return LatLngBounds(
        const LatLng(9.65, 118.60),
        const LatLng(9.90, 118.90),
      );
    }

    // LatLngBounds expects 2 corners: southwest & northeast (works for older versions)
    return LatLngBounds(
      LatLng(minLat, minLng), // SW
      LatLng(maxLat, maxLng), // NE
    );
  }

  LatLngBounds _boundsOfFeature(BarangayBoundaryFeature feature) {
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

    // fallback (avoid crash if that feature is empty)
    if (firstPoint == null) {
      return LatLngBounds(
        const LatLng(9.65, 118.60),
        const LatLng(9.90, 118.90),
      );
    }

    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }

  void _fitBounds(LatLngBounds bounds) {
    // flutter_map v6+:
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
