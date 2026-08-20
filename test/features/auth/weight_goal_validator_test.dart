import 'package:diet_lenz/features/auth/utils/weight_goal_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateDesiredWeightForGoal', () {
    test('accepts a target below the current weight for a loss goal', () {
      final error = validateDesiredWeightForGoal(
        goal: 'I want to lose weight',
        currentWeight: 80,
        currentWeightUnit: 'kg',
        desiredWeight: 70,
        desiredWeightUnit: 'kg',
      );

      expect(error, isNull);
    });

    test('rejects a target at or above current weight for a loss goal', () {
      final error = validateDesiredWeightForGoal(
        goal: 'I want to lose weight',
        currentWeight: 80,
        currentWeightUnit: 'kg',
        desiredWeight: 180,
        desiredWeightUnit: 'lbs',
      );

      expect(error, contains('lower than your current weight'));
    });

    test('accepts a target above the current weight for a gain goal', () {
      final error = validateDesiredWeightForGoal(
        goal: 'I want to gain weight',
        currentWeight: 150,
        currentWeightUnit: 'lbs',
        desiredWeight: 75,
        desiredWeightUnit: 'kg',
      );

      expect(error, isNull);
    });

    test('rejects a target at or below current weight for a gain goal', () {
      final error = validateDesiredWeightForGoal(
        goal: 'I want to gain weight',
        currentWeight: 80,
        currentWeightUnit: 'kg',
        desiredWeight: 75,
        desiredWeightUnit: 'kg',
      );

      expect(error, contains('higher than your current weight'));
    });

    test('does not restrict a maintain-weight goal', () {
      final error = validateDesiredWeightForGoal(
        goal: 'I want to maintain my weight',
        currentWeight: 80,
        currentWeightUnit: 'kg',
        desiredWeight: 75,
        desiredWeightUnit: 'kg',
      );

      expect(error, isNull);
    });
  });
}
