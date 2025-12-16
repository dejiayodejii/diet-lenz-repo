# Automatic Token Refresh Implementation Guide

## Overview
The app now automatically handles token refresh when API calls return a 401 (Unauthorized) error. If the refresh token is also expired, the user is automatically logged out and redirected to the login screen.

## How It Works

### 1. **API Service (`api_service.dart`)**
- **`executeWithTokenRefresh()`**: Wraps API calls to automatically handle 401 errors
- **`refreshAccessToken()`**: Calls the refresh token endpoint to get a new access token
- **`onUnauthorized` callback**: Triggers navigation to login when tokens expire

### 2. **Flow Diagram**
```
User makes API call
    ↓
executeWithTokenRefresh() wraps the call
    ↓
API returns 401 (Unauthorized)
    ↓
refreshAccessToken() is called automatically
    ↓
    ├─→ Success: New token saved, original request retried
    │   ↓
    │   Original API call succeeds
    │
    └─→ Failure: Refresh token expired
        ↓
        onUnauthorized() callback triggered
        ↓
        User navigated to Login Screen
        ↓
        All tokens cleared
```

### 3. **Implementation Details**

#### API Providers Setup (`api_providers.dart`)
```dart
// Set up callback for handling unauthorized/expired tokens
apiService.onUnauthorized = () {
  // Navigate to login screen and clear navigation stack
  NavigationService.pushAndRemoveUntil(
    child: const LoginScreen(),
  );
};
```

#### Viewmodel Usage (Example from `food_logging_viewmodel.dart`)
```dart
// Before (without token refresh)
final response = await _apiService.foodLoggingApi.getDashboard(date: date);

// After (with automatic token refresh)
final response = await _apiService.executeWithTokenRefresh(
  () => _apiService.foodLoggingApi.getDashboard(date: date),
);
```

## API Methods Wrapped with Token Refresh

The following methods in `FoodLoggingViewModel` now have automatic token refresh:

1. ✅ `getDashboard()` - Dashboard data
2. ✅ `getUserRecipes()` - User's food logs
3. ✅ `getFavorites()` - Favorite recipes
4. ✅ `logMeal()` - Meal logging
5. ✅ `toggleFavoriteLocally()` - Toggle favorites

## Adding Token Refresh to Other API Calls

To add automatic token refresh to any API call, wrap it with `executeWithTokenRefresh()`:

```dart
Future<bool> myApiMethod() async {
  state = state.copyWith(isLoading: true, errorMessage: null);

  try {
    // Wrap your API call
    final response = await _apiService.executeWithTokenRefresh(
      () => _apiService.yourApi.yourMethod(params),
    );

    if (response != null) {
      state = state.copyWith(
        isLoading: false,
        data: response,
        errorMessage: null,
      );
      return true;
    }
    
    return false;
  } on ApiException catch (e) {
    state = state.copyWith(
      isLoading: false,
      errorMessage: _parseApiError(e),
    );
    return false;
  } catch (e) {
    state = state.copyWith(
      isLoading: false,
      errorMessage: 'An unexpected error occurred',
    );
    return false;
  }
}
```

## Testing the Flow

### Test Case 1: Token Refresh Success
1. Let access token expire (or manually set an expired token)
2. Make any API call (e.g., pull to refresh on home screen)
3. **Expected**: API call fails with 401 → refresh token called → new token obtained → original call retried → success

### Test Case 2: Refresh Token Expired
1. Let both access and refresh tokens expire
2. Make any API call
3. **Expected**: API call fails with 401 → refresh token called → refresh fails with 401 → `onUnauthorized()` triggered → user redirected to login screen

### Test Case 3: Concurrent Requests
1. Make multiple API calls simultaneously while token is expired
2. **Expected**: Only one refresh attempt happens (due to `_isRefreshing` flag) → all requests wait → all succeed with new token

## Security Features

1. **Single Refresh Attempt**: `_isRefreshing` flag prevents multiple simultaneous refresh attempts
2. **Automatic Token Storage**: New tokens are automatically saved to secure storage
3. **Clean Logout**: All tokens cleared on failure, authorization header removed
4. **Retry Logic**: Original request automatically retried after successful refresh

## Console Logs

When debugging, you'll see these log messages:

- `🔐 Got 401 - attempting token refresh...` - 401 detected
- `🔄 Attempting to refresh access token...` - Refresh starting
- `✅ Token refreshed successfully` - New tokens obtained
- `🔄 Retrying original request with new token...` - Original call retrying
- `❌ Token refresh failed with API error: 401` - Refresh token expired
- `🚪 Handling expired token - clearing auth and navigating to login` - Logout triggered

## Notes

- The refresh flow is completely transparent to the user
- No loading indicators shown during token refresh (seamless experience)
- If refresh fails, user sees login screen immediately
- All pending requests will fail if refresh fails
- Token refresh only happens once per expiration (not on every 401)
