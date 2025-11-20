import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/select_weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class GenderScreen extends ConsumerStatefulWidget {
  const GenderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<GenderScreen> {
  bool isMale = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 80),
              const Text("What is your gender?",
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMale = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: !isMale
                                ? null
                                : Border.all(color: AppColors.primaryColor),
                            borderRadius: BorderRadius.circular(32),
                            color: const Color.fromRGBO(36, 38, 43, 1),
                            boxShadow: !isMale
                                ? null
                                : [
                                    const BoxShadow(
                                      color: Color.fromRGBO(249, 115, 22, 0.25),
                                      spreadRadius: 4,
                                    )
                                  ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppImages.male),
                                const SizedBox(width: 10),
                                const Text(
                                  "Male",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: AppFonts.workSans),
                                ),
                              ],
                            ),
                            SvgPicture.asset(isMale
                                ? AppImages.selected
                                : AppImages.unselected)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMale = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: isMale
                                ? null
                                : Border.all(color: AppColors.primaryColor),
                            borderRadius: BorderRadius.circular(32),
                            color: const Color.fromRGBO(36, 38, 43, 1),
                            boxShadow: isMale
                                ? null
                                : [
                                    const BoxShadow(
                                      color: Color.fromRGBO(249, 115, 22, 0.25),
                                      spreadRadius: 4,
                                    )
                                  ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppImages.male),
                                const SizedBox(width: 10),
                                const Text(
                                  "Female",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: AppFonts.workSans),
                                ),
                              ],
                            ),
                            SvgPicture.asset(!isMale
                                ? AppImages.selected
                                : AppImages.unselected)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        NavigationService.push(
                            child: const SelectWeightScreen());
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(67, 20, 7, 1),
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Prefer to skip, thanks!",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppFonts.workSans,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600)),
                            Icon(
                              Icons.close,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    )
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
                    NavigationService.push(child: const SelectWeightScreen());
                  }),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
