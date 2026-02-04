part of 'predict_cubit.dart';

@freezed
abstract class PredictState with _$PredictState {
  const factory PredictState({
    // ✅ used by loadData()
    @Default(false) bool loading,

    // ✅ used by predict()
    @Default(false) bool predicting,

    // ✅ shared error channel
    String? errorMessage,

    // ✅ used by UI + predict()
    DateTimeRange? selectedRange,

    // ✅ used after loading boundaries
    BarangayBoundariesCollection? boundaries,

    // ✅ used for dropdown list
    @Default(<String>[]) List<String> barangayOptions,

    // ✅ used for selection validation
    @Default('') String selectedBarangay,

    // ✅ used by map coloring / results
    @Default(<String, BarangayFloodRisk>{})
    Map<String, BarangayFloodRisk> riskMap,
  }) = _PredictState;
}
