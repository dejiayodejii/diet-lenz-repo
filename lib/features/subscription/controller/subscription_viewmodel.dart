import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:diet_lenz/core/services/iap_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

/// Extension to extract error message from ApiException
extension _ApiExceptionMessage on ApiException {
  String? get extractMessage {
    final message = this.message;
    if (message != null && message.contains('{')) {
      try {
        final jsonData = json.decode(message);
        return jsonData['message'] as String?;
      } catch (_) {
        return message;
      }
    }
    return message;
  }
}

/// Subscription state to track loading, data, and error states
class SubscriptionState {
  final bool isLoading;
  final bool isPurchasing;
  final bool isPremium;
  final List<SubscriptionPlanDto>? plans;
  final Offerings? offerings;
  final PricingResponse? pricing;
  final UserSubscriptionDto? currentSubscription;
  final CustomerInfo? customerInfo;
  final Object? mySubscription;
  final ReferralEarningsResponse? referralEarnings;
  final List<ReferralHistoryResponse>? referralHistory;
  final String? errorMessage;
  final String? purchaseMessage;

  SubscriptionState({
    this.isLoading = false,
    this.isPurchasing = false,
    this.isPremium = false,
    this.plans,
    this.offerings,
    this.pricing,
    this.currentSubscription,
    this.customerInfo,
    this.mySubscription,
    this.referralEarnings,
    this.referralHistory,
    this.errorMessage,
    this.purchaseMessage,
  });

  /// Convenience: get the current offering's available packages
  List<Package>? get availablePackages => offerings?.current?.availablePackages;

  SubscriptionState copyWith({
    bool? isLoading,
    bool? isPurchasing,
    bool? isPremium,
    List<SubscriptionPlanDto>? plans,
    Offerings? offerings,
    PricingResponse? pricing,
    UserSubscriptionDto? currentSubscription,
    CustomerInfo? customerInfo,
    Object? mySubscription,
    ReferralEarningsResponse? referralEarnings,
    List<ReferralHistoryResponse>? referralHistory,
    String? errorMessage,
    String? purchaseMessage,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      isPremium: isPremium ?? this.isPremium,
      plans: plans ?? this.plans,
      offerings: offerings ?? this.offerings,
      pricing: pricing ?? this.pricing,
      currentSubscription: currentSubscription ?? this.currentSubscription,
      customerInfo: customerInfo ?? this.customerInfo,
      mySubscription: mySubscription ?? this.mySubscription,
      referralEarnings: referralEarnings ?? this.referralEarnings,
      referralHistory: referralHistory ?? this.referralHistory,
      errorMessage: errorMessage,
      purchaseMessage: purchaseMessage,
    );
  }

  SubscriptionState clearError() {
    return copyWith(errorMessage: '', purchaseMessage: '');
  }
}

/// Subscription ViewModel provider
final subscriptionViewModelProvider =
    StateNotifierProvider<SubscriptionViewModel, SubscriptionState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final iapService = ref.watch(iapServiceProvider);
  final viewModel = SubscriptionViewModel(apiService, iapService);
  ref.onDispose(() => viewModel.disposeListeners());
  return viewModel;
});

/// Subscription ViewModel with all subscription-related methods
class SubscriptionViewModel extends StateNotifier<SubscriptionState> {
  SubscriptionViewModel(this._apiService, this._iapService)
      : super(SubscriptionState()) {
    _initRevenueCat();
  }

  final ApiService _apiService;
  final IAPService _iapService;
  StreamSubscription<CustomerInfo>? _customerInfoSub;

  // ──────────────────────────────────────────────────────────────────────────
  // Initialization
  // ──────────────────────────────────────────────────────────────────────────

  /// Initialize RevenueCat SDK and listen for entitlement changes
  Future<void> _initRevenueCat() async {
    try {
      await _iapService.configure(
          appUserId: Platform.isIOS ? "appb37391a1f8" : "app3f5208cc8e");

      // Listen for entitlement changes (renewal, expiry, etc.)
      _customerInfoSub =
          _iapService.customerInfoStream.listen(_onCustomerInfoUpdated);

      // Check current entitlement status
      await checkPremiumStatus();
    } catch (e) {
      log('RevenueCat init error: $e');
    }
  }

