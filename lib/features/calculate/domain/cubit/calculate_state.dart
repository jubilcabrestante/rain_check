part of 'calculate_cubit.dart';

@freezed
abstract class CalculateState with _$CalculateState {
  const factory CalculateState({
    @Default(false) bool loadingBarangays,
    @Default(false) bool calculating,
    @Default([]) List<String> barangays,
    String? selectedBarangay,
    RainfallIntensity? selectedIntensity,
    LogisticFloodResult? result, // ✅ CHANGED from FloodCalculationResult
    String? errorMessage,
  }) = _CalculateState;
}
