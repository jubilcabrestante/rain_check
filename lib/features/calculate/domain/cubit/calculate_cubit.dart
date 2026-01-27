import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rain_check/features/calculate/flood_data_service.dart';

part 'calculate_state.dart';
part 'calculate_cubit.freezed.dart';

class CalculateCubit extends Cubit<CalculateState> {
  final FloodDataService _service;

  // ✅ CORRECT: Named parameter only
  CalculateCubit({required FloodDataService service})
    : _service = service,
      super(const CalculateState()) {
    loadBarangays();
  }

  /// Load barangays
  Future<void> loadBarangays() async {
    emit(state.copyWith(loadingBarangays: true, errorMessage: null));

    final result = await _safeCall(() async {
      return _service.getAllBarangayNames();
    });

    result.fold(
      (error) =>
          emit(state.copyWith(loadingBarangays: false, errorMessage: error)),
      (barangays) =>
          emit(state.copyWith(loadingBarangays: false, barangays: barangays)),
    );
  }

  void setRainfall(RainfallIntensity value) {
    emit(state.copyWith(selectedIntensity: value));
  }

  void setBarangay(String value) {
    emit(state.copyWith(selectedBarangay: value));
  }

  /// Calculate flood risk
  Future<void> calculate() async {
    if (state.selectedBarangay == null || state.selectedIntensity == null) {
      emit(state.copyWith(errorMessage: 'Please complete all fields'));
      return;
    }

    emit(state.copyWith(calculating: true, result: null, errorMessage: null));

    final result = await _safeCall(() async {
      return _service.calculateFloodRisk(
        barangayName: state.selectedBarangay!,
        rainfallInMm: state.selectedIntensity!.min, // Use min value of range
      );
    });

    result.fold(
      (error) => emit(state.copyWith(calculating: false, errorMessage: error)),
      (data) => emit(state.copyWith(calculating: false, result: data)),
    );
  }

  /// dartz-style safe call
  Future<Either<String, T>> _safeCall<T>(Future<T> Function() fn) async {
    try {
      final res = await fn();
      return right(res);
    } catch (e) {
      return left(e.toString());
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
