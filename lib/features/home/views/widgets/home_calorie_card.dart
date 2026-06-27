import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/main5.dart';
import 'package:diet_lenz/widgets/calorie_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeCalorieCard extends ConsumerWidget {
  const HomeCalorieCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);
    final dashboard = foodLoggingState.dashboard;

    if (foodLoggingState.isLoading && dashboard == null) {
      return const CalorieCardShimmer();
    }

    if (dashboard == null) {
      return const CalorieProgressCard(
        date: "No data available",
        streakDays: 0,
        currentCalories: 0,
        targetCalories: 2000,
      );
    }

    final dateStr = dashboard.date != null
        ? DateFormat('EEEE, MMMM dd').format(dashboard.date!)
        : "Today";
    final currentCal = (dashboard.actuals?.calories ?? 0).round();
    final targetCal = (dashboard.targets?.calories ?? 2000).round();
    final streakDays = dashboard.streaks?.currentBasicStreak ?? 0;

    return CalorieProgressCard(
      date: dateStr,
      streakDays: streakDays,
      currentCalories: currentCal,
      targetCalories: targetCal,
    );
  }
}
