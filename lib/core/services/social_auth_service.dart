import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Provider for the social auth service
final socialAuthServiceProvider = Provider<SocialAuthService>((ref) {
  return SocialAuthService();
});

/// Service that handles native Google & Apple sign-in flows.
///
/// Returns the provider's `idToken` which is then sent to the
/// Diet Lenz backend via [AuthViewModel.googleLogin] / [AuthViewModel.appleLogin].
class SocialAuthService {
  bool _googleInitialized = false;

  /// Initialize Google Sign-In. Must be called once before [signInWithGoogle].
  Future<void> initializeGoogle() async {
    if (_googleInitialized) return;
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '77989643764-gdtj161cjose6paf93m6jvkop7aqgo9i.apps.googleusercontent.com',
    );
    _googleInitialized = true;
  }

  // ──────────────────────────────────────────────────────────────────────
  // Google
  // ──────────────────────────────────────────────────────────────────────

  /// Triggers the native Google Sign-In flow and returns the `idToken`.
  ///
  /// Returns `null` if the user cancelled or an error occurred.
  Future<String?> signInWithGoogle() async {
    try {
      await initializeGoogle();

      // Start interactive sign-in flow (v7 API)
      final GoogleSignInAccount account =
          await GoogleSignIn.instance.authenticate();

      // The idToken is what the backend needs to verify the user
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        print('⚠️ Google Sign-In returned no idToken');
        return null;
      }

      // Debug: decode JWT payload to check audience and issuer
      try {
        final parts = idToken.split('.');
        if (parts.length == 3) {
          final payload = utf8.decode(
            base64Url.decode(base64Url.normalize(parts[1])),
          );
          final claims = json.decode(payload) as Map<String, dynamic>;
          print('🔍 Google idToken claims:');
          print('   aud: ${claims['aud']}');
          print('   iss: ${claims['iss']}');
          print('   sub: ${claims['sub']}');
          print('   email: ${claims['email']}');
          print('   exp: ${claims['exp']}');
        }
      } catch (e) {
        print('⚠️ Could not decode idToken for debugging: $e');
      }

      return idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // User cancelled — not an error
        return null;
      }
      print('❌ Google Sign-In error: ${e.code}');
      return null;
    } catch (e) {
      print('❌ Google Sign-In error: $e');
      return null;
    }
  }

  /// Sign out from Google (useful when logging out of the app).
  Future<void> signOutGoogle() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }

  // ──────────────────────────────────────────────────────────────────────
  // Apple
  // ──────────────────────────────────────────────────────────────────────

  /// Whether Apple Sign-In is available on this device (iOS 13+).
  bool get isAppleSignInAvailable => Platform.isIOS;

  /// Triggers the native Apple Sign-In flow and returns the `identityToken`.
  ///
  /// Returns `null` if the user cancelled or an error occurred.
  Future<String?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        print('⚠️ Apple Sign-In returned no identityToken');
        return null;
      }

      return identityToken;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        // User cancelled — not an error
        return null;
      }
      print('❌ Apple Sign-In authorization error: ${e.code} — ${e.message}');
      return null;
    } catch (e) {
      print('❌ Apple Sign-In error: $e');
      return null;
    }
  }
}
