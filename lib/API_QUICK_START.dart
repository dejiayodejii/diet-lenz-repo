// // QUICK START - Using Swagger Generated API
// // ==========================================

// import 'package:diet_lenz/core/services/api_service.dart';
// import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';

// void main() {
//   // 1. Initialize in main.dart
//   ApiService().initialize(
//     baseUrl: 'https://diet-lenz-api.onrender.com',
//   );
//   runApp(const MyApp());
// }

// // 2. Login Example - Complete Working Code
// class LoginExample extends ConsumerWidget {
//   Future<void> handleLogin(WidgetRef ref, String email, String password) async {
//     final authViewModel = ref.read(authViewModelProvider.notifier);

//     final success = await authViewModel.login(
//       email: email,
//       password: password,
//     );

//     if (success) {
//       // Navigate to home
//     } else {
//       // Check ref.read(authViewModelProvider).errorMessage
//     }
//   }
// }

// // 3. YES - Error handling is automatic in AuthViewModel ✅
// // 4. NO - You don't need try-catch when using AuthViewModel ✅
// // 5. YES - For other APIs, wrap in try-catch ✅

// // Example: Using food API
// Future<void> logMeal() async {
//   try {
//     final response = await ApiService().foodLoggingApi.logMeal(request);
//     // Use response
//   } on ApiException catch (e) {
//     print('Error: ${e.message}');
//   }
// }

// // That's it! Check SWAGGER_API_GUIDE.md for full details.
