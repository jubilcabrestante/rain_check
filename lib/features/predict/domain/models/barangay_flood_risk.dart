import 'package:rain_check/core/enum/flood_risk_level.dart';

enum RainAmount { low, moderate, high }

class BarangayFloodRisk {
  final String barangayName;
  final FloodRiskLevel riskLevel;

  /// % (0-100)
  final double floodProbability;

  /// mm
  final double rainfallIntensity;

  final RainAmount rainfallCategory;

  const BarangayFloodRisk({
    required this.barangayName,
    required this.riskLevel,
    required this.floodProbability,
    required this.rainfallIntensity,
    required this.rainfallCategory,
  });

  /// ✅ for now: just a safe default so the map can render colored polygons.
  factory BarangayFloodRisk.defaultLow(String name) {
    return BarangayFloodRisk(
      barangayName: name,
      riskLevel: FloodRiskLevel.low,
      floodProbability: 0,
      rainfallIntensity: 0,
      rainfallCategory: RainAmount.low,
    );
  }
}
