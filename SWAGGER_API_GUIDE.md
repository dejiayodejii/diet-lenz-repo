# Swagger API Usage Guide

## Overview

The Diet Lenz API client has been automatically generated from your Swagger/OpenAPI specification. Here's everything you need to know to use it effectively.

## Setup

### 1. Initialize API Service

In your `main.dart`, initialize the API service before running the app:

```dart
import 'package:diet_lenz/core/services/api_service.dart';

void main() {
  // Initialize API service with base URL
  ApiService().initialize(
    baseUrl: 'https://diet-lenz-api.onrender.com',
  );
  
  runApp(const MyApp());
}
```

## Using Authentication

### Login Example

```dart
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    final authViewModel = ref.read(authViewModelProvider.notifier);
    
    // Call login - error handling is built-in
    final success = await authViewModel.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
    // Error message is automatically stored in authState.errorMessage
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      body: Column(
        children: [
          TextField(controller: _emailController),
          TextField(controller: _passwordController, obscureText: true),
          
          // Show error if exists
          if (authState.errorMessage != null)
            Text(authState.errorMessage!, style: TextStyle(color: Colors.red)),
          
          // Login button with loading state
          ElevatedButton(
            onPressed: authState.isLoading ? null : _handleLogin,
            child: authState.isLoading
                ? CircularProgressIndicator()
                : Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

### Other Auth Methods

```dart
final authViewModel = ref.read(authViewModelProvider.notifier);

// Register
await authViewModel.register(
  email: 'user@example.com',
  password: 'password123',
  firstName: 'John',
  lastName: 'Doe',
);

// Google Login
await authViewModel.googleLogin(
  idToken: 'google-id-token',
);

// Apple Login
await authViewModel.appleLogin(
  idToken: 'apple-id-token',
);

// Logout
await authViewModel.logout();
```

## Error Handling

### The generated API automatically handles errors:

```dart
try {
  final response = await ApiService().authApi.login(request);
  // Success - use response
  
} on ApiException catch (e) {
  // HTTP error (400, 401, 404, 500, etc.)
  print('Error Code: ${e.code}');
  print('Error Message: ${e.message}');
  
  switch (e.code) {
    case 401:
      print('Unauthorized - check credentials');
      break;
    case 404:
      print('Not found');
      break;
    case 500:
      print('Server error');
      break;
  }
  
} catch (e) {
  // Network error, parsing error, etc.
  print('Unexpected error: $e');
}
```

### AuthViewModel handles errors for you:

```dart
// No need to wrap in try-catch when using AuthViewModel
final success = await authViewModel.login(...);

if (!success) {
  // Check authState.errorMessage for the error
  final error = ref.read(authViewModelProvider).errorMessage;
  print('Login failed: $error');
}
```

## Using Other API Endpoints

### Example: Food Logging Service

```dart
import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/core/services/api_service.dart';

class FoodService {
  final _apiService = ApiService();

  Future<MealLogResponseDto?> logMeal(LogMealRequestDto request) async {
    try {
      return await _apiService.foodLoggingApi.logMeal(request);
    } on ApiException catch (e) {
      print('API Error: ${e.code} - ${e.message}');
      return null;
    }
  }
}
```

## Available API Controllers

The API service provides these pre-initialized controllers:

```dart
final apiService = ApiService();

// Authentication
apiService.authApi.login(...)
apiService.authApi.register(...)
apiService.authApi.googleLogin(...)
apiService.authApi.appleLogin(...)
apiService.authApi.refresh(...)

// User operations
apiService.userApi.* // Check generated methods

// Food logging
apiService.foodLoggingApi.logMeal(...)
// ... other food methods

// Recipes
apiService.recipeApi.* // Check generated methods
```

## Key Points

### 1. Error Handling is Built-in
- Generated code throws `ApiException` for HTTP errors (400+)
- **Always use try-catch blocks** when calling API methods directly
- `AuthViewModel` already handles this for auth operations

### 2. Models are Auto-Generated
- All request/response models are in `lib/api_client/lib/model/`
- They have `toJson()` and `fromJson()` methods
- Properties may be nullable - check the generated code

### 3. Authentication Token Management
```dart
// Set token (done automatically after login)
await ApiService().setAuthToken('your-token');

// Token is automatically added to all subsequent requests
// No need to manually add headers

// Clear token on logout
await ApiService().clearAuthToken();
```

### 4. Checking Auth Status

```dart
// In your widget
final authState = ref.watch(authViewModelProvider);

if (authState.isAuthenticated) {
  // User is logged in
  final email = authState.authResponse?.email;
  final userId = authState.authResponse?.userId;
}
```

## Common Patterns

### Pattern 1: Simple API Call
```dart
final response = await ApiService().authApi.login(request);
```

### Pattern 2: With Error Handling
```dart
try {
  final result = await ApiService().foodLoggingApi.logMeal(request);
  // Handle success
} on ApiException catch (e) {
  // Handle API error
  print('Error: ${e.message}');
}
```

### Pattern 3: In a ViewModel/Provider
```dart
state = state.copyWith(isLoading: true);

try {
  final data = await apiCall();
  state = state.copyWith(
    data: data,
    isLoading: false,
    error: null,
  );
} on ApiException catch (e) {
  state = state.copyWith(
    isLoading: false,
    error: e.message,
  );
}
```

## Best Practices

1. ✅ Initialize `ApiService` in `main.dart`
2. ✅ Use `AuthViewModel` for all authentication operations
3. ✅ Create service classes for other API operations
4. ✅ Always handle `ApiException` separately from other exceptions
5. ✅ Check if widget is mounted before navigation after async calls
6. ✅ Store sensitive data (tokens) securely (already done in `ApiService`)
7. ✅ Show loading states during API calls
8. ✅ Display user-friendly error messages

## Response Models

All API responses are typed. Example:

```dart
final response = await apiService.authApi.login(request);

// AuthResponse properties:
response.accessToken    // String?
response.refreshToken   // String?
response.userId         // String?
response.email          // String?
response.emailVerified  // bool?
```

## Need Help?

- Check the generated model files in `lib/api_client/lib/model/`
- Check the API controller files in `lib/api_client/lib/api/`
- The `AuthViewModel` (`lib/features/auth/controller/auth_viewmodel.dart`) is a complete example
- API documentation is in `lib/api_client/doc/`

---

**Summary**: You don't need to handle errors manually when using `AuthViewModel`. For other APIs, create similar service classes with try-catch blocks. The generated code does most of the heavy lifting!
