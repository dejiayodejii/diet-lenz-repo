// ignore_for_file: use_build_context_synchronously

import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/providers/biometric_providers.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Shown when the app opens, the token is valid, and biometric is enabled.
/// [destination] is the screen to push to on successful authentication.
class BiometricLockScreen extends ConsumerStatefulWidget {
  final Widget destination;
  const BiometricLockScreen({super.key, required this.destination});

  @override
  ConsumerState<BiometricLockScreen> createState() =>
      _BiometricLockScreenState();
}

class _BiometricLockScreenState extends ConsumerState<BiometricLockScreen> {
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    setState(() => _isAuthenticating = true);

    final biometricService = ref.read(biometricServiceProvider);
    final success = await biometricService.authenticate(
      reason: 'Verify your identity to open Diet Lenz',
    );

    if (!mounted) return;
    setState(() => _isAuthenticating = false);

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => widget.destination),
        (_) => false,
      );
    }
    // If failed, stay on lock screen — user can retry via the button
  }

  void _logout() {
    NavigationService.pushAndRemoveUntil(child: const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(AppImages.dietLenzLogo),
              const SizedBox(height: 48),
              const Icon(
                Icons.fingerprint,
                size: 80,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 24),
              const Text(
                'Biometric Required',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Authenticate to continue to Diet Lenz.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textLightGrey,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.fingerprint),
                  label: Text(
                    _isAuthenticating ? 'Verifying…' : 'Try Again',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  onPressed: _isAuthenticating ? null : _authenticate,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _logout,
                child: const Text(
                  'Login with password instead',
                  style: TextStyle(color: AppColors.textLightGrey),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
