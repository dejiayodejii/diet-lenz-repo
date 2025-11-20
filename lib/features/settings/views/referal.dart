import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReferalScreen extends ConsumerStatefulWidget {
  const ReferalScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SetttingsScreenState();
}

class _SetttingsScreenState extends ConsumerState<ReferalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Referal'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 226,
              width: 0.8 * MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Invite you friends to join the train",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppFonts.spaceGrotesk),
                  ),
                  Text(
                    "NXVFG56",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        fontFamily: AppFonts.spaceGrotesk),
                  ),
                  //
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Your friends should not \nmiss out on the fun",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFonts.lato),
              ),
            ),
            const SizedBox(height: 20),
            CustomYafButton(
              borderColor: Colors.white,
              color: Color.fromRGBO(0, 0, 0, 1),
              textColor: Colors.white,
              iconPositionLeft: false,
              text: "Copy Referral Code",
              iconWidget: Icon(Icons.file_copy_outlined, color: Colors.white),
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            CustomYafButton(
              color: Colors.white,
              textColor: Color.fromRGBO(0, 0, 0, 1),
              iconPositionLeft: false,
              text: "Share Referral Code",
              iconWidget: Icon(Icons.share, color: Color.fromRGBO(0, 0, 0, 1)),
              onPressed: () {},
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget settingTile({required String title, Widget? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: AppFonts.lato),
          ),
          icon ??
              const Icon(Icons.arrow_forward_ios,
                  weight: 40, size: 25, color: AppColors.primaryColor),
        ],
      ),
    );
  }
}
