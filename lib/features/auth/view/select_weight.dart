import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/forgot_password.dart';
import 'package:diet_lenz/features/auth/view/select_height.dart';
import 'package:diet_lenz/features/auth/view/verify_otp.dart';
import 'package:diet_lenz/features/auth/view/widgets/social_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SelectWeightScreen extends ConsumerStatefulWidget {
  const SelectWeightScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<SelectWeightScreen> {
  bool isMale = true;
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
            const SizedBox(height: 50),
            const Text("What is your weight?",
                style: TextStyle(
                    fontSize: 28,
                    letterSpacing: 0,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
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
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "128",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 96,
                            letterSpacing: -2,
                            fontFamily: AppFonts.workSans),
                      ),
                      Text(
                        "kg",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 36,
                            color: Color.fromRGBO(158, 160, 165, 1),
                            letterSpacing: -2,
                            fontFamily: AppFonts.workSans),
                      ),
                    ],
                  ),
                  Image.asset(
                    AppImages.ruler,
                    scale: 2,
                  )
                ],
              ),
            ),
            CustomYafButton(
                iconPositionLeft: false,
                text: "Continue",
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  NavigationService.push(child: const SelectHeightScreen());
                }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
