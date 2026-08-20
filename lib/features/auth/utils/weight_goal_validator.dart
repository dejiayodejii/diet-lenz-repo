String? validateDesiredWeightForGoal({
  required String? goal,
  required double? currentWeight,
  required String? currentWeightUnit,
  required double desiredWeight,
  required String desiredWeightUnit,
}) {
  final normalizedGoal = goal?.toLowerCase();
  final isWeightLossGoal = normalizedGoal?.contains('lose weight') ?? false;
  final isWeightGainGoal = normalizedGoal?.contains('gain weight') ?? false;

  if (!isWeightLossGoal && !isWeightGainGoal) return null;

  if (currentWeight == null || currentWeightUnit == null) {
    return 'Please set your current weight before choosing a target weight.';
  }

  final currentWeightKg = _weightToKg(currentWeight, currentWeightUnit);
  final desiredWeightKg = _weightToKg(desiredWeight, desiredWeightUnit);

  if (isWeightLossGoal && desiredWeightKg >= currentWeightKg) {
    return 'Your target weight must be lower than your current weight to match your weight-loss goal.';
  }

  if (isWeightGainGoal && desiredWeightKg <= currentWeightKg) {
    return 'Your target weight must be higher than your current weight to match your weight-gain goal.';
  }

  return null;
}

double _weightToKg(double value, String unit) {
  return unit.toLowerCase() == 'lbs' ? value / 2.20462 : value;
}
