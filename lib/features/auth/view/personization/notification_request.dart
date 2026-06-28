import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/personalization_stepper.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/push_notification_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class NotificationRequestScreen extends ConsumerStatefulWidget {
  const NotificationRequestScreen({super.key});

  @override
  ConsumerState<NotificationRequestScreen> createState() =>
      _NotificationRequestScreenState();
}

class _NotificationRequestScreenState
    extends ConsumerState<NotificationRequestScreen> {
  bool _isRequestingPermission = false;

  void _continue({required bool notificationsEnabled}) {
    ref.read(onboardingProfileProvider.notifier).updateNotifications(
          notificationsEnabled: notificationsEnabled,
          mealRemindersEnabled: notificationsEnabled,
        );
    NavigationService.push(child: const SignUpScreen());
  }

  Future<void> _enableNotifications() async {
    if (_isRequestingPermission) return;

    setState(() => _isRequestingPermission = true);
    try {
      await ref.read(pushNotificationServiceProvider).requestPermission();
      if (!mounted) return;
      _continue(notificationsEnabled: true);
    } catch (_) {
      if (!mounted) return;
      _continue(notificationsEnabled: false);
    } finally {
      if (mounted) {
        setState(() => _isRequestingPermission = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const PersonalizationStepper(
          currentStep: 9,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 46, bottom: 30),
                child: Column(
                  children: [
                    Text(
                      'Stay on track',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        // fontFamily: AppFonts.lato,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Smart reminders keep you consistent',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        // fontFamily: AppFonts.lato,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(height: 96),
                    _NotificationPreviewCard(),
                    SizedBox(height: 78),
                    _ReminderInfoCard(
                      title: 'Meal Reminders',
                      subtitle: 'Get nudged before each meal window',
                    ),
                    SizedBox(height: 26),
                    _ReminderInfoCard(
                      title: 'Daily Progress',
                      subtitle: 'See your kcal balance at a glance',
                    ),
                  ],
                ),
              ),
            ),
            CustomYafButton(
              text: "Enable Notifications",
              isLoading: _isRequestingPermission,
              onPressed: _enableNotifications,
            ),
            // const SizedBox(height: 28),
            TextButton(
              onPressed: () => _continue(notificationsEnabled: false),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.white,
                textStyle: const TextStyle(
                  fontFamily: AppFonts.lato,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
              child: const Text('Not Now'),
            ),
            SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

class _NotificationPreviewCard extends StatelessWidget {
  const _NotificationPreviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(34, 22, 34, 22),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color.fromRGBO(60, 60, 60, 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppImages.dietLenzLogo,
            width: 78,
          ),
          const SizedBox(height: 24),
          const Text(
            'Lunch time! You’re 620 kcal in. 1,066 kcal\nleft for your Vacation goal',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontFamily: AppFonts.lato,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.35,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Expanded(
                child: _PreviewActionButton(
                  label: 'Log Lunch',
                  filled: false,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 28),
              Expanded(
                child: _PreviewActionButton(
                  label: 'Dismiss',
                  filled: true,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewActionButton extends StatelessWidget {
  const _PreviewActionButton({
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  final String label;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? AppColors.primaryColor : Colors.transparent,
          foregroundColor: filled ? AppColors.white : AppColors.primaryColor,
          side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: AppFonts.lato,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class _ReminderInfoCard extends StatelessWidget {
  const _ReminderInfoCard({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(19, 14, 14, 1),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.textLightGrey, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.white,
              // fontFamily: AppFonts.lato,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
