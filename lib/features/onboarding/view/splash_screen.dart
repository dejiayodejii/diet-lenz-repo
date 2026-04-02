import 'dart:developer';

import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/providers/biometric_providers.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/utils/token_utils.dart';
import 'package:diet_lenz/core/widgets/biometric_lock_screen.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:diet_lenz/features/bottom_nav/bottom.dart';
import 'package:diet_lenz/features/subscription/controller/subscription_viewmodel.dart';
import 'package:diet_lenz/features/subscription/view/paywall_screen.dart';
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
        _checkAuthAndNavigate();
      });
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    if (!mounted) return;
    try {
      print('🔍 _checkAuthAndNavigate: start');
      final authState = ref.read(authViewModelProvider);
      print(
          '🔍 authState fetched — isAuthenticated: ${authState.isAuthenticated}');
      final apiService = ref.read(apiServiceProvider);
      print('🔍 apiService fetched');

      if (!mounted) return;

      Widget destination;

      if (!authState.isAuthenticated || authState.authResponse == null) {
        print('🔍 Not authenticated, navigating to LoginScreen');
        destination = const LoginScreen();
      } else {
        final token = apiService.getAuthToken();
        print(
            '🔍 token: ${token != null ? '(present, length=${token.length})' : 'null'}');

        if (token == null ||
            token.isEmpty ||
            TokenUtils.isTokenExpired(token)) {
          print('🔍 Token missing/expired, navigating to LoginScreen');
          destination = const LoginScreen();
        } else {
          // Check if user has a saved profile in local storage
          final savedProfile = apiService.getSavedUserProfile();
          if (savedProfile == null || savedProfile.isEmpty) {
            // Token exists but no profile — user signed in via social login
            // but never completed profile setup. Send to login.
            print(
                '🔍 Token valid but no saved profile, navigating to LoginScreen');
            destination = const LoginScreen();
          } else {
            //login user to revenuecat and check entitlement
            await ref
                .read(subscriptionViewModelProvider.notifier)
                .loginUser(authState.authResponse!.email!);
            print(
                '🔍 Token valid + profile exists, checking subscription status');
            final isPremium = await ref
                .read(subscriptionViewModelProvider.notifier)
                .checkPremiumStatus();
            if (isPremium) {
              log('🔍 User is premium, navigating to BottomNavScreen');
              destination = const BottomNavScreen();
            } else {
              log('🔍 User is not premium, navigating to PaywallScreen');
              destination = const PaywallScreen(mandatory: true);
            }
          }
        }
      }

      // If biometric is enabled, wrap destination behind the lock screen
      final biometricEnabled = ref.read(biometricEnabledNotifierProvider);
      if (biometricEnabled && destination is! LoginScreen) {
        destination = BiometricLockScreen(destination: destination);
      }

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => destination),
        (_) => false,
      );
    } catch (e, s) {
      print('❌ _checkAuthAndNavigate error: $e');
      print('❌ Stack trace: $s');
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building SplashScreen');
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(AppImages.dietLenzLogo),
      ),
    );
  }
}
