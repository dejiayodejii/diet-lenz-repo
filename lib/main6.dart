// import 'package:flutter/material.dart';
// import 'package:health/health.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Health Data App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
//         useMaterial3: true,
//       ),
//       home: const HealthPage(),
//     );
//   }
// }

// class HealthPage extends StatefulWidget {
//   const HealthPage({super.key});

//   @override
//   State<HealthPage> createState() => _HealthPageState();
// }

// class _HealthPageState extends State<HealthPage> {
//   // Define the types of data we want to fetch
//   final List<HealthDataType> _types = [
//     HealthDataType.STEPS,
//     HealthDataType.HEART_RATE,
//     HealthDataType.ACTIVE_ENERGY_BURNED,
//   ];

//   // State variables
//   bool _authorized = false;
//   int _steps = 0;
//   double _calories = 0;
//   int _heartRate = 0;
//   List<HealthDataPoint> _healthDataList = [];
//   String _status = "Not Authorized";

//   @override
//   void initState() {
//     super.initState();
//     _authorize();
//   }

//   // Request authorization and fetch data
//   Future<void> _authorize() async {
//     try {
//       // Configure the Health instance
//       Health().configure();

//       debugPrint("Health configured");

//       // Check if we have permissions
//       bool? hasPermissions = await Health().hasPermissions(_types,
//           permissions: _types.map((e) => HealthDataAccess.READ).toList());

//       debugPrint("Has permissions: $hasPermissions");

//       // If false or null, request permissions
//       if (hasPermissions != true) {
//         try {
//           _authorized = await Health().requestAuthorization(_types,
//               permissions: _types.map((e) => HealthDataAccess.READ).toList());
//           debugPrint("Authorization requested, result: $_authorized");
//         } catch (e) {
//           setState(() {
//             _status = "Exception in authorization: $e";
//           });
//           debugPrint("Authorization error: $e");
//           return;
//         }
//       } else {
//         _authorized = true;
//       }

//       if (_authorized) {
//         setState(() {
//           _status = "Authorized. Fetching data...";
//         });
//         debugPrint("Calling _fetchData()");
//         _fetchData();
//       } else {
//         setState(() {
//           _status = "Authorization Denied";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _status = "Error during authorization: $e";
//       });
//       debugPrint("Authorization process error: $e");
//     }
//   }

//   Future<void> _fetchData() async {
//     final now = DateTime.now();
//     // Query last 24 hours to ensure we capture all today's data
//     final startTime = now.subtract(const Duration(hours: 24));

//     try {
//       debugPrint("Fetching data from $startTime to $now");

//       // Fetch Steps using getTotalStepsInInterval
//       int? steps = await Health().getTotalStepsInInterval(startTime, now);
//       debugPrint("Steps from getTotalStepsInInterval: $steps");

//       // Also try fetching steps from getHealthDataFromTypes as fallback
//       debugPrint("Attempting alternative fetch method...");
//       List<HealthDataPoint> stepsData = await Health().getHealthDataFromTypes(
//         startTime: startTime,
//         endTime: now,
//         types: [HealthDataType.STEPS],
//       );

//       debugPrint("Steps data points found: ${stepsData.length}");

//       for (var point in stepsData) {
//         debugPrint(
//             "Step data point: value=${point.value}, source=${point.sourceId}, dateFrom=${point.dateFrom}, dateTo=${point.dateTo}");
//         if (point.value is NumericHealthValue) {
//           steps = (steps ?? 0) +
//               (point.value as NumericHealthValue).numericValue.toInt();
//         }
//       }
//       debugPrint("Total steps after aggregation: $steps");

//       // Fetch other data
//       List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
//         startTime: startTime,
//         endTime: now,
//         types: _types,
//       );

//       debugPrint("Total health data points: ${healthData.length}");

//       // Process data to find latest Heart Rate and Total Calories
//       double calories = 0;
//       int heartRate = 0;

//       for (var point in healthData) {
//         if (point.type == HealthDataType.TOTAL_CALORIES_BURNED) {
//           if (point.value is NumericHealthValue) {
//             calories +=
//                 (point.value as NumericHealthValue).numericValue.toDouble();
//           }
//         } else if (point.type == HealthDataType.HEART_RATE) {
//           if (point.value is NumericHealthValue) {
//             heartRate =
//                 (point.value as NumericHealthValue).numericValue.toInt();
//           }
//         }
//       }

//       setState(() {
//         _steps = steps ?? 0;
//         _calories = calories;
//         _heartRate = heartRate;
//         _healthDataList = healthData;
//         _status = "Data Fetched (Steps: ${_steps}, HR: ${_heartRate} bpm)";
//       });

//       // Refine Heart Rate to get actual latest
//       var heartRatePoints =
//           healthData.where((e) => e.type == HealthDataType.HEART_RATE).toList();
//       if (heartRatePoints.isNotEmpty) {
//         heartRatePoints.sort((a, b) => b.dateTo.compareTo(a.dateTo));
//         if (heartRatePoints.first.value is NumericHealthValue) {
//           setState(() {
//             _heartRate = (heartRatePoints.first.value as NumericHealthValue)
//                 .numericValue
//                 .toInt();
//           });
//         }
//       }
//     } catch (e) {
//       setState(() {
//         _status = "Error fetching data: $e";
//       });
//       debugPrint("Error during fetch: $e");
//       debugPrintStack();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Health Dashboard'),
//         actions: [
//           IconButton(
//             onPressed: _authorize,
//             icon: const Icon(Icons.refresh),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Status: $_status",
//                   style: const TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 20),
//               _buildMetricCard(
//                   title: "Steps Today",
//                   value: "$_steps",
//                   icon: Icons.directions_walk,
//                   color: Colors.orange),
//               const SizedBox(height: 10),
//               _buildMetricCard(
//                   title: "Active Calories",
//                   value: "${_calories.toStringAsFixed(1)} kcal",
//                   icon: Icons.local_fire_department,
//                   color: Colors.red),
//               const SizedBox(height: 10),
//               _buildMetricCard(
//                   title: "Last Heart Rate",
//                   value: "$_heartRate bpm",
//                   icon: Icons.favorite,
//                   color: Colors.pink),
//               const SizedBox(height: 20),
//               const Text("Data Log:",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: _healthDataList.length > 20
//                     ? 20
//                     : _healthDataList.length, // Limit to 20
//                 itemBuilder: (context, index) {
//                   final point = _healthDataList[index];
//                   return ListTile(
//                     leading: Icon(_getIconForType(point.type)),
//                     title: Text(point.type.name),
//                     subtitle: Text("${point.value} | ${point.dateTo}"),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMetricCard(
//       {required String title,
//       required String value,
//       required IconData icon,
//       required Color color}) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: color.withOpacity(0.2),
//               radius: 24,
//               child: Icon(icon, color: color, size: 28),
//             ),
//             const SizedBox(width: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: const TextStyle(fontSize: 14, color: Colors.grey)),
//                 Text(value,
//                     style: const TextStyle(
//                         fontSize: 24, fontWeight: FontWeight.bold)),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   IconData _getIconForType(HealthDataType type) {
//     switch (type) {
//       case HealthDataType.STEPS:
//         return Icons.directions_walk;
//       case HealthDataType.ACTIVE_ENERGY_BURNED:
//         return Icons.local_fire_department;
//       case HealthDataType.HEART_RATE:
//         return Icons.favorite;
//       default:
//         return Icons.health_and_safety;
//     }
//   }
// }
