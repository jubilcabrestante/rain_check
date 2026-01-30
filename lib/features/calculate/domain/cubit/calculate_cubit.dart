import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rain_check/features/calculate/flood_data_service.dart';
import 'package:rain_check/features/calculate/flood_risk_logistic_regression_calibrated.dart';

part 'calculate_state.dart';
part 'calculate_cubit.freezed.dart';

class CalculateCubit extends Cubit<CalculateState> {
  final FloodDataService _service;

  CalculateCubit({required FloodDataService service})
    : _service = service,
      super(const CalculateState()) {
    loadBarangays();
  }

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

  /// ✅ FIXED: Calculate using ML model
  Future<void> calculate() async {
    if (state.selectedBarangay == null || state.selectedIntensity == null) {
      emit(state.copyWith(errorMessage: 'Please complete all fields'));
      return;
    }

    emit(state.copyWith(calculating: true, result: null, errorMessage: null));

    final result = await _safeCall(() async {
      return _service.calculateFloodRiskML(
        barangayName: state.selectedBarangay!,
        intensity: state.selectedIntensity!,
      );
    });

    result.fold(
      (error) => emit(state.copyWith(calculating: false, errorMessage: error)),
      (data) => emit(state.copyWith(calculating: false, result: data)),
    );
  }

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
