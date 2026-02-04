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
  final MonteCarloFloodService _mc;

  BarangayBoundariesCollection? _boundaries;
  FloodDataCollection? _floodData;
  RainfallDataCollection? _rainfallData;

  /// Pre-indexed lookups (fast + stable)
  Map<String, BarangayBoundaryFeature> _boundaryByName = const {};
  Map<String, List<FloodFeature>> _floodByBarangay = const {};

  PredictCubit({
    required DataLoader loader,
    required MonteCarloFloodService monteCarloService,
  }) : _loader = loader,
       _mc = monteCarloService,
       super(const PredictState());

  // -----------------------------
  // Initial asset loading
  // -----------------------------
  Future<void> loadData() async {
    emit(state.copyWith(loading: true, errorMessage: null, predicting: false));

    final result = await _safeCall(() async {
      final res = await Future.wait<dynamic>([
        _loader.loadBarangayBoundaries(),
        _loader.loadFloodAreas(),
        _loader.loadRainfallCsv(),
      ]);
      return res;
    });

    result.fold(
      (err) => emit(state.copyWith(loading: false, errorMessage: err)),
      (data) {
        _boundaries = data[0] as BarangayBoundariesCollection;
        _floodData = data[1] as FloodDataCollection;
        _rainfallData = data[2] as RainfallDataCollection;

        // Build dropdown options from boundaries (single truth)
        final names =
            (_boundaries!.features
                .map((f) => f.properties.brgyName)
                .toSet()
                .toList()
              ..sort());

        // Default risk map so polygons can render immediately
        final defaultRisk = <String, BarangayFloodRisk>{
          for (final n in names) n: BarangayFloodRisk.defaultLow(n),
        };

        // Pre-index boundaries (case-insensitive)
        _boundaryByName = {
          for (final f in _boundaries!.features)
            _norm(f.properties.brgyName): f,
        };

        // Pre-index flood polygons by barangay
        _floodByBarangay = {};
        for (final ff in _floodData!.features) {
          final key = _norm(ff.properties.brgyName);
          (_floodByBarangay[key] ??= <FloodFeature>[]).add(ff);
        }

        emit(
          state.copyWith(
            loading: false,
            boundaries: _boundaries,
            barangayOptions: names,
            riskMap: defaultRisk,
            // reset UI flags
            showInfoPin: false,
            resultsStale: true,
            lastPredictedBarangay: '',
            lastPredictedRange: null,
          ),
        );
      },
    );
  }

  // -----------------------------
  // UI interactions
  // -----------------------------
  void setBarangay(String? barangay, {bool showPin = false}) {
    final value = (barangay ?? '').trim();
    if (value == state.selectedBarangay) {
      // still allow forcing pin display
      if (showPin && !state.showInfoPin) {
        emit(state.copyWith(showInfoPin: true));
      }
      return;
    }

    emit(
      state.copyWith(
        selectedBarangay: value,
        resultsStale: true,
        showInfoPin: showPin ? true : state.showInfoPin,
      ),
    );
  }

  void setDateRange(DateTimeRange range) {
    final current = state.selectedRange;
    final same =
        current != null &&
        current.start == range.start &&
        current.end == range.end;

    if (same) return;

    emit(state.copyWith(selectedRange: range, resultsStale: true));
  }

  void setInfoPinVisible(bool visible) {
    if (visible == state.showInfoPin) return;
    emit(state.copyWith(showInfoPin: visible));
  }

  void clearError() => emit(state.copyWith(errorMessage: null));

  // -----------------------------
  // Predict (Monte Carlo)
  // -----------------------------
  Future<void> predict() async {
    if (state.predicting) return;

    final boundaries = _boundaries;
    final floodData = _floodData;
    final rainfallData = _rainfallData;

    if (boundaries == null || floodData == null || rainfallData == null) {
      emit(state.copyWith(errorMessage: 'Prediction data is not ready yet.'));
      return;
    }

    final range = state.selectedRange;
    if (range == null) {
      emit(state.copyWith(errorMessage: 'Please select a date range.'));
      return;
    }

    final barangay = state.selectedBarangay.trim();
    if (barangay.isEmpty) {
      emit(state.copyWith(errorMessage: 'Please select a barangay.'));
      return;
    }

    final alreadyUpToDate =
        state.resultsStale == false &&
        state.lastPredictedBarangay == barangay &&
        state.lastPredictedRange?.start == range.start &&
        state.lastPredictedRange?.end == range.end;

    if (alreadyUpToDate) {
      // Still ensure pin is visible (user expectation)
      emit(state.copyWith(showInfoPin: true));
      return;
    }

    emit(
      state.copyWith(predicting: true, errorMessage: null, showInfoPin: true),
    );

    try {
      final key = _norm(barangay);
      final boundary = _boundaryByName[key];
      if (boundary == null) {
        emit(state.copyWith(errorMessage: 'Barangay boundary not found.'));
        return;
      }

      final floodFeatures = _floodByBarangay[key] ?? const <FloodFeature>[];

      final result = await _safeCall(() async {
        // ✅ Runs the heavy loop in a background isolate (UI will repaint)
        return _mc.simulateBarangay(
          barangayName: barangay,
          range: range,
          boundary: boundary,
          floodFeatures: floodFeatures,
          rainfallData: rainfallData,
        );
      });

      result.fold((err) => emit(state.copyWith(errorMessage: err)), (risk) {
        final updated = Map<String, BarangayFloodRisk>.from(state.riskMap)
          ..[barangay] = risk;

        emit(
          state.copyWith(
            riskMap: updated,
            resultsStale: false,
            lastPredictedBarangay: barangay,
            lastPredictedRange: range,
          ),
        );
      });
    } finally {
      if (!isClosed) emit(state.copyWith(predicting: false));
    }
  }

  // -----------------------------
  // Helpers
  // -----------------------------
  Future<Either<String, T>> _safeCall<T>(Future<T> Function() fn) async {
    try {
      return right(await fn());
    } catch (e) {
      return left(e.toString());
    }
  }

  String _norm(String s) => s.trim().toLowerCase();
}
