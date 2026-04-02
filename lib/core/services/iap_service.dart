// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

/// Provider for the IAP service
final iapServiceProvider = Provider<IAPService>((ref) {
  return IAPService();
});

/// RevenueCat In-App Purchase service.
///
/// Handles the full subscription lifecycle:
/// 1. Configure RevenueCat SDK
/// 2. Fetch available offerings (products)
/// 3. Purchase subscriptions via native paywall or programmatic API
/// 4. Check entitlement status
/// 5. Restore purchases
/// 6. Present Customer Center for subscription management
class IAPService {
  bool _isConfigured = false;

  /// Whether RevenueCat has been configured
  bool get isConfigured => _isConfigured;

  // ──────────────────────────────────────────────────────────────────────────
  // RevenueCat API Key
  // ──────────────────────────────────────────────────────────────────────────
  static const String _appleApiKey = 'appl_CHxerGtrvqAYCLTBTiInqsCIoGt';

   static const String _googleApiKey = 'goog_vgwWbhHXpWYiIJzbiMctwTHQmqB';

  // /// The entitlement ID configured in the RevenueCat dashboard.
  static const String entitlementId = 'pro';

  /// Package identifiers matching your RevenueCat products
  // static const String monthlyPackageId = 'monthly';
  // static const String yearlyPackageId = 'yearly';

  // ──────────────────────────────────────────────────────────────────────────
  // Configuration
  // ──────────────────────────────────────────────────────────────────────────

  /// Initialize RevenueCat. Call once at app startup.
  ///
  /// [appUserId] should be your backend user ID so RevenueCat can
  /// associate store purchases with the correct account.
  Future<void> configure({String? appUserId}) async {
    if (_isConfigured) return;

    await Purchases.setLogLevel(LogLevel.debug);

    final configuration = PurchasesConfiguration(
        Platform.isIOS ? _appleApiKey : _googleApiKey);
    if (appUserId != null && appUserId.isNotEmpty) {
      configuration.appUserID = appUserId;
    }

    await Purchases.configure(configuration);
    _isConfigured = true;

    print('✅ RevenueCat configured (${Platform.isIOS ? 'Apple' : 'Google'})');
  }

  // ──────────────────────────────────────────────────────────────────────────
  // User identity
  // ──────────────────────────────────────────────────────────────────────────

  /// Log in a specific user after your app's authentication succeeds.
  /// This merges any anonymous purchases with the identified user.
  Future<CustomerInfo> login(String appUserId) async {
    final result = await Purchases.logIn(appUserId);
    print('✅ RevenueCat user logged in: $appUserId');
    return result.customerInfo;
  }

  /// Log out (creates a new anonymous user).
  Future<CustomerInfo> logout() async {
    final info = await Purchases.logOut();
    print('✅ RevenueCat user logged out');
    return info;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Offerings & Products
  // ──────────────────────────────────────────────────────────────────────────

  /// Fetch the current offerings from RevenueCat.
  Future<Offerings?> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        print('⚠️ No current offering configured in RevenueCat dashboard');
      }
      return offerings;
    } catch (e) {
      print('❌ Error fetching offerings: $e');
      return null;
    }
  }

  /// Get the monthly package from the current offering, if available.
  Future<Package?> getMonthlyPackage() async {
    final offerings = await getOfferings();
    return offerings?.current?.monthly;
  }

  /// Get the annual package from the current offering, if available.
  Future<Package?> getAnnualPackage() async {
    final offerings = await getOfferings();
    return offerings?.current?.annual;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Purchases
  // ──────────────────────────────────────────────────────────────────────────

  /// Purchase a subscription package programmatically.
  ///
  /// Returns [CustomerInfo] after a successful purchase, or `null` if the
  /// user cancelled or an error occurred.
  Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      print('✅ Purchase successful: ${package.identifier}');
      return customerInfo;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        print('🚫 Purchase cancelled by user');
      } else {
        print('❌ Purchase error: $errorCode — ${e.message}');
      }
      return null;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Entitlements
  // ──────────────────────────────────────────────────────────────────────────

  /// Check if the user currently has the "Diet Lenz Pro" entitlement.
  Future<bool> isPremium() async {
    try {
      final info = await Purchases.getCustomerInfo();
      log('🔍 Customer info fetched: $info');
      return info.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (e) {
      print('❌ Error checking entitlement: $e');
      return false;
    }
  }

  /// Get the full customer info (entitlements, active subscriptions, etc.)
  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      print('❌ Error getting customer info: $e');
      return null;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Restore
  // ──────────────────────────────────────────────────────────────────────────

  /// Restore purchases — useful after reinstall or on a new device.
  Future<CustomerInfo?> restorePurchases() async {
    try {
      final info = await Purchases.restorePurchases();
      print('✅ Purchases restored');
      return info;
    } catch (e) {
      print('❌ Error restoring purchases: $e');
      return null;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // RevenueCat Paywall (purchases_ui_flutter)
  // ──────────────────────────────────────────────────────────────────────────

  /// Present the RevenueCat-hosted paywall as a full-screen modal.
  ///
  /// Returns the [PaywallResult] indicating what happened (purchased,
  /// cancelled, restored, or error).
  ///
  /// Pre-checks that offerings exist to avoid RevenueCat Error 23
  /// (configuration error) dialog.
  Future<PaywallResult> presentPaywall() async {
    // Pre-check: ensure offerings are available before presenting
    final offerings = await getOfferings();
    if (offerings == null || offerings.current == null) {
      throw PlatformException(
        code: 'NO_OFFERINGS',
        message: 'No subscription offerings are currently available. '
            'Please check your RevenueCat dashboard configuration:\n'
            '1. Ensure products are created in App Store Connect / Google Play Console\n'
            '2. Ensure an Offering is configured in the RevenueCat dashboard\n'
            '3. Ensure a Paywall is attached to the current Offering\n'
            '4. Verify the API key matches your platform (appl_ for iOS, goog_ for Android)',
      );
    }
    return await RevenueCatUI.presentPaywall(
      offering: offerings.current!,
      displayCloseButton: true,
    );
  }

  /// Present the paywall only if the user does not have the entitlement.
  Future<PaywallResult> presentPaywallIfNeeded() async {
    final offerings = await getOfferings();
    if (offerings == null || offerings.current == null) {
      throw PlatformException(
        code: 'NO_OFFERINGS',
        message: 'No subscription offerings are currently available. '
            'Please check your RevenueCat dashboard configuration.',
      );
    }
    return await RevenueCatUI.presentPaywallIfNeeded(
      entitlementId,
      offering: offerings.current!,
      displayCloseButton: true,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Customer Center (purchases_ui_flutter)
  // ──────────────────────────────────────────────────────────────────────────

  /// Present the RevenueCat Customer Center — allows the user to manage
  /// their subscription (cancel, change plan, request refund) without you
  /// building a custom management UI.
  Future<void> presentCustomerCenter() async {
    await RevenueCatUI.presentCustomerCenter();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Listener
  // ──────────────────────────────────────────────────────────────────────────

  /// Stream of customer info changes (subscription renewals, expirations, etc.)
  Stream<CustomerInfo> get customerInfoStream {
    final controller = StreamController<CustomerInfo>.broadcast();
    Purchases.addCustomerInfoUpdateListener((info) {
      controller.add(info);
    });
    return controller.stream;
  }
}
