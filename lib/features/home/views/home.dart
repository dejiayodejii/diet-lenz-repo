import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/home/views/food_log_detail.dart';
import 'package:diet_lenz/features/home/views/food_logs.dart';
import 'package:diet_lenz/main4.dart';
import 'package:diet_lenz/main5.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Days of the week (excluding Sunday)
  final List<DayProgress> weekDays = [
    DayProgress(day: 'MON', date: 4, progress: 0.8, isToday: false),
    DayProgress(day: 'TUE', date: 5, progress: 0.7, isToday: false),
    DayProgress(day: 'WED', date: 6, progress: 1, isToday: true), // Current day
    DayProgress(day: 'THU', date: 7, progress: 0.0, isToday: false),
    DayProgress(day: 'FRI', date: 8, progress: 0.0, isToday: false),
    DayProgress(day: 'SAT', date: 9, progress: 0.0, isToday: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(height: 25),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WeekProgressRow(weekDays: weekDays),
                      const SizedBox(height: 25),
                      const Text(
                        "Count Your Daily Calories",
                        style: TextStyle(
                          fontFamily: AppFonts.lato,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const CalorieProgressCard(
                        date: "Thursday, June 06",
                        streakDays: 5,
                        currentCalories: 1250,
                        targetCalories: 1800,
                      ),
                      const SizedBox(height: 25),
                      const MacroNutrientsRow(
                        carbCurrent: 54,
                        carbTarget: 180,
                        proteinCurrent: 110,
                        proteinTarget: 135,
                        fatCurrent: 13,
                        fatTarget: 60,
                      ),
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
                      ...List.generate(3, (index) => const FoodLoggedPreview()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodLoggedPreview extends StatelessWidget {
  const FoodLoggedPreview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService.push(child: const FoodLogDetail());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AppImages.rice,
            scale: 2,
          ),
          const SizedBox(height: 10),
          const Text(
            "Suya Rice",
            style: TextStyle(
              fontFamily: AppFonts.lato,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: '2,000 kcal',
                  style: TextStyle(
                    fontFamily: AppFonts.spaceGrotesk,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: ' | ',
                  style: TextStyle(
                    color: Color.fromRGBO(47, 47, 47, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Protein: 125g',
                  style: TextStyle(
                    fontFamily: AppFonts.spaceGrotesk,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: ' | ',
                  style: TextStyle(
                    color: Color.fromRGBO(47, 47, 47, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Carbs: 300g',
                  style: TextStyle(
                    fontFamily: AppFonts.spaceGrotesk,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: ' | ',
                  style: TextStyle(
                    color: Color.fromRGBO(47, 47, 47, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Fat: 55g',
                  style: TextStyle(
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

// Week Progress Row Widget
class WeekProgressRow extends StatelessWidget {
  final List<DayProgress> weekDays;

  const WeekProgressRow({
    super.key,
    required this.weekDays,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekDays.map((dayData) {
        return BorderProgressContainer(
          progress: dayData.progress,
          width: 57,
          height: 88,
          borderWidth: 2,
          progressColor: AppColors.primaryColor,
          backgroundColor: AppColors.borderGrey,
          borderRadius: 11,
          child: Container(
            decoration: BoxDecoration(
              color:
                  dayData.isToday ? AppColors.primaryColor : Colors.transparent,
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
                          dayData.isToday ? Colors.white : AppColors.textColor,
                    ),
                  ),
                  Text(
                    '${dayData.date}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color:
                          dayData.isToday ? Colors.white : AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
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
  final double progress;
  final bool isToday;

  DayProgress({
    required this.day,
    required this.date,
    required this.progress,
    required this.isToday,
  });
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          AppImages.ppic,
          scale: 2,
          height: 60,
          width: 60,
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "WELCOME BACK,",
                style: TextStyle(
                    fontFamily: AppFonts.lato,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textLightGrey),
              ),
              Text(
                "AYODEJI EMMANUEL",
                style: TextStyle(
                  fontFamily: AppFonts.lato,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        SvgPicture.asset(AppImages.notif),
      ],
    );
  }
}
