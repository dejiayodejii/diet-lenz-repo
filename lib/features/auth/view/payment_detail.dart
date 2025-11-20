import 'package:diet_lenz/component/blurred_dialog.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class PaymentDetailScreen extends ConsumerStatefulWidget {
  const PaymentDetailScreen(
      {super.key, required this.price, required this.type});
  final String type;
  final String price;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<PaymentDetailScreen> {
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
              SizedBox(width: 15),
              Text("${widget.type} Plan")
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(
          15.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Image.asset(
                  AppImages.payment,
                  scale: 2,
                ),
              ),
            ),
            CustomYafButton(
                fontSize: 18,
                weight: FontWeight.w600,
                text: "Continue with ${widget.price}",
                onPressed: () {
                  _showResetSuccessDialog(context);
                  // NavigationService.push(child: const SelectPaymentScreen());
                }),
            const SizedBox(height: 40),
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

  void _showResetSuccessDialog(BuildContext context) {
    BlurredDialog.show(
      context: context,
      title: "Congratulation!",
      subtitle:
          "Congrats on upgrading to the Monthly Premium plan! Enjoy your new perks!",
      buttonText: "Exploring Premium Plan",
      onButtonPressed: () {
        // Navigator.of(context).pop();
        NavigationService.push(child: const LoginScreen()); // Close dialog
        // Navigator.of(context).pop(); // Go back to login screen
        // Navigator.of(context).pop();
      },
    );
  }
}
