import 'dart:io';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/home/controller/health_provider.dart';
import 'package:diet_lenz/features/home/views/food_logs.dart';
import 'package:diet_lenz/features/home/views/health_data_chart.dart';
import 'package:diet_lenz/main6.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:diet_lenz/widgets/stat_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:diet_lenz/data/models/health_ui_state.dart';
import 'package:diet_lenz/data/repositories/health_repository.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch streak data and health data when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(foodLoggingViewModelProvider.notifier).getCurrentStreak();
      // ref.read(healthProvider.notifier).checkPermissions();
    });
  }

  // TimeRange _getTimeRangeFromIndex(int index) {
  //   switch (index) {
  //     case 0:
  //       return TimeRange.daily;
  //     case 1:
  //       return TimeRange.weekly;
  //     case 2:
  //       return TimeRange.monthly;
  //     default:
  //       return TimeRange.daily;
  //   }
  // }

  void _onTimeRangeChanged(int index) {
    // setState(() {
    //   selectedIndex = index;
    // });

    // // Fetch health data for the selected time range
    // final timeRange = _getTimeRangeFromIndex(index);
    // ref.read(healthProvider.notifier).loadHealthData(timeRange);
  }

  @override
  Widget build(BuildContext context) {
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);
    // final healthState = ref.watch(healthProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Progress'),
        actions: [
          // if (healthState.hasData)
          //   IconButton(
          //     icon: const Icon(Icons.refresh),
          //     onPressed: () {
          //       final timeRange = _getTimeRangeFromIndex(selectedIndex);
          //       ref.read(healthProvider.notifier).refresh(timeRange);
          //     },
          //   ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreakWidget(
                streak: foodLoggingState.streak,
                isLoading: foodLoggingState.isLoading &&
                    foodLoggingState.streak == null,
              ),
              const SizedBox(height: 40),

              // // Health Permission Request
              // if (healthState.needsPermissions)
              //   _HealthPermissionCard(
              //     onRequest: () async {
              //       final granted = await ref
              //           .read(healthProvider.notifier)
              //           .requestPermissions();
              //       if (!granted && context.mounted) {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(
              //             content: Text(
              //               'Please install Health Connect from the Play Store to enable health tracking.',
              //             ),
              //             duration: Duration(seconds: 4),
              //           ),
              //         );
              //       }
              //     },
              //   )
              // // Health Data Stats
              // else if (healthState.hasData) ...[
              //   _HealthSourceAttribution(),
              //   const SizedBox(height: 10),
              //   _HealthStatsRow(healthData: healthState.healthData),
              // ]
              // // Loading State
              // else if (healthState.isLoading)
              //   _HealthStatsLoading()
              // // Default/Placeholder
              // else ...[
              //   _HealthSourceAttribution(),
              //   const SizedBox(height: 10),
              //   _HealthStatsRow(healthData: healthState.healthData),
              // ],
              // const SizedBox(height: 20),
              // const Text(
              //   " Trends and Insights",
              //   style: TextStyle(
              //     fontSize: 22,
              //     color: Colors.white,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
              // const SizedBox(height: 20),
              // SegmentedToggle(
              //   options: const ['Daily', 'Weekly', 'Monthly'],
              //   selectedIndex: selectedIndex,
              //   onChanged: _onTimeRangeChanged,
              // ),
              // const SizedBox(height: 50),
              // // HealthChart(
              // //   timeRange: _getTimeRangeFromIndex(selectedIndex),
              // // ),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class StreakWidget extends StatelessWidget {
  const StreakWidget({
    super.key,
    this.streak,
    this.isLoading = false,
  });

  final dynamic streak;
  final bool isLoading;

  Widget _buildShimmerValue() {
    return Shimmer.fromColors(
      baseColor: const Color.fromRGBO(30, 30, 30, 1),
      highlightColor: const Color.fromRGBO(50, 50, 50, 1),
      child: Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildStreakValue(int? value) {
    if (isLoading) {
      return _buildShimmerValue();
    }
    return Text(
      '${value ?? 0}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      _buildStreakValue(streak?.longestBasicStreak),
                      const SizedBox(width: 4),
                      const Text(
                        'Days',
                        style: TextStyle(
                          color: Color.fromRGBO(158, 160, 165, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(AppImages.fire),
                      const Text(" Longest Streak",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const Text("Keep it going - you are building \nmomentum",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      _buildStreakValue(streak?.currentBasicStreak),
                      const SizedBox(width: 4),
                      const Text(
                        'Days',
                        style: TextStyle(
                          color: Color.fromRGBO(158, 160, 165, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(AppImages.fire),
                      const Text(" Consistency king",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const Text("Keep it going - you are building \nmomentum",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStreakValue(streak?.totalDaysLogged),
            const SizedBox(height: 10),
            Row(
              children: [
                SvgPicture.asset(AppImages.fire),
                const Text(" Goals completed",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
              ],
            ),
            const Text("Keep it going - you are building momentum",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}

// Health Source Attribution
class _HealthSourceAttribution extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final source = Platform.isIOS ? 'Apple Health' : 'Health Connect';
    final icon = Platform.isIOS ? Icons.favorite : Icons.health_and_safety;
    return Row(
      children: [
        Icon(icon, color: Platform.isIOS ? Colors.red : Colors.green, size: 16),
        const SizedBox(width: 6),
        Text(
          'Data from $source',
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromRGBO(158, 160, 165, 1),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Health Stats Row Widget
class _HealthStatsRow extends StatelessWidget {
  final dynamic healthData;

  const _HealthStatsRow({required this.healthData});

  String _formatNumber(num value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.round().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            leading: Image.asset(
              AppImages.step,
              scale: 2,
              height: 34,
              width: 34,
            ),
            value: _formatNumber(healthData.steps),
            label: 'STEPS',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            leading: Image.asset(
              AppImages.burn,
              height: 34,
              width: 34,
              scale: 2,
            ),
            value: '${healthData.totalCalories.round()}',
            label: 'CAL BURN',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            leading: Image.asset(
              AppImages.heart,
              height: 34,
              width: 34,
              scale: 2,
            ),
            value: healthData.heartRateAvg != null
                ? '${healthData.heartRateAvg!.round()}'
                : '--',
            label: 'HEART RATE',
          ),
        ),
      ],
    );
  }
}

// Health Stats Loading Shimmer
class _HealthStatsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 5,
              right: index == 2 ? 0 : 5,
            ),
            child: Shimmer.fromColors(
              baseColor: const Color.fromRGBO(30, 30, 30, 1),
              highlightColor: const Color.fromRGBO(50, 50, 50, 1),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Health Permission Card
class _HealthPermissionCard extends StatelessWidget {
  final VoidCallback onRequest;

  const _HealthPermissionCard({required this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(36, 38, 43, 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromRGBO(57, 60, 67, 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(57, 60, 67, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.health_and_safety, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Platform.isIOS
                          ? 'Connect Apple Health'
                          : 'Enable Health Data',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            Platform.isIOS
                ? 'Allow Diet Lenz to read your steps, calories, and heart rate from Apple Health (HealthKit).'
                : 'Connect your health app to track steps, calories, and heart rate automatically.',
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(158, 160, 165, 1),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Grant Permission',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
