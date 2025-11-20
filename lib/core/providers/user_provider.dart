// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:vepay/core/models/user_model.dart';
// import 'package:vepay/core/repositories/storage_repository.dart';
// import 'package:vepay/core/constants/storage_keys.dart';

// // Create a provider for StorageRepository
// final storageRepositoryProvider = Provider<StorageRepository>((ref) {
//   // You'll need to provide the actual StorageService instance here
//   // For example:
//   // return StorageRepository(StorageService());
//   throw UnimplementedError('StorageRepository provider not implemented');
// });

// final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
//   return UserNotifier(ref.watch(storageRepositoryProvider));
// });

// class UserNotifier extends StateNotifier<UserModel?> {
//   final StorageRepository _storageRepository;

//   UserNotifier(this._storageRepository) : super(null) {
//     // Load user data from storage if available
//     _loadUserFromStorage();
//   }

//   Future<void> _loadUserFromStorage() async {
//     final userId = _storageRepository.getUserId();
//     final userName = _storageRepository.getUserName();
//     final userEmail = _storageRepository.getUserEmail();
//     final walletBalance = _storageRepository.getWalletBalance();

//     if (userId != null && userName != null && userEmail != null) {
//       state = UserModel(
//         id: userId,
//         name: userName,
//         email: userEmail,
//         walletBalance: walletBalance,
//       );
//     }
//   }

//   Future<void> setUser({
//     required String id,
//     required String name,
//     required String email,
//     required double walletBalance,
//   }) async {
//     // Save to storage
//     await _storageRepository.saveUserId(id);
//     await _storageRepository.saveUserDetails(name: name, email: email);
//     await _storageRepository.saveWalletBalance(walletBalance);

//     // Update state
//     state = UserModel(
//       id: id,
//       name: name,
//       email: email,
//       walletBalance: walletBalance,
//     );
//   }

//   Future<void> updateWalletBalance(double newBalance) async {
//     if (state == null) return;

//     await _storageRepository.saveWalletBalance(newBalance);
//     state = state!.copyWith(walletBalance: newBalance);
//   }

//   Future<void> clearUser() async {
//     await _storageRepository.clearStorage();
//     state = null;
//   }
// }
