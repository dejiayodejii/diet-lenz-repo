import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/providers/biometric_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows a bottom-sheet dialog prompting the user to enable biometric login
/// after a successful email/password login.
///
/// Call this with [showBiometricSetupDialog] right before navigating away
/// after login.
Future<void> showBiometricSetupDialog(
    BuildContext context, WidgetRef ref) async {
  final biometricService = ref.read(biometricServiceProvider);
  final isAvailable = await biometricService.isAvailable();

  if (!isAvailable || !context.mounted) return;

  // Only prompt if not already enabled
  final isEnabled = ref.read(biometricEnabledNotifierProvider);
  if (isEnabled) return;

  await showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: AppColors.surfaceColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _BiometricSetupSheet(ref: ref),
  );
}

class _BiometricSetupSheet extends StatelessWidget {
  final WidgetRef ref;
  const _BiometricSetupSheet({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Icon(Icons.fingerprint,
              size: 60, color: AppColors.primaryColor),
          const SizedBox(height: 16),
          const Text(
            'Enable Biometric Login',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Use Face ID, Touch ID, or your fingerprint to log in quickly next time.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLightGrey,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final biometricService = ref.read(biometricServiceProvider);
                final authenticated = await biometricService.authenticate(
                  reason: 'Confirm your identity to enable biometric login',
                );
                if (authenticated) {
                  await ref
                      .read(biometricEnabledNotifierProvider.notifier)
                      .setEnabled(true);
                }
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text(
                'Enable',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Not Now',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textLightGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
