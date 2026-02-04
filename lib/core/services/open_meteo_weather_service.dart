import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:rain_check/core/models/weather_snapshot.dart';

class OpenMeteoWeatherService {
  Future<WeatherSnapshot> fetchToday({
    required double latitude,
    required double longitude,
    required String timezone,
  }) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'timezone': timezone,
      'forecast_days': '1',
      'current': 'temperature_2m',
      'daily': 'precipitation_sum,precipitation_probability_max',
    });

    final res = await http.get(uri);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw StateError('Weather request failed: HTTP ${res.statusCode}');
    }

    final jsonMap = json.decode(res.body) as Map<String, dynamic>;

    final current = (jsonMap['current'] as Map?) ?? const {};
    final temp = (current['temperature_2m'] as num?)?.toDouble() ?? 0.0;

    final daily = (jsonMap['daily'] as Map?) ?? const {};
    final precipList = (daily['precipitation_sum'] as List?) ?? const [];
    final probList =
        (daily['precipitation_probability_max'] as List?) ?? const [];

    final accumulationMm = precipList.isNotEmpty
        ? (precipList.first as num).toDouble()
        : 0.0;

    final chancePct = probList.isNotEmpty ? (probList.first as num).round() : 0;

    return WeatherSnapshot(
      temperatureC: temp,
      chanceOfRainPct: chancePct.clamp(0, 100),
      accumulationMm: accumulationMm.clamp(0.0, 9999.0),
    );
  }
}
