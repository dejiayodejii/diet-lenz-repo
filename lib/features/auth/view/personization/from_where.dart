import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/personalization_stepper.dart';
import 'package:diet_lenz/component/selectable_option_tile.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/use_referral.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class FromWhereScreen extends ConsumerStatefulWidget {
  const FromWhereScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FromWhereScreenState();
}

class _FromWhereScreenState extends ConsumerState<FromWhereScreen> {
  int? selectedIndex;

  final List<String> fromWhere = const [
    "From an influencer",
    "Instagram",
    "TikTok",
    "Youtube",
    "App Store Search",
    "Friends/Family",
    "Others",
  ];

  final List<String?> fromWhereAssets = const [
    AppImages.influencer,
    AppImages.instagram,
    AppImages.tiktok,
    AppImages.youtube,
    AppImages.storeSearch,
    AppImages.friends,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const PersonalizationStepper(
          currentStep: 2,
          width: 13,
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.fromLTRB(
            16, 0, 16, 20 + MediaQuery.of(context).padding.bottom),
        child: CustomYafButton(
            fontSize: 16,
            weight: FontWeight.w600,
            iconPositionLeft: false,
            text: "Continue",
            isDisabled: selectedIndex == null,
            iconWidget: SvgPicture.asset(AppImages.arrowRight),
            onPressed: () {
              NavigationService.push(child: ReferralScreen(email: ''));
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Where did you hear about us?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    letterSpacing: 0,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 50),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 50),
                itemCount: fromWhere.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return SelectableOptionTile(
                    label: fromWhere[index],
                    imagePath: fromWhereAssets[index],
                    isSelected: selectedIndex == index,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
