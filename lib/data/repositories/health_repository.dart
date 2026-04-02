// import 'package:diet_lenz/data/models/health_data.dart';
// import 'package:flutter/material.dart';
// import 'package:health/health.dart';
// import 'dart:io' show Platform;

// enum TimeRange { daily, weekly, monthly }

// class HealthRepository {
//   // final Health Health() = Health();
//   bool _isConfigured = false;

//   // Health data types to request
//   static const List<HealthDataType> _dataTypes = [
//     HealthDataType.STEPS,
//     HealthDataType.HEART_RATE,
//     HealthDataType.ACTIVE_ENERGY_BURNED,
//     // HealthDataType.TOTAL_CALORIES_BURNED,
//   ];

//   // Permissions (read-only)
//   static List<HealthDataAccess> get _permissions =>
//       _dataTypes.map((e) => HealthDataAccess.READ).toList();

//   /// Configure Health - must be called before any health operations
//   Future<void> _ensureConfigured() async {
//     if (!_isConfigured) {
//       await Health().configure();
//       _isConfigured = true;
//       debugPrint("Health configured");
//     }
//   }

//   /// Check if Health Connect/HealthKit is available
//   Future<bool> isHealthAvailable() async {
//     try {
//       await _ensureConfigured();

//       if (Platform.isAndroid) {
//         // On Android, check Health Connect availability
//         final status = await Health().getHealthConnectSdkStatus();
//         debugPrint("Health Connect SDK status: $status");
//         return status == HealthConnectSdkStatus.sdkAvailable;
//       }
//       // On iOS, health is always available if app has HealthKit capability
//       return true;
//     } catch (e) {
//       debugPrint('Error checking health availability: $e');
//       return false;
//     }
//   }

//   /// Request permissions for health data
//   Future<bool> requestPermissions() async {
//     try {
//       await _ensureConfigured();

//       if (Platform.isAndroid) {
//         // Check Health Connect SDK status first
//         final status = await Health().getHealthConnectSdkStatus();
//         debugPrint("Health Connect SDK status: $status");

//         if (status == HealthConnectSdkStatus.sdkUnavailable) {
//           debugPrint("Health Connect SDK is not available on this device");
//           return false;
//         }

//         // If SDK is available but not installed, try to install it
//         if (status != HealthConnectSdkStatus.sdkAvailable) {
//           debugPrint("Health Connect not installed, attempting to install...");
//           await Health().installHealthConnect();
//           // Return false for now, user needs to retry after installation
//           return false;
//         }
//       }

//       // Request authorization
//       final authorized = await Health().requestAuthorization(
//         _dataTypes,
//         permissions: _permissions,
//       );
//       debugPrint("Authorization requested, result: $authorized");
//       return authorized;
//     } catch (e) {
//       debugPrint('Error requesting permissions: $e');
//       return false;
//     }
//   }

//   /// Check if permissions are granted
//   Future<bool> hasPermissions() async {
//     try {
//       await _ensureConfigured();
//       final hasPerms = await Health().hasPermissions(
//         _dataTypes,
//         permissions: _permissions,
//       );
//       return hasPerms ?? false;
//     } catch (e) {
//       debugPrint('Error checking permissions: $e');
//       return false;
//     }
//   }

//   /// Fetch health data based on time range
//   Future<HealthData> fetchHealthData(TimeRange timeRange) async {
//     await _ensureConfigured();

//     final now = DateTime.now().toLocal();
//     DateTime startTime;
//     DateTime sleepStart;

//     switch (timeRange) {
//       case TimeRange.daily:
//         // Start of today (midnight) in local timezone
//         // Create midnight in local time, then ensure it's properly represented
//         startTime = DateTime(now.year, now.month, now.day);
//         sleepStart = startTime.subtract(const Duration(hours: 12));
//         debugPrint(
//             "Daily query - Start: $startTime (${startTime.toUtc()} UTC), End: $now (${now.toUtc()} UTC)");
//         break;
//       case TimeRange.weekly:
//         startTime = now.subtract(const Duration(days: 7));
//         sleepStart = startTime;
//         break;
//       case TimeRange.monthly:
//         startTime = now.subtract(const Duration(days: 30));
//         sleepStart = startTime;
//         break;
//     }

//     try {
//       debugPrint("Fetching health data from $startTime to $now");

//       // Fetch steps using the dedicated method (more reliable)
//       int? steps = await Health().getTotalStepsInInterval(startTime, now);
//       debugPrint("Steps from getTotalStepsInInterval: $steps");

//       // Only fetch steps data points as fallback if getTotalStepsInInterval returns null or 0
//       if (steps == null || steps == 0) {
//         List<HealthDataPoint> stepsData = await Health().getHealthDataFromTypes(
//           startTime: startTime,
//           endTime: now,
//           types: [HealthDataType.STEPS],
//         );
//         debugPrint("Steps data points found (fallback): ${stepsData.length}");

//         // Aggregate steps from data points as fallback
//         int aggregatedSteps = 0;
//         for (var point in stepsData) {
//           if (point.value is NumericHealthValue) {
//             aggregatedSteps +=
//                 (point.value as NumericHealthValue).numericValue.toInt();
//           }
//         }
//         steps = aggregatedSteps;
//         debugPrint("Total steps from data points fallback: $steps");
//       }

//       // Fetch other health data points
//       final healthDataPoints = await Health().getHealthDataFromTypes(
//         types: _dataTypes,
//         startTime: startTime,
//         endTime: now,
//       );
//       debugPrint("Total health data points: ${healthDataPoints.length}");

