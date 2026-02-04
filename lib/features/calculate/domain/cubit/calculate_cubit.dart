import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rain_check/features/calculate/widgets/flood_data_service.dart';
import 'package:rain_check/features/calculate/widgets/flood_risk_logistic_regression_calibrated.dart';

part 'calculate_state.dart';
part 'calculate_cubit.freezed.dart';

class CalculateCubit extends Cubit<CalculateState> {
  final FloodDataService _service;

  CalculateCubit({required FloodDataService service})
    : _service = service,
      super(const CalculateState()) {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await loadBarangays();
  }

  Future<void> loadBarangays() async {
    emit(state.copyWith(loadingBarangays: true, errorMessage: null));

    final result = await _safeCall(() async {
      // ✅ Ensure files are loaded and model is calibrated from files
      await _service.initialize();
      return _service.getAllBarangayNames();
    });

    result.fold(
      (error) =>
          emit(state.copyWith(loadingBarangays: false, errorMessage: error)),
      (barangays) =>
          emit(state.copyWith(loadingBarangays: false, barangays: barangays)),
    );
  }

  void setBarangay(String value) {
    emit(state.copyWith(selectedBarangay: value));
  }

  void setRainfallMm(double? mm) {
    emit(state.copyWith(rainfallInMm: mm));
  }

  Future<void> calculate() async {
    final barangay = state.selectedBarangay;
    final mm = state.rainfallInMm;

    if (barangay == null || barangay.isEmpty) {
      emit(state.copyWith(errorMessage: 'Please select a barangay'));
      return;
    }

    if (mm == null) {
      emit(state.copyWith(errorMessage: 'Please enter rainfall (mm)'));
      return;
    }

    if (mm < 0) {
      emit(state.copyWith(errorMessage: 'Rainfall must be 0 or higher'));
      return;
    }

    if (mm > 1000) {
      emit(
        state.copyWith(errorMessage: 'Rainfall seems too high ( > 1000mm )'),
      );
      return;
    }

    emit(state.copyWith(calculating: true, result: null, errorMessage: null));

    final result = await _safeCall(() async {
      // ✅ All barangay geometry + flood hazard areas are taken from GeoJSON files.
      // ✅ Only rainfallInMm is user input here (not random).
      return _service.calculateFloodRiskML(
        barangayName: barangay,
        rainfallInMm: mm,
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
