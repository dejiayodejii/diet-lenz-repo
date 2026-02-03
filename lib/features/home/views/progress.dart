import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/home/views/food_logs.dart';
import 'package:diet_lenz/main6.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:diet_lenz/widgets/stat_card.dart';
import 'package:shimmer/shimmer.dart';

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
    // Fetch streak data when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(foodLoggingViewModelProvider.notifier).getCurrentStreak();
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Progress'),
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
              const Text(
                " Trends and Insights",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              SegmentedToggle(
                options: const ['Daily', 'Weekly', 'Monthly'],
                selectedIndex: selectedIndex,
                onChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
              const SizedBox(height: 50),
              const CalorieChart(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      leading: Image.asset(
                        AppImages.step,
                        scale: 2,
                        height: 34,
                        width: 34,
                      ),
                      value: '6,356',
                      label: 'STEPS',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      leading: Image.asset(
                        AppImages.burn,
                        height: 34,
                        width: 34,
                        scale: 2,
                      ),
                      value: '3.2 KCAL',
                      label: 'CAL BURN',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      leading: Image.asset(
                        AppImages.heart,
                        height: 34,
                        width: 34,
                        scale: 2,
                      ),
                      value: '6,356',
                      label: 'STEPS',
                    ),
                  ),
                ],
              ),
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
