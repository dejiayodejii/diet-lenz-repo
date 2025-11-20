import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/component/blurred_dialog.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  void _showResetSuccessDialog(BuildContext context) {
    BlurredDialog.show(
      context: context,
      title: "Password changed",
      subtitle: "Congratulations! \nYour password has been updated!",
      buttonText: "Go back",
      onButtonPressed: () {
        Navigator.of(context).pop(); // Close dialog
        Navigator.of(context).pop(); // Go back to login screen
      },
    );
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
                  child: SvgPicture.asset(AppImages.backButton)),
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //
                  const SizedBox(height: 40),
                  const Text(
                    "Change Password",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                  // const Text(
                  //   "Enter a new password to regain access \nto your account.",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //       fontSize: 17,
                  //       fontWeight: FontWeight.w400,
                  //       fontFamily: AppFonts.spaceGrotesk),
                  // ),
                  const SizedBox(height: 80),
                  LabelTextFormField(
                    radius: 12,
                    hintText: "Enter New Password",
                    suffixIcon: SizedBox(
                        height: 12,
                        width: 12,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            AppImages.eyeShow,
                            fit: BoxFit.contain,
                          ),
                        )),
                  ),
                  const SizedBox(height: 20),
                  LabelTextFormField(
                    radius: 12,
                    hintText: "Enter Confirm Password",
                    suffixIcon: SizedBox(
                        height: 12,
                        width: 12,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            AppImages.eyeShow,
                            fit: BoxFit.contain,
                          ),
                        )),
                  )
                ],
              ),
            ),
            CustomYafButton(
              text: "Reset Password",
              onPressed: () {
                _showResetSuccessDialog(context);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
