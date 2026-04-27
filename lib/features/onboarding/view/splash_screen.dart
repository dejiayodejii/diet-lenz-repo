import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/core/widgets/biometric_lock_screen.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:diet_lenz/features/bottom_nav/bottom.dart';
import 'package:diet_lenz/features/onboarding/controller/splash_viewmodel.dart';
import 'package:diet_lenz/features/subscription/controller/subscription_viewmodel.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashViewModelProvider.notifier).initialize();
    });
  }

  /// Fire-and-forget: pre-fetches profile and initialises subscriptions so
  /// the home screen has fresh data immediately on arrival.
  void _prefetchUserData() {
    ref.read(userProfileViewModelProvider.notifier).getUserProfile();
    final email = ref.read(authViewModelProvider).authResponse?.email;
    if (email != null) {
      ref.read(subscriptionViewModelProvider.notifier).loginUser(email);
    }
  }

  void _navigateTo(Widget destination) {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => destination),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SplashState>(splashViewModelProvider, (_, next) {
      switch (next.status) {
        case SplashStatus.navigateToLogin:
          _navigateTo(const LoginScreen());
        case SplashStatus.navigateToHome:
          _prefetchUserData();
          _navigateTo(const BottomNavScreen());
        case SplashStatus.navigateToBiometricLock:
          _prefetchUserData();
          _navigateTo(
              BiometricLockScreen(destination: const BottomNavScreen()));
        default:
          break;
      }
    });

    final isRefreshing = ref.watch(splashViewModelProvider).status ==
        SplashStatus.refreshingToken;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SvgPicture.asset(AppImages.dietLenzLogo),
          ),
          if (isRefreshing)
            const Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text(
                    'Signing you back in…',
                    style: TextStyle(fontSize: 13, color: Colors.white54),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
