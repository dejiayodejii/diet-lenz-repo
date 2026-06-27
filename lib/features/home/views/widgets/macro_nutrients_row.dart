import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:flutter/material.dart';

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