//       // Process and aggregate the data (skip sleep data for now - not available on Health Connect)
//       return _processHealthData(healthDataPoints, [], stepsOverride: steps);
//     } catch (e) {
//       debugPrint('Error fetching health data: $e');
//       debugPrintStack();
//       rethrow;
//     }
//   }

//   /// Fetch today's health data
//   Future<HealthData> fetchTodayHealthData() => fetchHealthData(TimeRange.daily);

//   /// Fetch weekly health data
//   Future<HealthData> fetchWeeklyHealthData() =>
//       fetchHealthData(TimeRange.weekly);

//   /// Fetch monthly health data
//   Future<HealthData> fetchMonthlyHealthData() =>
//       fetchHealthData(TimeRange.monthly);

//   /// Process raw health data points into aggregated HealthData
//   HealthData _processHealthData(
//     List<HealthDataPoint> dataPoints,
//     List<HealthDataPoint> sleepDataPoints, {
//     int? stepsOverride,
//   }) {
//     int steps = stepsOverride ?? 0;
//     double distance = 0.0;
//     double totalCalories = 0.0;
//     double activeCalories = 0.0;
//     List<double> heartRates = [];
//     int sleepMinutes = 0;
//     int exerciseMinutes = 0;

//     // For TOTAL_CALORIES_BURNED, keep track of the latest value instead of summing
//     List<HealthDataPoint> totalCaloriesPoints = [];

//     for (final point in dataPoints) {
//       final value = point.value;

//       switch (point.type) {
//         case HealthDataType.STEPS:
//           // Skip steps processing if we have an override from getTotalStepsInInterval
//           if (stepsOverride == null && value is NumericHealthValue) {
//             steps += value.numericValue.toInt();
//           }
//           break;
//         case HealthDataType.DISTANCE_DELTA:
//           if (value is NumericHealthValue) {
//             distance += value.numericValue.toDouble();
//           }
//           break;
//         case HealthDataType.ACTIVE_ENERGY_BURNED:
//           if (value is NumericHealthValue) {
//             activeCalories += value.numericValue.toDouble();
//           }
//           break;
//         case HealthDataType.TOTAL_CALORIES_BURNED:
//           // Store all total calories points to get the latest one
//           totalCaloriesPoints.add(point);
//           break;
//         case HealthDataType.HEART_RATE:
//           if (value is NumericHealthValue) {
//             heartRates.add(value.numericValue.toDouble());
//           }
//           break;
//         case HealthDataType.WORKOUT:
//           final duration = point.dateTo.difference(point.dateFrom);
//           exerciseMinutes += duration.inMinutes;
//           break;
//         default:
//           break;
//       }
//     }

//     // Get the maximum TOTAL_CALORIES_BURNED value (highest cumulative total)
//     // Filter out data points that are beyond current time in local timezone
//     if (totalCaloriesPoints.isNotEmpty) {
//       final nowLocal = DateTime.now().toLocal();
//       final todayEnd = DateTime(nowLocal.year, nowLocal.month, nowLocal.day)
//           .add(const Duration(days: 1));

//       // Filter points to only include those before tomorrow
//       final validPoints = totalCaloriesPoints.where((point) {
//         final pointLocal = point.dateTo.toLocal();
//         return pointLocal.isBefore(todayEnd);
//       }).toList();

//       debugPrint(
//           "Processing ${validPoints.length}/${totalCaloriesPoints.length} valid TOTAL_CALORIES_BURNED points:");

//       if (validPoints.isNotEmpty) {
//         // Find the maximum value (highest cumulative total)
//         double maxCalories = 0;
//         HealthDataPoint? maxPoint;

//         for (final point in validPoints) {
//           final value = point.value;
//           if (value is NumericHealthValue) {
//             final caloriesValue = value.numericValue.toDouble();
//             if (caloriesValue > maxCalories) {
//               maxCalories = caloriesValue;
//               maxPoint = point;
//             }
//             debugPrint(
//                 "  Point: ${caloriesValue} cal at ${point.dateTo.toLocal()}");
//           }
//         }

//         totalCalories = maxCalories;
//         if (maxPoint != null) {
//           debugPrint(
//               "Using max value: $totalCalories cal from ${maxPoint.dateTo.toLocal()}");
//         }
//       }
//     }

//     // Process sleep data separately
//     for (final point in sleepDataPoints) {
//       if (point.type == HealthDataType.SLEEP_ASLEEP ||
//           point.type == HealthDataType.SLEEP_IN_BED) {
//         final duration = point.dateTo.difference(point.dateFrom);
//         sleepMinutes += duration.inMinutes;
//       }
//     }

//     // Calculate heart rate stats
//     double? heartRateAvg;
//     double? heartRateMin;
//     double? heartRateMax;

//     if (heartRates.isNotEmpty) {
//       heartRateAvg = heartRates.reduce((a, b) => a + b) / heartRates.length;
//       heartRateMin = heartRates.reduce((a, b) => a < b ? a : b);
//       heartRateMax = heartRates.reduce((a, b) => a > b ? a : b);
//     }

//     return HealthData(
//       steps: steps,
//       distance: distance,
//       totalCalories: totalCalories,
//       activeCalories: activeCalories,
//       heartRateAvg: heartRateAvg,
//       heartRateMin: heartRateMin,
//       heartRateMax: heartRateMax,
//       sleepDurationMinutes: sleepMinutes,
//       exerciseDurationMinutes: exerciseMinutes,
//       lastUpdated: DateTime.now(),
//     );
//   }
// }
