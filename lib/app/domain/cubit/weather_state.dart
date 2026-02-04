part of 'weather_cubit.dart';

@freezed
abstract class WeatherHeaderState with _$WeatherHeaderState {
  const factory WeatherHeaderState({
    @Default(false) bool loading,
    @Default(false) bool loadingWeather,

    @Default(<BarangayLocation>[]) List<BarangayLocation> barangays,
    BarangayLocation? selectedBarangay,

    WeatherSnapshot? weather,
    String? errorMessage,
  }) = _WeatherHeaderState;
}
