enum FloodRiskLevel { low, moderate, high }

extension FloodRiskLevelX on FloodRiskLevel {
  String get displayName => switch (this) {
    FloodRiskLevel.low => 'Low Risk',
    FloodRiskLevel.moderate => 'Moderate Risk',
    FloodRiskLevel.high => 'High Risk',
  };

  String get colorHex => switch (this) {
    FloodRiskLevel.low => '#388E3C',
    FloodRiskLevel.moderate => '#FBC02D',
    FloodRiskLevel.high => '#D32F2F',
  };
}
