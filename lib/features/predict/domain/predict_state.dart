part of 'predict_cubit.dart';

@freezed
abstract class PredictState with _$PredictState {
  const factory PredictState({
    // Asset loading
    @Default(false) bool loading,

    // Monte Carlo running
    @Default(false) bool predicting,

    // UI flags
    @Default(false) bool showInfoPin,

    // Error channel
    String? errorMessage,

    // Data needed by UI
    BarangayBoundariesCollection? boundaries,
    @Default(<String>[]) List<String> barangayOptions,
    @Default(<String, BarangayFloodRisk>{})
    Map<String, BarangayFloodRisk> riskMap,

    // User selection
    @Default('') String selectedBarangay,
    DateTimeRange? selectedRange,

    // “stale results” logic
    @Default(true) bool resultsStale,
    DateTimeRange? lastPredictedRange,
    @Default('') String lastPredictedBarangay,
  }) = _PredictState;
}
