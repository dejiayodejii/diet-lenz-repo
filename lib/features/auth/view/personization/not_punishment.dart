import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/personization/notification_request.dart';
import 'package:diet_lenz/features/auth/view/personization/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotPunishment extends StatefulWidget {
  const NotPunishment({super.key});

  @override
  State<NotPunishment> createState() => _NotPunishmentState();
}

class _NotPunishmentState extends State<NotPunishment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 25),
                      const Text(
                          "Your goals shouldn't feel like a punishment. ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              letterSpacing: 0,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600)),
                      //
                    ],
                  ),
                  Image.asset(AppImages.graph, scale: 2),
                  const Text(
                      "True progress happens when your tracker fits your lifestyle. Dietlenz removes the friction from calorie  tracking to help you effortlessly reach your target weight without the mental battle.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          // letterSpacing: 0,
                          color: AppColors.white,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            const SizedBox(height: 25),
            CustomYafButton(
                iconPositionLeft: false,
                text: "Continue",
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  NavigationService.push(child: NotificationRequestScreen());
                }),
            SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
