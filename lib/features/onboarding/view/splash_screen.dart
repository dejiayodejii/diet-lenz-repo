import 'dart:developer';

import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/providers/biometric_providers.dart';
import 'package:diet_lenz/core/utils/token_utils.dart';
import 'package:diet_lenz/core/widgets/biometric_lock_screen.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:diet_lenz/features/bottom_nav/bottom.dart';
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
  bool _isRefreshing = false;

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
      final authState = ref.read(authViewModelProvider);

      final apiService = ref.read(apiServiceProvider);

      if (!mounted) return;

      Widget destination = const LoginScreen();

      if (!authState.isAuthenticated || authState.authResponse == null) {
        print('🔍 Not authenticated, navigating to LoginScreen');
        destination = const LoginScreen();
      } else {
        bool tokenOk = false;
        final token = apiService.getAuthToken();
        final refreshToken = apiService.getRefreshToken();

        if (
            // false
            token != null &&
                token.isNotEmpty &&
                !TokenUtils.isTokenExpired(token)
                ) {
          // Access token still valid
          tokenOk = true;
        } else {
          // Access token missing/expired — try refresh
          print('🔍 Access token missing/expired — checking refresh token...');

          final refreshValid = refreshToken != null &&
              refreshToken.isNotEmpty &&
              !TokenUtils.isTokenExpired(refreshToken, isRefreshToken: true);

          if (refreshValid) {
            print('🔍 Refresh token valid — attempting token refresh...');
            // Clear stale access token before refreshing
            await apiService.setAuthToken('');
            if (mounted) setState(() => _isRefreshing = true);
            final refreshed = await apiService
                .refreshAccessToken()
                .timeout(const Duration(seconds: 10), onTimeout: () => false);
            if (mounted) setState(() => _isRefreshing = false);
            if (refreshed) {
              print('🔍 Token refreshed successfully');
              tokenOk = true;
            } else {
              print('🔍 Token refresh failed, navigating to LoginScreen');
            }
          } else {
            print(
                '🔍 Refresh token missing/expired, navigating to LoginScreen');
          }
        }

        if (tokenOk) {
          final savedProfile = apiService.getSavedUserProfile();
          if (savedProfile == null || savedProfile.isEmpty) {
            print(
                '🔍 Token valid but no saved profile, navigating to LoginScreen');
            destination = const LoginScreen();
          } else {
            log('🔍 Token valid + profile exists, navigating to BottomNavScreen');
            fetchProfile(); // Fire-and-forget profile fetch to update any stale info
             ref
                  .read(subscriptionViewModelProvider.notifier)
                  .loginUser(authState.authResponse!.email!);
            destination = const BottomNavScreen();
          }
        }
      }

      // If biometric is enabled, wrap destination behind the lock screen
      final biometricEnabled = ref.read(biometricEnabledNotifierProvider);
      if (biometricEnabled && destination is! LoginScreen) {
        fetchProfile(); // Fire-and-forget profile fetch to update any stale info
        ref
                  .read(subscriptionViewModelProvider.notifier)
                  .loginUser(authState.authResponse!.email!);
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

  fetchProfile() async {
    await ref.read(userProfileViewModelProvider.notifier).getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    print('Building SplashScreen');
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SvgPicture.asset(AppImages.dietLenzLogo),
          ),
          if (_isRefreshing)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Column(
                children: const [
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
