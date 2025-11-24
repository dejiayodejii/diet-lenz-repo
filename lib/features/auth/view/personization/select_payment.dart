import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/personization/payment_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SelectPaymentScreen extends ConsumerStatefulWidget {
  const SelectPaymentScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<SelectPaymentScreen> {
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
            const SizedBox(height: 40),
            const Text("Get Premium",
                style: TextStyle(
                    fontSize: 28,
                    letterSpacing: 0,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600)),
            const Text(
                "Unlock all the power of this mobile tool and enjoy digital experience like never before!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 0,
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    fontWeight: FontWeight.w400)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  GestureDetector(
                    onTap: () {
                       NavigationService.push(child: const PaymentDetailScreen( type: "Monthly",
                        price: "\$4.99",));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      height: 133,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Monthly Plan",
                                style: TextStyle(
                                    fontFamily: AppFonts.lato,
                                    fontSize: 20,
                                    letterSpacing: 0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "\$4.99",
                                      style: TextStyle(
                                        fontFamily: AppFonts.lato,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 34,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '/Month',
                                      style: TextStyle(
                                          fontFamily: AppFonts.lato,
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      NavigationService.push(child: const PaymentDetailScreen(
                        type: "Yearly",
                        price: "\$29.99",
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      height: 133,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Annual Plan",
                                style: TextStyle(
                                    fontFamily: AppFonts.lato,
                                    fontSize: 20,
                                    letterSpacing: 0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "\$29.99",
                                      style: TextStyle(
                                        fontFamily: AppFonts.lato,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 34,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '/Month',
                                      style: TextStyle(
                                          fontFamily: AppFonts.lato,
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "By placing this order, you agree to the ",
                    style: TextStyle(
                      fontFamily: AppFonts.lato,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      fontFamily: AppFonts.lato,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text: " and ",
                    style: TextStyle(
                      fontFamily: AppFonts.lato,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      fontFamily: AppFonts.lato,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text:
                        " .Subscription automatically renews unless auto-renew is \nturned off at least 24-hours before the end of the current period. ",
                    style: TextStyle(
                      fontFamily: AppFonts.lato,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
