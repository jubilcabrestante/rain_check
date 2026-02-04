import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

import 'package:rain_check/core/models/barangay_location.dart';
import 'package:rain_check/core/models/weather_snapshot.dart';
import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/services/open_meteo_weather_service.dart';
import 'package:rain_check/core/utils/data_loader.dart';
import 'package:rain_check/core/utils/geojson_centroid.dart';

part 'weather_state.dart';
part 'weather_cubit.freezed.dart';

class WeatherHeaderCubit extends Cubit<WeatherHeaderState> {
  final DataLoader _loader;
  final OpenMeteoWeatherService _weather;

  WeatherHeaderCubit({
    required DataLoader loader,
    required OpenMeteoWeatherService weather,
  }) : _loader = loader,
       _weather = weather,
       super(const WeatherHeaderState());

  Future<void> init() async {
    emit(state.copyWith(loading: true, errorMessage: null));

    final res = await _safeCall(() async {
      final boundaries = await _loader.loadBarangayBoundaries();
      final list = boundaries.features.map(_toBarangayLocation).toList()
        ..sort((a, b) => a.name.compareTo(b.name));

      if (list.isEmpty) {
        throw StateError('No barangays found in boundaries file.');
      }

      return list;
    });

    await res.fold(
      (e) async => emit(state.copyWith(loading: false, errorMessage: e)),
      (barangays) async {
        final selected = barangays.first;
        emit(
          state.copyWith(
            loading: false,
            barangays: barangays,
            selectedBarangay: selected,
          ),
        );
        await fetchWeather(); // auto fetch for default
      },
    );
  }

  Future<void> setBarangay(String? name) async {
    if (name == null) return;
    final picked = state.barangays.firstWhere(
      (b) => b.name == name,
      orElse: () => state.selectedBarangay ?? state.barangays.first,
    );

    emit(state.copyWith(selectedBarangay: picked));
    await fetchWeather();
  }

  Future<void> fetchWeather() async {
    final selected = state.selectedBarangay;
    if (selected == null) return;

    emit(state.copyWith(loadingWeather: true, errorMessage: null));

    final res = await _safeCall(() async {
      return _weather.fetchToday(
        latitude: selected.lat,
        longitude: selected.lon,
        timezone: 'Asia/Manila',
      );
    });

    res.fold(
      (e) => emit(state.copyWith(loadingWeather: false, errorMessage: e)),
      (data) => emit(state.copyWith(loadingWeather: false, weather: data)),
    );
  }

  BarangayLocation _toBarangayLocation(BarangayBoundaryFeature feature) {
    final LatLng center = GeoJsonCentroid.boundsCenter(feature);
    return BarangayLocation(
      name: feature.properties.brgyName,
      lat: center.latitude,
      lon: center.longitude,
    );
  }

  Future<Either<String, T>> _safeCall<T>(Future<T> Function() fn) async {
    try {
      return right(await fn());
    } catch (e) {
      return left(e.toString());
    }
  }

  void clearError() => emit(state.copyWith(errorMessage: null));
}
