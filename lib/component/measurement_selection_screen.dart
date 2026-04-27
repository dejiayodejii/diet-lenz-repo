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

  /// When true and in left-unit mode, shows two separate integer pickers
  /// for feet and inches (e.g. 5'11") instead of a single decimal ruler.
  final bool useCompoundLeftUnit;

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
    this.useCompoundLeftUnit = false,
  });

  @override
  State<MeasurementSelectionScreen> createState() =>
      _MeasurementSelectionScreenState();
}

class _MeasurementSelectionScreenState
    extends State<MeasurementSelectionScreen> {
  late bool isLeftUnitSelected;
  late double selectedValue;

  // Used only when useCompoundLeftUnit is true and in left-unit mode
  int _feetValue = 5;
  int _inchesValue = 7;

  @override
  void initState() {
    super.initState();
    isLeftUnitSelected = widget.initialLeftUnitSelected;
    selectedValue = widget.initialValue;
    if (widget.useCompoundLeftUnit) {
      if (isLeftUnitSelected) {
        _initFeetAndInches(selectedValue);
      } else if (widget.rightToLeftConverter != null) {
        _initFeetAndInches(widget.rightToLeftConverter!(selectedValue));
      }
    }
  }

  void _initFeetAndInches(double decimalFeet) {
    final minFt = (widget.minLeftValue ?? widget.minValue).toInt();
    final maxFt = (widget.maxLeftValue ?? widget.maxValue).toInt();
    int feet = decimalFeet.floor().clamp(minFt, maxFt);
    int inches =
        ((decimalFeet - decimalFeet.floor()) * 12).round().clamp(0, 11);
    if (inches == 12) {
      inches = 0;
      feet = (feet + 1).clamp(minFt, maxFt);
    }
    _feetValue = feet;
    _inchesValue = inches;
    selectedValue = _feetValue + _inchesValue / 12.0;
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
        if (widget.useCompoundLeftUnit) {
          _initFeetAndInches(selectedValue);
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
    final bool isCompoundMode =
        widget.useCompoundLeftUnit && isLeftUnitSelected;

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
                  SizedBox(height: isCompoundMode ? 20 : 50),
                  UnitToggleWidget(
                    leftUnit: widget.leftUnit,
                    rightUnit: widget.rightUnit,
                    isLeftSelected: isLeftUnitSelected,
                    onLeftTap: () => _switchUnit(true),
                    onRightTap: () => _switchUnit(false),
                  ),
                  SizedBox(height: isCompoundMode ? 24 : 80),
                  if (isCompoundMode)
                    ..._buildCompoundFeetInches()
                  else ...[
                    MeasurementValueDisplay(
                      key: ValueKey('display_${currentUnit}_$selectedValue'),
                      value: selectedValue,
                      unit: currentUnit,
                    ),
                    RulerPicker(
                      key: ValueKey('ruler_$isLeftUnitSelected'),
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
          SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCompoundFeetInches() {
    final minFt = (widget.minLeftValue ?? widget.minValue).toDouble();
    final maxFt = (widget.maxLeftValue ?? widget.maxValue).toDouble();

    return [
      // Value display: 5'11"
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '$_feetValue',
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              letterSpacing: -2,
            ),
          ),
          const Text(
            "'",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          Text(
            '$_inchesValue',
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              letterSpacing: -2,
            ),
          ),
          const Text(
            '"',
            style: TextStyle(
              color: Color.fromRGBO(158, 160, 165, 1),
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      // Feet ruler
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Feet',
          style: TextStyle(
            fontSize: 13,
            color: Color.fromRGBO(158, 160, 165, 1),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(height: 4),
      RulerPicker(
        key: const ValueKey('feet_ruler'),
        minValue: minFt,
        maxValue: maxFt,
        step: 1,
        initialValue: _feetValue.toDouble(),
        majorTickInterval: 1,
        height: 90,
        onValueChanged: (val) {
          setState(() {
            _feetValue = val.round();
            selectedValue = _feetValue + _inchesValue / 12.0;
          });
        },
      ),
      const SizedBox(height: 12),
      // Inches ruler
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Inches',
          style: TextStyle(
            fontSize: 13,
            color: Color.fromRGBO(158, 160, 165, 1),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(height: 4),
      RulerPicker(
        key: const ValueKey('inches_ruler'),
        minValue: 0,
        maxValue: 11,
        step: 1,
        initialValue: _inchesValue.toDouble(),
        majorTickInterval: 3,
        height: 90,
        onValueChanged: (val) {
          setState(() {
            _inchesValue = val.round();
            selectedValue = _feetValue + _inchesValue / 12.0;
          });
        },
      ),
    ];
  }
}
