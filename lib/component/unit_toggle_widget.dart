import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class UnitToggleWidget extends StatelessWidget {
  final String leftUnit;
  final String rightUnit;
  final bool isLeftSelected;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;

  const UnitToggleWidget({
    super.key,
    required this.leftUnit,
    required this.rightUnit,
    required this.isLeftSelected,
    required this.onLeftTap,
    required this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(36, 38, 43, 1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onLeftTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: isLeftSelected ? AppColors.primaryColor : null,
                  boxShadow: isLeftSelected
                      ? [
                          const BoxShadow(
                            color: Color.fromRGBO(37, 99, 235, 0.25),
                            spreadRadius: 4,
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      leftUnit,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: AppFonts.workSans,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onRightTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: !isLeftSelected ? AppColors.primaryColor : null,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: !isLeftSelected
                      ? [
                          const BoxShadow(
                            color: Color.fromRGBO(249, 115, 22, 0.25),
                            spreadRadius: 4,
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      rightUnit,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: AppFonts.workSans,
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
