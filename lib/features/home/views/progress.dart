import 'dart:io';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/unit_toggle_widget.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/data/models/health_data.dart';
import 'package:diet_lenz/data/models/health_ui_state.dart';
import 'package:diet_lenz/data/repositories/health_repository.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/home/controller/health_provider.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:openapi/api.dart';
import 'package:shimmer/shimmer.dart';

part 'progress_widgets/weight_progress_card.dart';
part 'progress_widgets/macro_composition_card.dart';
part 'progress_widgets/energy_balance_card.dart';
part 'progress_widgets/calorie_tracker_health_card.dart';
part 'progress_widgets/log_weight_screen.dart';
part 'progress_widgets/streak_widget.dart';

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
      ref
          .read(userProfileViewModelProvider.notifier)
          .getWeightProgress(filter: 'daily');
      ref
          .read(userProfileViewModelProvider.notifier)
          .getMacroComposition(filter: 'daily');
      ref
          .read(userProfileViewModelProvider.notifier)
          .getEnergyBalance(filter: 'daily');
      // ref.read(healthProvider.notifier).checkPermissions();
    });
  }

  TimeRange _getTimeRangeFromIndex(int index) {
    switch (index) {
      case 0:
        return TimeRange.daily;
      case 1:
        return TimeRange.weekly;
      case 2:
        return TimeRange.monthly;
      default:
        return TimeRange.daily;
    }
  }

  void _onTimeRangeChanged(int index) {
    setState(() {
      selectedIndex = index;
    });

    final timeRange = _getTimeRangeFromIndex(index);
    final filter = _filterFromIndex(index);
    ref
        .read(userProfileViewModelProvider.notifier)
        .getEnergyBalance(filter: filter);
    ref.read(healthProvider.notifier).loadHealthData(timeRange);
  }

  String _filterFromIndex(int index) {
    switch (index) {
      case 0:
        return 'daily';
      case 1:
        return 'weekly';
      case 2:
        return 'monthly';
      default:
        return 'daily';
    }
  }

  @override
  Widget build(BuildContext context) {
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Progress'),
        actions: const [
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
              const SizedBox(height: 28),
              const WeightProgressCard(),
              const SizedBox(height: 28),
              const MacroCompositionCard(),
              const SizedBox(height: 28),
              showHealthWidget(),
              const SizedBox(height: 28),
              EnergyBalanceCard(
                selectedIndex: selectedIndex,
                onRangeChanged: _onTimeRangeChanged,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget showHealthWidget() {
    final healthState = ref.watch(healthProvider);
    return CalorieTrackerHealthCard(
      healthState: healthState,
      selectedIndex: selectedIndex,
      onRangeChanged: _onTimeRangeChanged,
      onRequestPermissions: () async {
        final messenger = ScaffoldMessenger.of(context);
        final granted =
            await ref.read(healthProvider.notifier).requestPermissions();
        if (!mounted) return;
        if (!granted) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                Platform.isAndroid
                    ? 'Please install or enable Health Connect to track phone health data.'
                    : 'Health access was not granted.',
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
    );
  }
}
