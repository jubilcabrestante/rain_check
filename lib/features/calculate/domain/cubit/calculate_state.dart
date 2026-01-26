part of 'calculate_cubit.dart';

@freezed
abstract class CalculateState with _$CalculateState {
  const factory CalculateState({
    @Default(false) bool loading,
    String? location,
    String? rainAmount,
    String? errorMessage,
  }) = _Initial;
}
