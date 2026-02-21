class HealthData {
  final int steps;
  final double distance; // in meters
  final double totalCalories; // in kcal
  final double activeCalories; // in kcal
  final double? heartRateAvg; // bpm
  final double? heartRateMin; // bpm
  final double? heartRateMax; // bpm
  final int sleepDurationMinutes;
  final int exerciseDurationMinutes;
  final DateTime? lastUpdated;

  const HealthData({
    this.steps = 0,
    this.distance = 0.0,
    this.totalCalories = 0.0,
    this.activeCalories = 0.0,
    this.heartRateAvg,
    this.heartRateMin,
    this.heartRateMax,
    this.sleepDurationMinutes = 0,
    this.exerciseDurationMinutes = 0,
    this.lastUpdated,
  });

  bool get hasNoData =>
      steps == 0 &&
      distance == 0.0 &&
      totalCalories == 0.0 &&
      sleepDurationMinutes == 0;

  String get distanceKm => (distance / 1000).toStringAsFixed(2);

  String get sleepFormatted {
    final hours = sleepDurationMinutes ~/ 60;
    final minutes = sleepDurationMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  HealthData copyWith({
    int? steps,
    double? distance,
    double? totalCalories,
    double? activeCalories,
    double? heartRateAvg,
    double? heartRateMin,
    double? heartRateMax,
    int? sleepDurationMinutes,
    int? exerciseDurationMinutes,
    DateTime? lastUpdated,
  }) {
    return HealthData(
      steps: steps ?? this.steps,
      distance: distance ?? this.distance,
      totalCalories: totalCalories ?? this.totalCalories,
      activeCalories: activeCalories ?? this.activeCalories,
      heartRateAvg: heartRateAvg ?? this.heartRateAvg,
      heartRateMin: heartRateMin ?? this.heartRateMin,
      heartRateMax: heartRateMax ?? this.heartRateMax,
      sleepDurationMinutes: sleepDurationMinutes ?? this.sleepDurationMinutes,
      exerciseDurationMinutes:
          exerciseDurationMinutes ?? this.exerciseDurationMinutes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
