import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/diet-prefernce.dart';
import 'package:diet_lenz/main2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class DesiredWeightScreen extends ConsumerStatefulWidget {
  const DesiredWeightScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<DesiredWeightScreen> {
  bool isMale = true;
    double selectedValue = 65.0;
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
                  child: SvgPicture.asset(AppImages.backButton)),
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(
          15.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 25),
            const Text("What is your \ndesired weight?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    letterSpacing: 0,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(36, 38, 43, 1),
                        borderRadius: BorderRadius.circular(18)),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isMale = true;
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color:
                                      !isMale ? null : AppColors.primaryColor,
                                  boxShadow: !isMale
                                      ? null
                                      : [
                                          const BoxShadow(
                                            color: Color.fromRGBO(
                                                37, 99, 235, 0.25),
                                            spreadRadius: 4,
                                          )
                                        ]),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "kg",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        fontFamily: AppFonts.workSans),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isMale = false;
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: isMale ? null : AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: isMale
                                      ? null
                                      : [
                                          const BoxShadow(
                                            color: Color.fromRGBO(
                                                249, 115, 22, 0.25),
                                            spreadRadius: 4,
                                          )
                                        ]),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "lbs",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        fontFamily: AppFonts.workSans),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
      Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                     RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${selectedValue.toInt()}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 96,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const TextSpan(
                              text: 'kg',
                              style: TextStyle(
                                color: const Color.fromRGBO(158, 160, 165, 1),
                                fontSize: 36,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  RulerPicker(
                    minValue: 0,
                    maxValue: 500,
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
                iconPositionLeft: false,
                text: "Continue",
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  NavigationService.push(child: const DietPreferenceScreen());
                }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
