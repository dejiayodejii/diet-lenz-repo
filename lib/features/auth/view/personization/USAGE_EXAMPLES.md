# Measurement Selection Screen - Usage Examples

## How to Access Selected Values

The `MeasurementSelectionScreen` now supports an optional `onContinue` callback that provides:
- `value` - The selected numeric value
- `unit` - The currently selected unit as a string
- `isLeftUnit` - Boolean indicating if the left unit is selected

## Example 1: Print the Selected Value

```dart
class SelectWeightScreen extends StatelessWidget {
  const SelectWeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MeasurementSelectionScreen(
      title: "What is your weight?",
      leftUnit: "kg",
      rightUnit: "lbs",
      minValue: 0,
      maxValue: 500,
      initialValue: 50.0,
      nextScreen: const SelectHeightScreen(),
      onContinue: (value, unit, isLeftUnit) {
        print('Selected weight: $value $unit');
        print('Is kg selected: $isLeftUnit');
      },
    );
  }
}
```

## Example 2: Store in State Management (Riverpod)

```dart
// Create a provider to store the weight
final weightProvider = StateProvider<double?>((ref) => null);
final weightUnitProvider = StateProvider<String?>((ref) => null);

class SelectWeightScreen extends ConsumerWidget {
  const SelectWeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MeasurementSelectionScreen(
      title: "What is your weight?",
      leftUnit: "kg",
      rightUnit: "lbs",
      minValue: 0,
      maxValue: 500,
      initialValue: 50.0,
      nextScreen: const SelectHeightScreen(),
      onContinue: (value, unit, isLeftUnit) {
        // Store the values in Riverpod providers
        ref.read(weightProvider.notifier).state = value;
        ref.read(weightUnitProvider.notifier).state = unit;
      },
    );
  }
}
```

## Example 3: Pass to API or Save to Database

```dart
class SelectWeightScreen extends ConsumerWidget {
  const SelectWeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MeasurementSelectionScreen(
      title: "What is your weight?",
      leftUnit: "kg",
      rightUnit: "lbs",
      minValue: 0,
      maxValue: 500,
      initialValue: 50.0,
      nextScreen: const SelectHeightScreen(),
      onContinue: (value, unit, isLeftUnit) async {
        // Convert to kg if needed
        double weightInKg = isLeftUnit ? value : value * 0.453592;
        
        // Save to your database or API
        await ref.read(userProfileProvider.notifier).updateWeight(weightInKg);
        
        // Or save locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('user_weight', weightInKg);
        await prefs.setString('user_weight_unit', unit);
      },
    );
  }
}
```

## Example 4: Validate Before Navigation

```dart
class SelectWeightScreen extends StatelessWidget {
  const SelectWeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MeasurementSelectionScreen(
      title: "What is your weight?",
      leftUnit: "kg",
      rightUnit: "lbs",
      minValue: 0,
      maxValue: 500,
      initialValue: 50.0,
      nextScreen: const SelectHeightScreen(),
      onContinue: (value, unit, isLeftUnit) {
        // Validate the value
        if (value < 20) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter a valid weight'),
            ),
          );
          return; // Don't navigate
        }
        
        // Log for analytics
        print('User selected weight: $value $unit');
      },
    );
  }
}
```

## Example 5: Create a Complete User Profile Model

```dart
// Model to store all measurements
class UserMeasurements {
  final double weight;
  final String weightUnit;
  final double height;
  final String heightUnit;
  final double desiredWeight;
  final String desiredWeightUnit;

  UserMeasurements({
    required this.weight,
    required this.weightUnit,
    required this.height,
    required this.heightUnit,
    required this.desiredWeight,
    required this.desiredWeightUnit,
  });
}

// Provider to manage measurements
final measurementsProvider = StateNotifierProvider<MeasurementsNotifier, UserMeasurements?>((ref) {
  return MeasurementsNotifier();
});

class MeasurementsNotifier extends StateNotifier<UserMeasurements?> {
  MeasurementsNotifier() : super(null);

  void updateWeight(double value, String unit) {
    state = UserMeasurements(
      weight: value,
      weightUnit: unit,
      height: state?.height ?? 0,
      heightUnit: state?.heightUnit ?? 'cm',
      desiredWeight: state?.desiredWeight ?? 0,
      desiredWeightUnit: state?.desiredWeightUnit ?? 'kg',
    );
  }

  void updateHeight(double value, String unit) {
    // Similar implementation
  }

  void updateDesiredWeight(double value, String unit) {
    // Similar implementation
  }
}

// Usage in screen
class SelectWeightScreen extends ConsumerWidget {
  const SelectWeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MeasurementSelectionScreen(
      title: "What is your weight?",
      leftUnit: "kg",
      rightUnit: "lbs",
      minValue: 0,
      maxValue: 500,
      initialValue: 50.0,
      nextScreen: const SelectHeightScreen(),
      onContinue: (value, unit, isLeftUnit) {
        ref.read(measurementsProvider.notifier).updateWeight(value, unit);
      },
    );
  }
}
```

## Return Values

The `onContinue` callback receives three parameters:

1. **`value`** (double): The numeric value selected by the user
2. **`unit`** (String): The currently selected unit (e.g., "kg", "lbs", "cm", "ft")
3. **`isLeftUnit`** (bool): `true` if the left unit is selected, `false` if the right unit is selected

This gives you complete flexibility to handle the data however you need!