  /// Handle customer info updates from RevenueCat
  void _onCustomerInfoUpdated(CustomerInfo info) {
    final isPremium =
        info.entitlements.all[IAPService.entitlementId]?.isActive ?? false;
    state = state.copyWith(
      customerInfo: info,
      isPremium: isPremium,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Entitlement checking
  // ──────────────────────────────────────────────────────────────────────────

  /// Check whether the user currently has an active "Diet Lenz Pro" entitlement
  Future<bool> checkPremiumStatus() async {
    try {
      final isPremium = await _iapService.isPremium();
      final customerInfo = await _iapService.getCustomerInfo();
      state = state.copyWith(
        isPremium: isPremium,
        customerInfo: customerInfo,
      );
      print('Checked premium status: $isPremium');
      return isPremium;
    } catch (e) {
      log('Error checking premium status: $e');
      return false;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Offerings
  // ──────────────────────────────────────────────────────────────────────────

  /// Fetch available offerings (subscription packages) from RevenueCat
  Future<bool> loadOfferings() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final offerings = await _iapService.getOfferings();

      state = state.copyWith(
        isLoading: false,
        offerings: offerings,
        errorMessage: offerings?.current == null
            ? 'No subscription offerings available'
            : null,
      );
      return offerings?.current != null;
    } catch (e) {
      log('Failed to load offerings: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load subscription offerings',
      );
      return false;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Purchases (programmatic)
  // ──────────────────────────────────────────────────────────────────────────

  /// Purchase a subscription package programmatically
  Future<bool> purchasePackage(Package package) async {
    state = state.copyWith(
      isPurchasing: true,
      errorMessage: null,
      purchaseMessage: 'Processing purchase...',
    );

    final customerInfo = await _iapService.purchasePackage(package);

    if (customerInfo != null) {
      final isPremium =
          customerInfo.entitlements.all[IAPService.entitlementId]?.isActive ??
              false;
      state = state.copyWith(
        isPurchasing: false,
        isPremium: isPremium,
        customerInfo: customerInfo,
        purchaseMessage:
            isPremium ? 'Subscription activated!' : 'Purchase processed',
      );
      // Sync with backend
      await getMySubscription();
      return isPremium;
    } else {
      state = state.copyWith(
        isPurchasing: false,
        purchaseMessage: null,
      );
      return false;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // RevenueCat Paywall (recommended approach)
  // ──────────────────────────────────────────────────────────────────────────

  /// Present the RevenueCat-hosted paywall.
  ///
  /// This is the **recommended** way to show your subscription offerings.
  /// The paywall UI is configured remotely in the RevenueCat dashboard,
  /// so you can A/B test and update it without an app release.
  ///
  /// Returns `true` if the user is now premium after the paywall interaction.
  Future<bool> presentPaywall() async {
    state = state.copyWith(isPurchasing: true, errorMessage: null);

    try {
      final result = await _iapService.presentPaywall();

      // Refresh entitlement status after paywall closes
      await checkPremiumStatus();

      state = state.copyWith(
        isPurchasing: false,
        purchaseMessage: result == PaywallResult.purchased
            ? 'Subscription activated!'
            : result == PaywallResult.restored
                ? 'Subscription restored!'
                : null,
      );

      // Sync with backend if purchase/restore happened
      if (result == PaywallResult.purchased ||
          result == PaywallResult.restored) {
       getMySubscription();
      }

      return state.isPremium;
    } on PlatformException catch (e) {
      log('Paywall error: ${e.code} — ${e.message}');
      state = state.copyWith(
        isPurchasing: false,
        errorMessage: e.code == 'NO_OFFERINGS'
            ? 'Subscriptions are not available right now. Please try again later.'
            : 'Failed to present paywall: ${e.message}',
      );
      return false;
    } catch (e) {
      log('Paywall error: $e');
      state = state.copyWith(
        isPurchasing: false,
        errorMessage: 'Failed to present paywall',
      );
      return false;
    }
  }

  /// Present the paywall only if the user does NOT already have the
  /// "Diet Lenz Pro" entitlement. Useful for gating premium features.
  Future<bool> presentPaywallIfNeeded() async {
    if (state.isPremium) return true; // Already premium

    return await presentPaywall();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Customer Center (subscription management)
  // ──────────────────────────────────────────────────────────────────────────

  /// Present the RevenueCat Customer Center.
  ///
  /// Lets users manage their subscription: cancel, change plan, request
  /// refund, etc. — all handled by RevenueCat's native UI.
  Future<void> presentCustomerCenter() async {
    try {
      await _iapService.presentCustomerCenter();
      // Refresh status after customer center closes
      await checkPremiumStatus();
    } catch (e) {
      log('Customer Center error: $e');
      state = state.copyWith(
        errorMessage: 'Failed to open subscription management',
      );
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Restore
  // ──────────────────────────────────────────────────────────────────────────

  /// Restore previous purchases (e.g. after app reinstall)
  Future<bool> restorePurchases() async {
    state = state.copyWith(
      isPurchasing: true,
      purchaseMessage: 'Restoring purchases...',
    );

    final customerInfo = await _iapService.restorePurchases();

    if (customerInfo != null) {
      final isPremium =
          customerInfo.entitlements.all[IAPService.entitlementId]?.isActive ??
              false;
      state = state.copyWith(
        isPurchasing: false,
        isPremium: isPremium,
        customerInfo: customerInfo,
        purchaseMessage: isPremium
            ? 'Subscription restored!'
            : 'No active subscription found',
      );
      return isPremium;
    } else {
      state = state.copyWith(
        isPurchasing: false,
        errorMessage: 'Failed to restore purchases',
        purchaseMessage: null,
      );
      return false;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // User identity (call from auth flow)
  // ──────────────────────────────────────────────────────────────────────────

  /// Log in a user to RevenueCat after your app login succeeds.
  /// Pass your backend user ID so purchases are associated correctly.
  Future<void> loginUser(String userId) async {
    try {
      final info = await _iapService.login(userId);
      _onCustomerInfoUpdated(info);
    } catch (e) {
      log('RevenueCat login error: $e');
    }
  }

  /// Log out user from RevenueCat (call on app logout)
  Future<void> logoutUser() async {
    try {
      await _iapService.logout();
      state = state.copyWith(isPremium: false, customerInfo: null);
    } catch (e) {
      log('RevenueCat logout error: $e');
    }
  }

  /// Dispose listeners
  void disposeListeners() {
    _customerInfoSub?.cancel();
  }

  /// Fetch subscription plans (optionally filtered by country)
  Future<bool> getPlans({String? country}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.subscriptionApi.getPlans(
        country: country,
      );

      state = state.copyWith(
        isLoading: false,
        plans: response,
        errorMessage: null,
      );
      return true;
    } on ApiException catch (e) {
      log('Failed to fetch plans: ${e.code} - ${e.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.extractMessage ?? 'Failed to load subscription plans',
      );
      return false;
    } catch (e) {
      log('Failed to fetch plans: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load subscription plans',
      );
      return false;
    }
  }

  /// Fetch pricing information
  Future<bool> getPricing() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.subscriptionApi.getPricing();

      state = state.copyWith(
        isLoading: false,
        pricing: response,
        errorMessage: null,
      );
      return true;
    } on ApiException catch (e) {
      log('Failed to fetch pricing: ${e.code} - ${e.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.extractMessage ?? 'Failed to load pricing',
      );
      return false;
    } catch (e) {
      log('Failed to fetch pricing: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load pricing',
      );
      return false;
    }
  }

  /// Fetch current user subscription
  Future<bool> getMySubscription() async {
    state = state.copyWith(isLoading: state.mySubscription == null, errorMessage: null);

    try {
      // Use the raw HTTP response to avoid the generated client's broken
      // 'Object' deserializer — the server returns a plain JSON object on 200.
      final response =
          await _apiService.subscriptionApi.getMySubscriptionWithHttpInfo();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = response.body.isNotEmpty
            ? json.decode(response.body) as Map<String, dynamic>
            : <String, dynamic>{};
        state = state.copyWith(
          isLoading: false,
          mySubscription: decoded,
          errorMessage: null,
        );
        return true;
      } else {
        throw ApiException(response.statusCode, response.body);
      }
    } on ApiException catch (e) {
      log('Failed to fetch subscription: ${e.code} - ${e.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.extractMessage ?? 'Failed to load subscription',
      );
      return false;
    } catch (e) {
      log('Failed to fetch subscription: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load subscription',
      );
      return false;
    }
  }

  /// Verify Apple subscription receipt
  Future<bool> verifyAppleSubscription(
      AppleSubscriptionVerifyRequest appleSubscriptionVerifyRequest) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.subscriptionApi
          .verifyAppleSubscription(appleSubscriptionVerifyRequest);

      state = state.copyWith(
        isLoading: false,
        currentSubscription: response,
        errorMessage: null,
      );
      return true;
    } on ApiException catch (e) {
      log('Failed to verify Apple subscription: ${e.code} - ${e.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.extractMessage ?? 'Failed to verify Apple subscription',
      );
      return false;
    } catch (e) {
      log('Failed to verify Apple subscription: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to verify Apple subscription',
      );
      return false;
    }
  }

  /// Verify Google subscription purchase
  Future<bool> verifyGoogleSubscription(
      GoogleSubscriptionVerifyRequest googleSubscriptionVerifyRequest) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.subscriptionApi
          .verifyGoogleSubscription(googleSubscriptionVerifyRequest);

      state = state.copyWith(
        isLoading: false,
        currentSubscription: response,
        errorMessage: null,
      );
      return true;
    } on ApiException catch (e) {
      log('Failed to verify Google subscription: ${e.code} - ${e.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            e.extractMessage ?? 'Failed to verify Google subscription',
      );
      return false;
    } catch (e) {
      log('Failed to verify Google subscription: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to verify Google subscription',
      );
      return false;
    }
  }

  /// Cancel a subscription
  Future<bool> cancelSubscription(String subscriptionId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _apiService.subscriptionApi.cancelSubscription(subscriptionId);

      // Refresh current subscription after cancellation
      await getMySubscription();

      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
      );
      return true;
    } on ApiException catch (e) {
      log('Failed to cancel subscription: ${e.code} - ${e.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.extractMessage ?? 'Failed to cancel subscription',
      );
      return false;
    } catch (e) {
      log('Failed to cancel subscription: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to cancel subscription',
      );
      return false;
    }
  }

  /// Apply a referral code
  Future<bool> applyReferral(ReferralApplyRequest referralApplyRequest) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Use the raw HTTP response to avoid the generated client's broken
      // 'Object' deserializer — the server returns {"message":"..."} on 200.
      final response = await _apiService.subscriptionApi
          .applyReferralWithHttpInfo(referralApplyRequest);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        state = state.copyWith(isLoading: false, errorMessage: null);
        return true;
      } else {
        throw ApiException(response.statusCode, response.body);
      }
    } on ApiException catch (e) {
      log('Failed to apply referral: ${e.code} - ${e.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.extractMessage ?? 'Failed to apply referral code',
      );
      return false;
    } catch (e) {
      log('Failed to apply referral: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to apply referral code',
      );
      return false;
    }
  }

  /// Fetch referral earnings
  Future<bool> getReferralEarnings() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.subscriptionApi.getReferralEarnings();

      state = state.copyWith(
        isLoading: false,
        referralEarnings: response,
        errorMessage: null,
      );
      return true;
    } on ApiException catch (e) {
      log('Failed to fetch referral earnings: ${e.code} - ${e.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.extractMessage ?? 'Failed to load referral earnings',
      );
      return false;
    } catch (e) {
      log('Failed to fetch referral earnings: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load referral earnings',
      );
      return false;
    }
  }

  /// Fetch referral history
  Future<bool> getReferralHistory() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.subscriptionApi.getReferralHistory();

      state = state.copyWith(
        isLoading: false,
        referralHistory: response,
        errorMessage: null,
      );
      return true;
    } on ApiException catch (e) {
      log('Failed to fetch referral history: ${e.code} - ${e.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.extractMessage ?? 'Failed to load referral history',
      );
      return false;
    } catch (e) {
      log('Failed to fetch referral history: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load referral history',
      );
      return false;
    }
  }

  /// Clear error state
  void clearError() {
    state = state.clearError();
  }
}
