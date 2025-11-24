import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/measurement_value_display.dart';
import 'package:diet_lenz/component/unit_toggle_widget.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/main2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MeasurementSelectionScreen extends StatefulWidget {
  final String title;
  final String leftUnit;
  final String rightUnit;
  final double minValue;
  final double maxValue;
  final double initialValue;
  final Widget nextScreen;
  final bool initialLeftUnitSelected;
  final Function(double value, String unit, bool isLeftUnit)? onContinue;

  const MeasurementSelectionScreen({
    super.key,
    required this.title,
    required this.leftUnit,
    required this.rightUnit,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.nextScreen,
    this.initialLeftUnitSelected = true,
    this.onContinue,
  });

  @override
  State<MeasurementSelectionScreen> createState() =>
      _MeasurementSelectionScreenState();
}

class _MeasurementSelectionScreenState
    extends State<MeasurementSelectionScreen> {
  late bool isLeftUnitSelected;
  late double selectedValue;

  @override
  void initState() {
    super.initState();
    isLeftUnitSelected = widget.initialLeftUnitSelected;
    selectedValue = widget.initialValue;
  }

  String get currentUnit =>
      isLeftUnitSelected ? widget.leftUnit : widget.rightUnit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                NavigationService.pop();
              },
              child: SvgPicture.asset(AppImages.backButton),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 25),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                letterSpacing: 0,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  UnitToggleWidget(
                    leftUnit: widget.leftUnit,
                    rightUnit: widget.rightUnit,
                    isLeftSelected: isLeftUnitSelected,
                    onLeftTap: () {
                      setState(() {
                        isLeftUnitSelected = true;
                      });
                    },
                    onRightTap: () {
                      setState(() {
                        isLeftUnitSelected = false;
                      });
                    },
                  ),
                  const SizedBox(height: 80),
                  MeasurementValueDisplay(
                    value: selectedValue,
                    unit: currentUnit,
                  ),
                  RulerPicker(
                    minValue: widget.minValue,
                    maxValue: widget.maxValue,
                    initialValue: selectedValue,
                    onValueChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            CustomYafButton(
              fontSize: 16,
              weight: FontWeight.w600,
              iconPositionLeft: false,
              text: "Continue",
              iconWidget: SvgPicture.asset(AppImages.arrowRight),
              onPressed: () {
                // Call the callback if provided
                widget.onContinue?.call(
                  selectedValue,
                  currentUnit,
                  isLeftUnitSelected,
                );
                NavigationService.push(child: widget.nextScreen);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
