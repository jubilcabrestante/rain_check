class WeatherSnapshot {
  final double temperatureC; // current
  final int chanceOfRainPct; // daily max probability
  final double accumulationMm; // daily precipitation sum

  const WeatherSnapshot({
    required this.temperatureC,
    required this.chanceOfRainPct,
    required this.accumulationMm,
  });

  String get rainAmountText {
    // Use accumulation to classify intensity
    if (accumulationMm >= 20) return 'Heavy';
    if (accumulationMm >= 5) return 'Moderate';
    if (accumulationMm > 0) return 'Light';

    // If no accumulation, still interpret probability
    if (chanceOfRainPct >= 60) return 'Possible';
    return 'No';
  }
}
