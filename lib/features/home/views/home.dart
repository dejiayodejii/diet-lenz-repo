import 'package:openapi/api.dart';
import 'package:diet_lenz/component/update_dialog.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/update_service.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/home/views/food_logs.dart';
import 'package:diet_lenz/features/home/views/widgets/home_calorie_card.dart';
import 'package:diet_lenz/features/home/views/widgets/home_food_logs_list.dart';
import 'package:diet_lenz/features/home/views/widgets/home_header.dart';
import 'package:diet_lenz/features/home/views/widgets/home_macro_row.dart';
import 'package:diet_lenz/features/home/views/widgets/week_progress_row.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

export 'widgets/calorie_tracker_card.dart';
export 'widgets/food_logged_preview.dart';
export 'widgets/home_calorie_card.dart';
export 'widgets/home_food_logs_list.dart';
export 'widgets/home_header.dart';
export 'widgets/home_macro_row.dart';
export 'widgets/macro_nutrients_row.dart';
export 'widgets/week_progress_row.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const int _progressHistoryDays = 30;

  late DateTime _selectedDate;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  List<DayProgress> _generateWeekDays() {
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);
    final weeklyTrend = foodLoggingState.weeklyTrend;
    final dashboard = foodLoggingState.dashboard;
    final targetCal = (dashboard?.targets?.calories ?? 2000).toDouble();

    // debugPrint(
    //     '📊 [WeekDays] dashboard: ${dashboard != null ? "loaded" : "null"}');
    // debugPrint('📊 [WeekDays] targetCalories: $targetCal');
    // debugPrint(
    //     '📊 [WeekDays] weeklyTrend: ${weeklyTrend != null ? "loaded (${weeklyTrend.dailyTrends.length} days)" : "null"}');

    // Create a map for easy lookup of trend data
    final Map<String, DailyTrendDto> trendMap = {};
    if (weeklyTrend != null && weeklyTrend.dailyTrends.isNotEmpty) {
      for (var day in weeklyTrend.dailyTrends) {
        if (day.date != null) {
          final dateKey = DateFormat('yyyy-MM-dd').format(day.date!);
          trendMap[dateKey] = day;
          // debugPrint(
          //     '📊 [WeekDays] trend entry: $dateKey -> calories: ${day.actuals?.calories}');
        }
      }
    }

    final today = _today;

    // Show the last 30 days: 29 days ago -> today (today is rightmost)
    final startDate =
        today.subtract(const Duration(days: _progressHistoryDays - 1));

    const dayNamesList = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    // debugPrint(
    //     '📊 [WeekDays] range: ${DateFormat('yyyy-MM-dd').format(startDate)} to ${DateFormat('yyyy-MM-dd').format(today)}');

    // Generate 30 days from startDate to today
    return List.generate(_progressHistoryDays, (index) {
      final date = startDate.add(Duration(days: index));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);

      // weekday: 1=Mon, 7=Sun
      final dayName = dayNamesList[date.weekday - 1];

      // Lookup data for this day
      final trend = trendMap[dateKey];

      final isToday = date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;

      double progress = 0.0;
      if (trend != null && trend.actuals?.calories != null) {
        progress = (trend.actuals!.calories! / targetCal).clamp(0.0, 1.0);
      }

      // debugPrint(
      //     '📊 [WeekDays] $dayName $dateKey -> hasData: ${trend != null}, progress: ${progress.toStringAsFixed(2)}, isToday: $isToday');

      return DayProgress(
        day: dayName,
        date: date.day,
        fullDate: date,
        progress: progress,
        isToday: isToday,
      );
    });
  }

  /// Called when a day card is tapped
  void _onDaySelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    // Refresh all date-scoped data, including the seven-day trend window.
    ref.read(foodLoggingViewModelProvider.notifier).getUserRecipes(date: date);
    ref.read(foodLoggingViewModelProvider.notifier).getDashboard(date: date);
    ref
        .read(foodLoggingViewModelProvider.notifier)
        .getWeeklyTrend(startDate: date);
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = _today;
    // Fetch dashboard, weekly trend, and user recipes on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(foodLoggingViewModelProvider.notifier)
          .getDashboard(date: _selectedDate);
      ref
          .read(foodLoggingViewModelProvider.notifier)
          .getWeeklyTrend(startDate: _selectedDate);
      ref
          .read(foodLoggingViewModelProvider.notifier)
          .getUserRecipes(date: _selectedDate);
      ref.read(userProfileViewModelProvider.notifier).getUserProfile();
    });
  }

  Future<void> _refreshData() async {
    // Refresh all data for the selected date
    await Future.wait([
      ref
          .read(foodLoggingViewModelProvider.notifier)
          .getDashboard(date: _selectedDate),
      ref
          .read(foodLoggingViewModelProvider.notifier)
          .getWeeklyTrend(startDate: _selectedDate),
      ref
          .read(foodLoggingViewModelProvider.notifier)
          .getUserRecipes(date: _selectedDate),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _generateWeekDays(); // Regenerate based on current state

    return AppUpdateAlert(
      upgrader: AppUpdateService().upgrader,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                const HomeHeader(),
                const SizedBox(height: 25),
                WeekProgressRow(
                  weekDays: weekDays,
                  selectedDate: _selectedDate,
                  onDaySelected: _onDaySelected,
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    color: AppColors.primaryColor,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Count Your Daily Calories",
                            style: TextStyle(
                              fontFamily: AppFonts.lato,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 25),
                          const HomeCalorieCard(),
                          const SizedBox(height: 25),
                          const HomeMacroRow(),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Food Log",
                                style: TextStyle(
                                  fontFamily: AppFonts.lato,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  NavigationService.push(
                                      child: const FoodLogsScreen());
                                },
                                child: const Text(
                                  "See All",
                                  style: TextStyle(
                                      fontFamily: AppFonts.workSans,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const HomeFoodLogsList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
