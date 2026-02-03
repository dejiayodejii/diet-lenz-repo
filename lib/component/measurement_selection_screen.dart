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

  // Optional overrides for specific units
  final double? minLeftValue;
  final double? maxLeftValue;
  final double? minRightValue;
  final double? maxRightValue;
  final double Function(double)? leftToRightConverter;
  final double Function(double)? rightToLeftConverter;
  final double? leftStep;
  final double? rightStep;

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
    this.minLeftValue,
    this.maxLeftValue,
    this.minRightValue,
    this.maxRightValue,
    this.leftToRightConverter,
    this.rightToLeftConverter,
    this.leftStep,
    this.rightStep,
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

  double get currentMin => isLeftUnitSelected
      ? (widget.minLeftValue ?? widget.minValue)
      : (widget.minRightValue ?? widget.minValue);

  double get currentMax => isLeftUnitSelected
      ? (widget.maxLeftValue ?? widget.maxValue)
      : (widget.maxRightValue ?? widget.maxValue);

  double get currentStep =>
      isLeftUnitSelected ? (widget.leftStep ?? 1.0) : (widget.rightStep ?? 1.0);

  void _switchUnit(bool toLeft) {
    if (isLeftUnitSelected == toLeft) return;

    setState(() {
      isLeftUnitSelected = toLeft;
      if (toLeft) {
        // Switched to Left
        if (widget.rightToLeftConverter != null) {
          selectedValue = widget.rightToLeftConverter!(selectedValue);
        }
      } else {
        // Switched to Right
        if (widget.leftToRightConverter != null) {
          selectedValue = widget.leftToRightConverter!(selectedValue);
        }
      }

      // Ensure value is within new bounds
      selectedValue = selectedValue.clamp(currentMin, currentMax);
    });
  }

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
                    onLeftTap: () => _switchUnit(true),
                    onRightTap: () => _switchUnit(false),
                  ),
                  const SizedBox(height: 80),
                  MeasurementValueDisplay(
                    value: selectedValue,
                    unit: currentUnit,
                  ),
                  RulerPicker(
                    minValue: currentMin,
                    maxValue: currentMax,
                    step: currentStep,
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
