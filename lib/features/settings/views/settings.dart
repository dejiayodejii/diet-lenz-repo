// ignore_for_file: use_build_context_synchronously

import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/providers/biometric_providers.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/iap_service.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:diet_lenz/features/auth/view/personization/select_country.dart';
import 'package:diet_lenz/features/database/controller/database_history_provider.dart';
import 'package:diet_lenz/features/settings/views/change_password.dart';
import 'package:diet_lenz/features/settings/views/edit_profile.dart';
import 'package:diet_lenz/features/settings/views/more.dart';
import 'package:diet_lenz/features/settings/views/referal.dart';
import 'package:diet_lenz/features/subscription/controller/subscription_viewmodel.dart';
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
  Future<void> _handleDeleteAccount() async {
    final passwordController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Account',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This action is permanent and cannot be undone. Enter your password to confirm.',
              style: TextStyle(color: AppColors.textLightGrey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                hintStyle: const TextStyle(color: AppColors.textLightGrey),
                filled: true,
                fillColor: AppColors.surfaceGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final password = passwordController.text.trim();
    if (password.isEmpty) return;

    final success = await ref
        .read(userProfileViewModelProvider.notifier)
        .deleteAccount(password: password);

    if (success && mounted) {
      final apiService = ref.read(apiServiceProvider);
      await apiService.clearAuthToken();
      await ref.read(databaseLoggedHistoryProvider.notifier).clearHistory();
      ref.read(userProfileViewModelProvider.notifier).clearProfile();
      NavigationService.pushAndRemoveUntil(child: const LoginScreen());
    } else if (mounted) {
      final errorMsg = ref.read(userProfileViewModelProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg ??
              'Failed to delete account. Please check your password and try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleBiometricToggle(bool enable) async {
    final biometricService = ref.read(biometricServiceProvider);
    final isAvailable = await biometricService.isAvailable();

    if (!isAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Biometric authentication is not available on this device.'),
          ),
        );
      }
      return;
    }

    if (enable) {
      // Require biometric confirmation before enabling
      final authenticated = await biometricService.authenticate(
        reason: 'Confirm your identity to enable biometric login',
      );
      if (!authenticated) return;
    }

    await ref
        .read(biometricEnabledNotifierProvider.notifier)
        .setEnabled(enable);
  }

  Future<void> _handleLogout() async {
    final apiService = ref.read(apiServiceProvider);
    final userProfileNotifier = ref.read(userProfileViewModelProvider.notifier);

    // Clear tokens and profile
    await apiService.clearAuthToken();
    await ref.read(databaseLoggedHistoryProvider.notifier).clearHistory();
    userProfileNotifier.clearProfile();

    // Log out from RevenueCat
    try {
      final iapService = ref.read(iapServiceProvider);
      if (iapService.isConfigured) {
        await iapService.logout();
      }
    } catch (_) {}

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
                                      imageUrl: authState.profilePhoto!,
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
                                            .withValues(alpha: 0.2),
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
                                          .withValues(alpha: 0.2),
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
                    NavigationService.push(child: const EditProfileScreen());
                  },
                ),
                settingTile(
                  title: "Change Password",
                  onTap: () {
                    NavigationService.push(child: const ChangePasswordScreen());
                  },
                ),
                settingTile(
                    title: "Biometric Login",
                    icon: Consumer(
                      builder: (context, ref, _) {
                        final biometricEnabled =
                            ref.watch(biometricEnabledNotifierProvider);
                        return Switch.adaptive(
                          activeThumbColor: AppColors.primaryColor,
                          value: biometricEnabled,
                          onChanged: (val) => _handleBiometricToggle(val),
                        );
                      },
                    )),
                settingTile(
                    title: "Location",
                    onTap: () {
                      NavigationService.push(
                          child: const CountrySelectionScreen(
                        isFromSettings: true,
                      ));
                    }),
                // settingTile(
                //     title: "Notifications",
                //     icon: Switch.adaptive(
                //         activeColor: AppColors.primaryColor,
                //         value: true,
                //         onChanged: (val) {})),
                // settingTile(
                //     title: "Subscription",
                //     onTap: () {
                //       final vm =
                //           ref.read(subscriptionViewModelProvider.notifier);
                //       vm.presentPaywallIfNeeded();
                //     }),
                settingTile(
                    title: "Manage Subscription",
                    onTap: () {
                      final vm =
                          ref.read(subscriptionViewModelProvider.notifier);
                      vm.presentCustomerCenter();
                    }),
                settingTile(
                    title: "Referal",
                    onTap: () {
                      NavigationService.push(child: const ReferalScreen());
                    }),
                settingTile(
                    title: "More",
                    onTap: () {
                      NavigationService.push(child: const MoreScreen());
                    }),
                const SizedBox(height: 20),
                CustomYafButton(
                  text: "Logout",
                  onPressed: _handleLogout,
                ),
                const SizedBox(height: 10),
                CustomYafButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  text: "Delete Account",
                  onPressed: _handleDeleteAccount,
                ),
                // const SizedBox(height: 5),
                // const Align(
                //   alignment: Alignment.center,
                //   child: Text(
                //     "Reset Goals",
                //     style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w700,
                //         fontFamily: AppFonts.lato),
                //   ),
                // ),
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
