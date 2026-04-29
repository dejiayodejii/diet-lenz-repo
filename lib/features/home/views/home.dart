import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/home/views/food_log_detail.dart';
import 'package:diet_lenz/features/home/views/food_logs.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:diet_lenz/main4.dart';
import 'package:diet_lenz/main5.dart';
import 'package:diet_lenz/widgets/calorie_card_shimmer.dart';
import 'package:diet_lenz/widgets/food_log_shimmer.dart';
import 'package:diet_lenz/widgets/macro_row_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// The currently selected date (defaults to today)
  late DateTime _selectedDate;

  /// Generate last 7 days (today on the right, 6 previous days to the left)
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

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Show the last 7 days: 6 days ago -> today (today is rightmost)
    final startDate = today.subtract(const Duration(days: 6));

    const dayNamesList = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    // debugPrint(
    //     '📊 [WeekDays] range: ${DateFormat('yyyy-MM-dd').format(startDate)} to ${DateFormat('yyyy-MM-dd').format(today)}');

    // Generate 7 days from startDate to today
    return List.generate(7, (index) {
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
    // Refresh recipes and dashboard for the selected date
    ref.read(foodLoggingViewModelProvider.notifier).getUserRecipes(date: date);
    ref.read(foodLoggingViewModelProvider.notifier).getDashboard(date: date);
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    // Fetch dashboard, weekly trend, and user recipes on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(foodLoggingViewModelProvider.notifier)
          .getDashboard(date: _selectedDate);
      ref.read(foodLoggingViewModelProvider.notifier).getWeeklyTrend();
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
      ref.read(foodLoggingViewModelProvider.notifier).getWeeklyTrend(),
      ref
          .read(foodLoggingViewModelProvider.notifier)
          .getUserRecipes(date: _selectedDate),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _generateWeekDays(); // Regenerate based on current state

    return Scaffold(
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
                        _buildCalorieCard(),
                        const SizedBox(height: 25),
                        _buildMacroRow(),
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
                        _buildFoodLogsList(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalorieCard() {
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);
    final dashboard = foodLoggingState.dashboard;

    // Show shimmer while loading
    if (foodLoggingState.isLoading && dashboard == null) {
      return const CalorieCardShimmer();
    }

    // Show default values if no dashboard data
    if (dashboard == null) {
      return const CalorieProgressCard(
        date: "No data available",
        streakDays: 0,
        currentCalories: 0,
        targetCalories: 2000,
      );
    }

    // Display dashboard data
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

  Widget _buildMacroRow() {
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);
    final dashboard = foodLoggingState.dashboard;

    // Show shimmer while loading
    if (foodLoggingState.isLoading && dashboard == null) {
      return const MacroRowShimmer();
    }

    // Show default values if no dashboard data
    if (dashboard == null) {
      return const MacroNutrientsRow(
        carbCurrent: 0,
        carbTarget: 180,
        proteinCurrent: 0,
        proteinTarget: 135,
        fatCurrent: 0,
        fatTarget: 60,
      );
    }

    // Display dashboard data
    final carbCurrent = (dashboard.actuals?.carbsGrams ?? 0).round();
    final carbTarget = (dashboard.targets?.carbsGrams ?? 180).round();
    final proteinCurrent = (dashboard.actuals?.proteinGrams ?? 0).round();
    final proteinTarget = (dashboard.targets?.proteinGrams ?? 135).round();
    final fatCurrent = (dashboard.actuals?.fatGrams ?? 0).round();
    final fatTarget = (dashboard.targets?.fatGrams ?? 60).round();

    return MacroNutrientsRow(
      carbCurrent: carbCurrent,
      carbTarget: carbTarget,
      proteinCurrent: proteinCurrent,
      proteinTarget: proteinTarget,
      fatCurrent: fatCurrent,
      fatTarget: fatTarget,
    );
  }

  Widget _buildFoodLogsList() {
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);

    if (foodLoggingState.isLoading) {
      // Show shimmer loading
      return Column(
        children: List.generate(3, (index) => const FoodLogShimmer()),
      );
    }

    if (foodLoggingState.errorMessage != null) {
      // Show error message
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            foodLoggingState.errorMessage!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final recipes = foodLoggingState.userRecipes;

    if (recipes == null || recipes.isEmpty) {
      // Show empty state
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(Icons.hourglass_empty, size: 50),
              SizedBox(height: 15),
              Text(
                'No food logs yet. Start by scanning your first meal!',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Show actual recipes (limit to 6 for home screen)
    final displayRecipes = recipes.take(6).toList();
    return Column(
      children: displayRecipes
          .map((recipe) => FoodLoggedPreview(recipe: recipe))
          .toList(),
    );
  }
}

class FoodLoggedPreview extends ConsumerWidget {
  final RecipeResponseDto recipe;
  final bool fromFavourites;

  const FoodLoggedPreview({
    super.key,
    required this.recipe,
    this.fromFavourites = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = recipe.isFavorite ?? false;

    return GestureDetector(
      onTap: () {
        NavigationService.push(
          child: FoodLogDetail(
            recipe: recipe,
            fromFavorite: fromFavourites,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display image from URL or fallback to default with favorite icon
          Container(
            width: double.infinity,
            child: Stack(
              children: [
                recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
                    ? Image.network(
                        recipe.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            AppImages.rice,
                            scale: 2,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        AppImages.rice,
                        scale: 2,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                // Favorite icon at top right
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () async {
                      if (recipe.id != null) {
                        await ref
                            .read(foodLoggingViewModelProvider.notifier)
                            .toggleFavoriteLocally(recipe.id!);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            recipe.foodName ?? "Unknown Food",
            style: const TextStyle(
              fontFamily: AppFonts.lato,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '${recipe.macros?.calories?.toStringAsFixed(0) ?? "0"} kcal',
                  style: const TextStyle(
                    fontFamily: AppFonts.spaceGrotesk,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const TextSpan(
                  text: ' | ',
                  style: TextStyle(
                    color: Color.fromRGBO(47, 47, 47, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text:
                      'Protein: ${recipe.macros?.proteinGrams?.toStringAsFixed(0) ?? "0"}g',
                  style: const TextStyle(
                    fontFamily: AppFonts.spaceGrotesk,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const TextSpan(
                  text: ' | ',
                  style: TextStyle(
                    color: Color.fromRGBO(47, 47, 47, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text:
                      'Carbs: ${recipe.macros?.carbsGrams?.toStringAsFixed(0) ?? "0"}g',
                  style: const TextStyle(
                    fontFamily: AppFonts.spaceGrotesk,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const TextSpan(
                  text: ' | ',
                  style: TextStyle(
                    color: Color.fromRGBO(47, 47, 47, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text:
                      'Fat: ${recipe.macros?.fatGrams?.toStringAsFixed(0) ?? "0"}g',
                  style: const TextStyle(
                    fontFamily: AppFonts.spaceGrotesk,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

// Week Progress Row Widget (scrollable, today on the right)
class WeekProgressRow extends StatefulWidget {
  final List<DayProgress> weekDays;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;

  const WeekProgressRow({
    super.key,
    required this.weekDays,
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  State<WeekProgressRow> createState() => _WeekProgressRowState();
}

class _WeekProgressRowState extends State<WeekProgressRow> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to the end (today) after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.weekDays.asMap().entries.map((entry) {
          final index = entry.key;
          final dayData = entry.value;
          final isSelected =
              dayData.fullDate.year == widget.selectedDate.year &&
                  dayData.fullDate.month == widget.selectedDate.month &&
                  dayData.fullDate.day == widget.selectedDate.day;
          return Padding(
            padding: EdgeInsets.only(
              right: index < widget.weekDays.length - 1 ? 10 : 0,
            ),
            child: GestureDetector(
              onTap: () => widget.onDaySelected(dayData.fullDate),
              child: BorderProgressContainer(
                progress: dayData.progress,
                width: 57,
                height: 88,
                borderWidth: 2,
                progressColor: AppColors.primaryColor,
                backgroundColor: AppColors.borderGrey,
                borderRadius: 11,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayData.day,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color:
                                isSelected ? Colors.white : AppColors.textColor,
                          ),
                        ),
                        Text(
                          '${dayData.date}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color:
                                isSelected ? Colors.white : AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Calorie Tracker Card Widget
class CalorieTrackerCard extends StatelessWidget {
  final String date;
  final int streakDays;
  final int currentCalories;
  final int targetCalories;

  const CalorieTrackerCard({
    super.key,
    required this.date,
    required this.streakDays,
    required this.currentCalories,
    required this.targetCalories,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = currentCalories / targetCalories;

    return Container(
      width: double.infinity,
      height: 212,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: Color.fromRGBO(163, 168, 170, 1),
                  fontFamily: AppFonts.lato,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$streakDays Day Streak",
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: AppFonts.lato,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Icon(
                            Icons.circle,
                            size: 8,
                            color: index < streakDays
                                ? AppColors.primaryColor
                                : Colors.white24,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            width: 248,
            height: 124,
            child: CustomPaint(
              size: const Size(248, 124),
              painter: SemiCircleProgressPainter(
                progress: progress,
                strokeWidth: 20,
                width: 248,
                height: 124,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Color(0xFFFF6B35),
                      size: 28,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$currentCalories',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: ' kcal',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'of $targetCalories',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// MacroNutrients Row Widget
class MacroNutrientsRow extends StatelessWidget {
  final int carbCurrent;
  final int carbTarget;
  final int proteinCurrent;
  final int proteinTarget;
  final int fatCurrent;
  final int fatTarget;

  const MacroNutrientsRow({
    super.key,
    required this.carbCurrent,
    required this.carbTarget,
    required this.proteinCurrent,
    required this.proteinTarget,
    required this.fatCurrent,
    required this.fatTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MacroNutrientCard(
            name: "Carb",
            current: carbCurrent,
            target: carbTarget,
            unit: "g",
            progress: carbCurrent / carbTarget,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: MacroNutrientCard(
            name: "Protein",
            current: proteinCurrent,
            target: proteinTarget,
            unit: "g",
            progress: proteinCurrent / proteinTarget,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: MacroNutrientCard(
            name: "Fat",
            current: fatCurrent,
            target: fatTarget,
            unit: "g",
            progress: fatCurrent / fatTarget,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}

// Reusable MacroNutrient Card Widget
class MacroNutrientCard extends StatelessWidget {
  final String name;
  final int current;
  final int target;
  final String unit;
  final double progress;
  final Color color;

  const MacroNutrientCard({
    super.key,
    required this.name,
    required this.current,
    required this.target,
    required this.unit,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 116,
      height: 81,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontFamily: AppFonts.lato,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            minHeight: 6,
            value: progress,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: const Color.fromRGBO(56, 65, 71, 1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          const SizedBox(height: 5),
          Text(
            "$current / $target$unit",
            style: const TextStyle(
              color: Color.fromRGBO(163, 168, 170, 1),
              fontFamily: AppFonts.lato,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class to hold day data
class DayProgress {
  final String day;
  final int date;
  final DateTime fullDate;
  final double progress;
  final bool isToday;

  DayProgress({
    required this.day,
    required this.date,
    required this.fullDate,
    required this.progress,
    required this.isToday,
  });
}

class HomeHeader extends ConsumerWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider).authResponse;
    final userName = authState?.firstName ?? "John Doe";

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: authState!.profilePhoto != null
              ? CachedNetworkImage(
                  imageUrl: authState!.profilePhoto!,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Container(
                    height: 50,
                    width: 50,
                    color: AppColors.primaryColor.withOpacity(0.2),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              : Container(
                  height: 50,
                  width: 50,
                  color: AppColors.primaryColor.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: AppColors.primaryColor,
                  ),
                ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "WELCOME,",
                style: TextStyle(
                    fontFamily: AppFonts.lato,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textLightGrey),
              ),
              Text(
                userName,
                style: const TextStyle(
                  fontFamily: AppFonts.lato,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // SvgPicture.asset(AppImages.notif),
      ],
    );
  }
}
