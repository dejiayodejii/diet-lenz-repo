import 'dart:convert';

import 'package:diet_lenz/core/constants/storage_keys.dart';
import 'package:diet_lenz/core/services/storage_service.dart';

class StorageRepository {
  final StorageService _storageService;

  StorageRepository(this._storageService);

  // Auth related methods
  Future<void> saveToken(String token) async {
    await _storageService.setString(StorageKeys.token, token);
  }

  String? getToken() {
    return _storageService.getString(StorageKeys.token);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storageService.setString(StorageKeys.refreshToken, refreshToken);
  }

  String? getRefreshToken() {
    return _storageService.getString(StorageKeys.refreshToken);
  }

  Future<void> saveUserId(String userId) async {
    await _storageService.setString(StorageKeys.userId, userId);
  }

  String? getUserId() {
    return _storageService.getString(StorageKeys.userId);
  }

  Future<void> setOnboarding(bool value) async {
    await _storageService.setBool(StorageKeys.seenOnboarding, value);
  }

  bool getOnboarding() {
    return _storageService.getBool(StorageKeys.seenOnboarding) ?? false;
  }

  // Auth response methods
  Future<void> saveAuthResponse(String authResponseJson) async {
    await _storageService.setString(
        StorageKeys.authResponseData, authResponseJson);
  }

  String? getAuthResponse() {
    return _storageService.getString(StorageKeys.authResponseData);
  }

  Future<void> clearAuthResponse() async {
    await _storageService.remove(StorageKeys.authResponseData);
  }

  // User related methods
  // Future<void> saveUserDetails({required User user}) async {
  //   // await _storageService.setString(StorageKeys.token, user.accessToken);
  //   // await _storageService.setString(
  //   //     StorageKeys.refreshToken, user.refreshToken);
  //   await _storageService.setString(
  //       StorageKeys.userData, json.encode(user.toJson()));
  // }

  //   Future<void> saveAppTokwn({required AuthTokenResponse token}) async {
  //   await _storageService.setString(StorageKeys.token, token.accessToken);
  //   await _storageService.setString(
  //       StorageKeys.refreshToken, token.refreshToken);

  // }

  // User? getUserDetails() {
  //   String? userData = _storageService.getString(StorageKeys.userData);
  //   if (userData != null) {
  //     return User.fromJson(json.decode(userData));
  //   }
  //   return null;
  // }

  String? getUserName() {
    return _storageService.getString("");
  }

  String? getUserEmail() {
    return _storageService.getString(StorageKeys.userEmail);
  }

  // Wallet related methods
  Future<void> saveWalletBalance(double balance) async {
    await _storageService.setDouble(StorageKeys.walletBalance, balance);
  }

  double getWalletBalance() {
    return _storageService.getDouble(StorageKeys.walletBalance) ?? 0.0;
  }

  // Future<void> saveDefaultWallet(Wallet wallet) async {
  //   await _storageService.setString(
  //     StorageKeys.defaultWallet,
  //     json.encode(wallet.toJson()),
  //   );
  // }

  // Wallet? getDefaultWallet() {
  //   String? walletData = _storageService.getString(StorageKeys.defaultWallet);
  //   if (walletData != null) {
  //     return Wallet.fromJson(json.decode(walletData));
  //   }
  //   return null;
  // }

  // User profile methods
  Future<void> saveUserProfile(String profileJson) async {
    await _storageService.setString(StorageKeys.userProfileData, profileJson);
  }

  String? getUserProfile() {
    return _storageService.getString(StorageKeys.userProfileData);
  }

  Future<void> clearUserProfile() async {
    await _storageService.remove(StorageKeys.userProfileData);
  }

  // Health permission methods
  Future<void> setHealthPermissionGranted(bool value) async {
    await _storageService.setBool(StorageKeys.healthPermissionGranted, value);
  }

  bool getHealthPermissionGranted() {
    return _storageService.getBool(StorageKeys.healthPermissionGranted) ??
        false;
  }

  // Clear all stored data
  Future<void> clearStorage() async {
    await _storageService.clear();
    // setOnboarding(true);
  }
}
