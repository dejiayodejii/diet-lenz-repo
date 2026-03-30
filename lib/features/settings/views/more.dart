import 'dart:io';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SetttingsScreenState();
}

class _SetttingsScreenState extends ConsumerState<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('More'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(35, 34, 32, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  settingTile(
                    title: "Terms and Conditions",
                    onTap: () => _openUrl('https://dietlenz.com/terms'),
                  ),
                  settingTile(
                    title: "Privacy Policy",
                    onTap: () => _openUrl('https://dietlenz.com/privacy'),
                  ),
                  settingTile(title: "Help"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(35, 34, 32, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Platform.isIOS
                            ? Icons.favorite
                            : Icons.health_and_safety,
                        color: Platform.isIOS ? Colors.red : Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        Platform.isIOS
                            ? 'Apple Health Integration'
                            : 'Health Connect Integration',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.spaceGrotesk,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    Platform.isIOS
                        ? 'Diet Lenz uses Apple HealthKit to read your steps, active calories burned, and heart rate data. This data is displayed on the Progress screen and is never shared with third parties.'
                        : 'Diet Lenz uses Health Connect to read your steps, active calories burned, and heart rate data. This data is displayed on the Progress screen and is never shared with third parties.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromRGBO(158, 160, 165, 1),
                      fontFamily: AppFonts.spaceGrotesk,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget settingTile(
      {required String title, Widget? icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppFonts.spaceGrotesk),
            ),
            icon ??
                const Icon(Icons.arrow_forward_ios,
                    weight: 40, size: 20, color: AppColors.white),
          ],
        ),
      ),
    );
  }
}
