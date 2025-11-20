import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/home/views/food_log_detail.dart';
import 'package:diet_lenz/features/home/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodLogsScreen extends ConsumerStatefulWidget {
  const FoodLogsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FoodLogsScreenState();
}

class _FoodLogsScreenState extends ConsumerState<FoodLogsScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Logs'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SegmentedToggle(
              options: const ['All', 'Favourite'],
              selectedIndex: selectedIndex,
              onChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            const SizedBox(height: 35),
            Expanded(
              child: SingleChildScrollView(
                child: _buildContentForSelectedTab(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build content based on selected toggle
  Widget _buildContentForSelectedTab() {
    switch (selectedIndex) {
      case 0: // All
        return Column(
          children: [
            ...List.generate(
                5,
                (index) => GestureDetector(
                    onTap: () {
                      NavigationService.push(child: const FoodLogDetail());
                    },
                    child: FoodLoggedPreview())),
          ],
        );
      case 1: // Favourite
        return Column(
          children: [
            ...List.generate(
                5,
                (index) => GestureDetector(
                    onTap: () {
                      NavigationService.push(child: const FoodLogDetail());
                    },
                    child: const FavouriteFood())),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class FavouriteFood extends StatelessWidget {
  const FavouriteFood({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              AppImages.salad,
              scale: 2,
              height: 80,
              width: 80,
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Text("Chicked Salad",
                  style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600)),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 40),
          ],
        ),
        SizedBox(height: 35)
      ],
    );
  }
}

// Reusable Segmented Toggle Widget
class SegmentedToggle extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final double? height;

  const SegmentedToggle({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 49,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: unselectedColor ?? Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(
          options.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: selectedIndex == index
                      ? (selectedColor ?? AppColors.primaryColor)
                      : null,
                ),
                child: Center(
                  child: Text(
                    options[index],
                    style: TextStyle(
                      color: selectedIndex == index
                          ? (selectedTextColor ?? Colors.white)
                          : (unselectedTextColor ?? Colors.black),
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      fontFamily: AppFonts.workSans,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
