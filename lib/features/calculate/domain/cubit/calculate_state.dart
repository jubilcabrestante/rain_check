part of 'calculate_cubit.dart';

@freezed
abstract class CalculateState with _$CalculateState {
  const factory CalculateState({
    @Default(false) bool loadingBarangays,
    @Default(false) bool calculating,
    @Default([]) List<String> barangays,
    String? selectedBarangay,

    // ✅ replace enum with typed number
    double? rainfallInMm,

    LogisticFloodResult? result,
    String? errorMessage,
  }) = _CalculateState;
}
