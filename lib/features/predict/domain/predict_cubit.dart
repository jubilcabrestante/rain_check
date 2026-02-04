import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/repository/flood_model/flood_data_model.dart';
import 'package:rain_check/core/repository/rain_fall_model/rainfall_data_model.dart';
import 'package:rain_check/core/utils/data_loader.dart';
import 'package:rain_check/features/predict/data/monte_carlo_flood_service.dart';
import 'package:rain_check/features/predict/domain/models/barangay_flood_risk.dart';

part 'predict_state.dart';
part 'predict_cubit.freezed.dart';

class PredictCubit extends Cubit<PredictState> {
  final DataLoader _loader;
  final MonteCarloFloodService _monteCarloService;

  BarangayBoundariesCollection? _boundaries;
  FloodDataCollection? _floodData;
  RainfallDataCollection? _rainfallData;

  PredictCubit({
    required DataLoader loader,
    required MonteCarloFloodService monteCarloService,
  }) : _loader = loader,
       _monteCarloService = monteCarloService,
       super(const PredictState());

  Future<void> loadData() async {
    emit(state.copyWith(loading: true, errorMessage: null));

    final result = await _safeCall(() async {
      final data = await Future.wait([
        _loader.loadBarangayBoundaries(),
        _loader.loadFloodAreas(),
        _loader.loadRainfallCsv(),
      ]);
      return data;
    });

    result.fold(
      (error) => emit(state.copyWith(loading: false, errorMessage: error)),
      (data) {
        _boundaries = data[0] as BarangayBoundariesCollection;
        _floodData = data[1] as FloodDataCollection;
        _rainfallData = data[2] as RainfallDataCollection;

        final names =
            _boundaries!.features
                .map((f) => f.properties.brgyName)
                .toSet()
                .toList()
              ..sort();

        final defaultMap = <String, BarangayFloodRisk>{
          for (final name in names) name: BarangayFloodRisk.defaultLow(name),
        };

        emit(
          state.copyWith(
            loading: false,
            boundaries: _boundaries,
            barangayOptions: names,
            riskMap: defaultMap,
          ),
        );
      },
    );
  }

  void setBarangay(String? barangay) {
    emit(state.copyWith(selectedBarangay: barangay ?? ''));
  }

  void setDateRange(DateTimeRange range) {
    emit(state.copyWith(selectedRange: range));
  }

  Future<void> predict() async {
    final boundaries = _boundaries;
    final floodData = _floodData;
    final rainfallData = _rainfallData;

    if (boundaries == null || floodData == null || rainfallData == null) {
      emit(state.copyWith(errorMessage: 'Prediction data is not ready yet.'));
      return;
    }

    if (state.selectedRange == null) {
      emit(state.copyWith(errorMessage: 'Please select a date range.'));
      return;
    }

    if (state.selectedBarangay.isEmpty) {
      emit(state.copyWith(errorMessage: 'Please select a barangay.'));
      return;
    }

    emit(state.copyWith(predicting: true, errorMessage: null));

    final result = await _safeCall(() async {
      return _monteCarloService.monteCarlo(
        range: state.selectedRange!,
        barangayNames: state.barangayOptions,
        floodData: floodData,
        rainfallData: rainfallData,
      );
    });

    result.fold(
      (error) => emit(state.copyWith(predicting: false, errorMessage: error)),
      (riskMap) => emit(state.copyWith(predicting: false, riskMap: riskMap)),
    );
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  Future<Either<String, T>> _safeCall<T>(Future<T> Function() fn) async {
    try {
      final res = await fn();
      return right(res);
    } catch (e) {
      return left(e.toString());
    }
  }
}
