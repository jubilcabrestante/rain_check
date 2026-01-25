class RainData {
  final String location;
  final double accumulation; // mm
  final double temperature; // °C
  final double chanceOfRain; // percentage (0–100)
  final double rainAmount; // mm

  const RainData({
    required this.location,
    required this.accumulation,
    required this.temperature,
    required this.chanceOfRain,
    required this.rainAmount,
  });
}

extension RainDataX on RainData {
  bool get isHeavyRain => rainAmount >= 50;
  bool get isLikelyToRain => chanceOfRain >= 60;
}
