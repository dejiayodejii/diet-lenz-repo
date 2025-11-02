import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinBoxes extends StatelessWidget {
  const CustomPinBoxes({
    super.key,
    required this.isOtpCorrect,
    // required this.onChanged,
    required this.controller,
    this.enabled = true,
  });

  final bool isOtpCorrect;
  // final dynamic Function(String?)? onChanged;
  final bool enabled;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      backgroundColor: AppColors.backgroundColor,
      enabled: enabled,
      autoFocus: true,
      controller: controller,
      keyboardType: TextInputType.number,
      length: 4,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      showCursor: true,
      cursorColor: AppColors.primaryColor,
      appContext: context,
      animationDuration: const Duration(seconds: 0),
      animationType: AnimationType.none,
      pinTheme: PinTheme(
        fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 0),
        shape: PinCodeFieldShape.box,
        borderWidth: 0.64,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: 69,
        fieldWidth: 69,
        inactiveFillColor: Colors.black12,
        activeFillColor: Colors.black12,
        selectedFillColor: Colors.black12,
        inactiveColor:
            isOtpCorrect == false ? Colors.red : const Color(0xFFE5E5E7),
        activeColor:
            isOtpCorrect == false ? Colors.red : AppColors.primaryColor,
        selectedColor:
            isOtpCorrect == false ? Colors.red : AppColors.primaryColor,
      ),
      textStyle: const TextStyle(
          fontSize: 17, fontWeight: FontWeight.w400, color: AppColors.white,fontFamily: AppFonts.spaceGrotesk),
    );
  }
}
