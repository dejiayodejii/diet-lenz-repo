// ignore_for_file: use_build_context_synchronously

import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/widgets/restart_widget.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:diet_lenz/features/auth/view/personization/select_country.dart';
import 'package:diet_lenz/features/settings/views/change_password.dart';
import 'package:diet_lenz/features/settings/views/edit_profile.dart';
import 'package:diet_lenz/features/settings/views/more.dart';
import 'package:diet_lenz/features/settings/views/referal.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:diet_lenz/core/utils/loader.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    // RestartWidget.restartApp(context);

    // Navigate to login
    if (mounted) {
      NavigationService.pushAndRemoveUntil(
        child: const LoginScreen(),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final multipartFile =
          await http.MultipartFile.fromPath('image', image.path);

      final url = await ref
          .read(userProfileViewModelProvider.notifier)
          .updateUserProfilePhoto(multipartFile);

      if (url != null) {
        ref.read(authViewModelProvider.notifier).updateProfilePhoto(url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStateObj = ref.watch(authViewModelProvider);
    final authState = authStateObj.authResponse;
    final userProfileState = ref.watch(userProfileViewModelProvider);

    final userName = "${authState?.firstName} ${authState?.lastName}";

    return BlurryModalProgressHUD(
      inAsyncCall: userProfileState.isLoading,
      child: Scaffold(
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
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: authState!.profilePhoto != null
                                  ? CachedNetworkImage(
                                      imageUrl: authState!.profilePhoto!,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height: 120,
                                        width: 120,
                                        color: AppColors.primaryColor
                                            .withOpacity(0.2),
                                        child: const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 120,
                                      width: 120,
                                      color: AppColors.primaryColor
                                          .withOpacity(0.2),
                                      child: const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                settingTile(
                    title: "Location",
                    onTap: () {
                      NavigationService.push(
                          child: CountrySelectionScreen(
                        isFromSettings: true,
                      ));
                    }),
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
      ),
    );
  }

  Widget settingTile(
      {required String title,
      Widget? icon,
      VoidCallback? onTap,
      bool useSpace = true}) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: icon == null ? 13.0 : 0),
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
