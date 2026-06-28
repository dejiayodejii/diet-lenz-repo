import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/widgets/biometric_lock_screen.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:diet_lenz/features/auth/view/personization/from_where.dart';
import 'package:diet_lenz/features/auth/view/personization/plan_setup.dart';
import 'package:diet_lenz/features/auth/view/register.dart';
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
  bool _showWelcomeScreen = false;

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

  void _pushAuthScreen(Widget destination) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SplashState>(splashViewModelProvider, (_, next) {
      switch (next.status) {
        case SplashStatus.navigateToLogin:
          if (mounted) {
            setState(() => _showWelcomeScreen = true);
          }
          return;
        case SplashStatus.navigateToHome:
          _prefetchUserData();
          _navigateTo(const BottomNavScreen());
          return;
        case SplashStatus.navigateToBiometricLock:
          _prefetchUserData();
          _navigateTo(
              const BiometricLockScreen(destination: BottomNavScreen()));
          return;
        default:
          break;
      }
    });

    final isRefreshing = ref.watch(splashViewModelProvider).status ==
        SplashStatus.refreshingToken;

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 420),
        child: _showWelcomeScreen
            ? _WelcomeSplashScreen(
                onGetStarted: () => _pushAuthScreen(const FromWhereScreen()),
                onLogin: () => _pushAuthScreen(const LoginScreen()),
              )
            : _LogoSplashScreen(isRefreshing: isRefreshing),
      ),
    );
  }
}

class _SplashBackground extends StatelessWidget {
  const _SplashBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF101010),
            Color(0xFF121110),
            Color(0xFF3A1C0F),
          ],
          stops: [0, 0.48, 1],
        ),
      ),
      child: child,
    );
  }
}

class _LogoSplashScreen extends StatelessWidget {
  const _LogoSplashScreen({required this.isRefreshing});

  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return _SplashBackground(
      child: Stack(
        key: const ValueKey('logo-splash'),
        children: [
          Center(
            child: SvgPicture.asset(
              AppImages.dietLenzLogo,
              // width: screenWidth.clamp(190, 250).toDouble(),
            ),
          ),
          if (isRefreshing)
            const Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Signing you back in...',
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

class _WelcomeSplashScreen extends StatelessWidget {
  const _WelcomeSplashScreen({
    required this.onGetStarted,
    required this.onLogin,
  });

  final VoidCallback onGetStarted;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final logoWidth = screenWidth.clamp(220, 280).toDouble();

    return _SplashBackground(
      child: SafeArea(
        key: const ValueKey('welcome-splash'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42),
          child: Column(
            children: [
              const Spacer(flex: 5),
              SvgPicture.asset(
                AppImages.dietLenzLogo,
                // width: logoWidth,
              ),
              const SizedBox(height: 34),
              const Text(
                'Calorie tracking through your lens.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontFamily: AppFonts.workSans,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
              const Spacer(flex: 6),
              CustomYafButton(
                text: "Get started",
                onPressed: onGetStarted,
              ),
              const SizedBox(height: 28),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      letterSpacing: 0,
                    ),
                  ),
                  GestureDetector(
                    onTap: onLogin,
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
