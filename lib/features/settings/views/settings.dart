import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:diet_lenz/features/settings/views/change_password.dart';
import 'package:diet_lenz/features/settings/views/edit_profile.dart';
import 'package:diet_lenz/features/settings/views/more.dart';
import 'package:diet_lenz/features/settings/views/referal.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetttingsScreen extends ConsumerStatefulWidget {
  const SetttingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SetttingsScreenState();
}

class _SetttingsScreenState extends ConsumerState<SetttingsScreen> {
  Future<void> _handleLogout() async {
    final apiService = ref.read(apiServiceProvider);
    final userProfileNotifier = ref.read(userProfileViewModelProvider.notifier);

    // Clear tokens and profile
    await apiService.clearAuthToken();
    userProfileNotifier.clearProfile();

    // Navigate to login
    if (mounted) {
      NavigationService.pushAndRemoveUntil(
        child: const LoginScreen(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfileViewModelProvider);
    final userName = 
    // userProfileState.userProfile?.userId ?? 
    "Ayodeji";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Image.asset(
                      AppImages.ppic,
                      scale: 2,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userName,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              settingTile(
                title: "Profile",
                onTap: () {
                  NavigationService.push(child: EditProfileScreen());
                },
              ),
              settingTile(
                title: "Change Password",
                onTap: () {
                  NavigationService.push(child: ChangePasswordScreen());
                },
              ),
              settingTile(title: "Location"),
              settingTile(
                  title: "Notifications",
                  icon: Switch.adaptive(
                      activeColor: AppColors.primaryColor,
                      value: true,
                      onChanged: (val) {})),
              settingTile(
                  title: "Referal",
                  onTap: () {
                    NavigationService.push(child: ReferalScreen());
                  }),
              settingTile(
                  title: "More",
                  onTap: () {
                    NavigationService.push(child: MoreScreen());
                  }),
              const SizedBox(height: 20),
              CustomYafButton(
                text: "Logout",
                onPressed: _handleLogout,
              ),
              const SizedBox(height: 10),
              CustomYafButton(
                color: Colors.white,
                textColor: Colors.black,
                text: "Delete",
                onPressed: () {},
              ),
              const SizedBox(height: 5),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Reset Goals",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppFonts.lato),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingTile(
      {required String title,
      Widget? icon,
      VoidCallback? onTap,
      bool useSpace = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: icon == null ? 13.0 : 0),
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
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
      ),
    );
  }
}
