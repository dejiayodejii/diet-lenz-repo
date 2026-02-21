import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:diet_lenz/features/bottom_nav/bottom.dart';
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
      Future.delayed(const Duration(seconds: 3), () {
        final authState = ref.read(authViewModelProvider);
        if (authState.isAuthenticated && authState.authResponse != null) {
          NavigationService.pushAndRemoveUntil(child: const BottomNavScreen());
        } else {
          NavigationService.pushAndRemoveUntil(child: const LoginScreen());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(AppImages.dietLenzLogo),
      ),
    );
  }
}
