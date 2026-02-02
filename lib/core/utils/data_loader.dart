// lib/core/utils/data_loader.dart

import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';
import 'package:rain_check/core/repository/rain_fall_model/rainfall_data_model.dart';

class DataLoader {
  const DataLoader();

  Future<Map<String, dynamic>> _loadJsonMap(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return json.decode(raw) as Map<String, dynamic>;
  }

  Future<BarangayBoundariesCollection> loadBarangayBoundaries({
    String assetPath = 'assets/data/ppc_boundaries_wgs84.geojson',
  }) async {
    final jsonMap = await _loadJsonMap(assetPath);
    return BarangayBoundariesCollection.fromJson(jsonMap);
  }

  Future<FloodDataCollection> loadFloodAreas({
    String assetPath = 'assets/data/ppc_flooding_area.geojson',
  }) async {
    final jsonMap = await _loadJsonMap(assetPath);
    return FloodDataCollection.fromJson(jsonMap);
  }

  Future<RainfallDataCollection> loadRainfallCsv({
    String assetPath = 'assets/data/ppc_daily_data.csv',
    String source = 'DOST-PAGASA',
    String station = 'Puerto Princesa',
    double latitude = 9.740134,
    double longitude = 118.758613,
    double elevation = 16.76,
  }) async {
    final raw = await rootBundle.loadString(assetPath);

    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(raw);

    if (rows.isEmpty) {
      return RainfallDataCollection(
        data: const [],
        source: source,
        station: station,
        latitude: latitude,
        longitude: longitude,
        elevation: elevation,
      );
    }

    final headers = rows.first.map((e) => e.toString().trim()).toList();
    final data = <RainfallDataPoint>[];

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      final rowMap = <String, dynamic>{};
      for (var j = 0; j < headers.length && j < row.length; j++) {
        rowMap[headers[j]] = row[j];
      }

      data.add(RainfallDataPoint.fromJson(rowMap));
    }

    return RainfallDataCollection(
      data: data,
      source: source,
      station: station,
      latitude: latitude,
      longitude: longitude,
      elevation: elevation,
    );
  }
}
