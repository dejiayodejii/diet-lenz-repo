// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:health/health.dart';

// final healthDataProvider = FutureProvider<HealthDataMap>((ref) async {
//   final types = [
//     HealthDataType.STEPS,
//     HealthDataType.ACTIVE_ENERGY_BURNED,
//     HealthDataType.HEART_RATE,
//   ];

//   final health = Health();
//   await health.configure();

//   // Request permissions
//   final now = DateTime.now();
//   final yesterday = now.subtract(const Duration(days: 1));
//   final permissions = types.map((e) => HealthDataAccess.READ).toList();
//   bool granted =
//       await health.requestAuthorization(types, permissions: permissions);
//   if (!granted) throw Exception('Health permissions not granted');

//   // Fetch data
//   final results = await health.getHealthDataFromTypes(
//     types: types,
//     startTime: yesterday,
//     endTime: now,
//   );
//   int steps = 0;
//   double calories = 0;
//   double heartRate = 0;
//   int heartRateCount = 0;
//   for (final data in results) {
//     switch (data.type) {
//       case HealthDataType.STEPS:
//         steps += (data.value as num?)?.toInt() ?? 0;
//         break;
//       case HealthDataType.ACTIVE_ENERGY_BURNED:
//         calories += (data.value as num?)?.toDouble() ?? 0.0;
//         break;
//       case HealthDataType.HEART_RATE:
//         heartRate += (data.value as num?)?.toDouble() ?? 0.0;
//         heartRateCount++;
//         break;
//       default:
//         break;
//     }
//   }
//   final avgHeartRate = heartRateCount > 0 ? heartRate / heartRateCount : 0.0;
//   return HealthDataMap(
//     steps: steps,
//     calories: calories,
//     heartRate: avgHeartRate,
//   );
// });

// class HealthDataMap {
//   final int steps;
//   final double calories;
//   final double heartRate;
//   HealthDataMap(
//       {required this.steps, required this.calories, required this.heartRate});
// }
