# Known Issues with Auto-Generated API

## Issue #1: Deserialization Error - FormatException on UserProfile

### The Problem

**Error:** `ApiException 500: Exception during deserialization. (Inner exception: FormatException: null)`

**What's happening:**
The backend API returns this response:
```json
{
  "height": 140,
  "weight": null,  // ⚠️ This is NULL
  "age": null,     // ⚠️ This is NULL
  ...
}
```

But the Swagger spec says these fields are **required/non-nullable**, so the generated code tries to parse them:
```dart
height: num.parse('${json[r'height']}'),  // Works fine
weight: num.parse('${json[r'weight']}'),  // ❌ Fails: num.parse('null')
```

This is a **Swagger specification mismatch** - the spec doesn't match what the backend actually returns.

### Root Cause

Your backend's Swagger spec declares `weight`, `height`, and `age` as required/non-nullable:
```yaml
# Current (WRONG) Swagger spec
UserProfile:
  properties:
    weight:
      type: number
      # Missing: nullable: true
    height:
      type: number
      # Missing: nullable: true
```

But the actual API returns `null` for these fields when they haven't been set yet.

### Why This Validates Your Concerns About Auto-Gen

**You asked:** "is this a good idea? i am worried this might be harder to maintain.. is my fear valid?"

**Answer:** This is a **perfect example** of the ONE downside of auto-generation:

✅ **Good news:** The auto-generated code is doing EXACTLY what the Swagger spec says  
❌ **Bad news:** The Swagger spec is WRONG (doesn't match reality)

**BUT** - this would be WORSE without auto-gen because:
1. You'd discover this bug at runtime in production (silent failure)
2. With auto-gen, you found it immediately during development
3. The error message tells you EXACTLY what's wrong
4. TypeScript/Java/Python clients would have the same issue

This is actually **auto-generation working as intended** - it exposed a backend API documentation bug!

## The Solution

### Option 1: Fix the Backend (BEST - Permanent Fix)

Ask your backend team to update the Swagger/OpenAPI spec:

```yaml
# Fixed Swagger spec
UserProfile:
  properties:
    weight:
      type: number
      nullable: true  # ✅ Add this
    height:
      type: number
      nullable: true  # ✅ Add this
    age:
      type: integer
      nullable: true  # ✅ Add this
```

Then regenerate:
```bash
./regenerate_api.sh
```

### Option 2: Temporary Patch (Current Workaround)

We've applied a temporary patch that handles nulls gracefully:

```dart
// Before (auto-generated):
height: num.parse('${json[r'height']}'),  // Crashes on null

// After (patched):
height: json[r'height'] != null ? num.parse('${json[r'height']}') : null,  // ✅ Safe
```

**The patch is automatically applied** when you run `./regenerate_api.sh`

**Files involved:**
- `lib/api_client/lib/model/user_profile.dart` - Gets patched automatically
- `fix_user_profile_nullability.dart` - The patch script
- `regenerate_api.sh` - Runs the patch after generation

## How We Handle It Now

### In the ViewModel

We added better error detection:

```dart
} on ApiException catch (e) {
  // Detect deserialization errors
  if (e.message != null && e.message!.contains('FormatException')) {
    state = state.copyWith(
      errorMessage: 'API response format mismatch. The backend may have changed.',
    );
    print('⚠️ Deserialization error: Swagger spec is out of sync');
  }
}
```

### In the Generated Code

The patch makes null-handling safe:
```dart
weight: json[r'weight'] != null ? num.parse('${json[r'weight']}') : null,
```

## Testing

After applying the patch, test with your API response:

```dart
// Your actual API response
{
  "weight": null,
  "height": 140,
  ...
}

// Should now deserialize successfully:
UserProfile profile = UserProfile.fromJson(response);
print(profile.weight);  // null (no crash!)
print(profile.height);  // 140
```

## When You Can Remove This Patch

Once the backend fixes the Swagger spec to mark these fields as nullable:

1. Delete `fix_user_profile_nullability.dart`
2. Update `regenerate_api.sh` to remove the patch step
3. Run `./regenerate_api.sh` 
4. The generated code will handle nulls correctly by default

## Prevention

To avoid similar issues in the future:

### 1. Validate Swagger Spec
Ask backend to run validation:
```bash
# Backend should validate their Swagger spec
swagger-cli validate swagger.yaml
```

### 2. Compare Spec vs Reality
```bash
# Get actual API response
curl https://diet-lenz-api.onrender.com/api/v1/users/profile \
  -H "Authorization: Bearer YOUR_TOKEN" | jq

# Compare with Swagger spec
curl https://diet-lenz-api.onrender.com/v3/api-docs | jq '.components.schemas.UserProfile'
```

### 3. Use Swagger Lint
Backend should use linters:
- [Spectral](https://stoplight.io/open-source/spectral)
- [Swagger Editor](https://editor.swagger.io/)

### 4. Version Your API
When backend makes breaking changes:
```dart
// Use versioned API clients
import 'package:diet_lenz/api_client_v1/api.dart';  // Old version
import 'package:diet_lenz/api_client_v2/api.dart';  // New version
```

## Key Takeaways

1. ✅ **Auto-gen is still the right choice** - it caught this bug early
2. ⚠️ **Swagger spec quality matters** - garbage in, garbage out
3. 🔧 **Patches are temporary** - fix the root cause (backend spec)
4. 📝 **Document workarounds** - so you know what to remove later
5. 🤝 **Communication with backend** - they need to know about spec issues

## Related Issues

- [ ] Backend: Mark `weight`, `height`, `age` as nullable in Swagger spec
- [ ] Backend: Add Swagger validation to CI/CD
- [ ] Frontend: Remove patch after backend fix

## Questions?

- Check `API_REGENERATION_GUIDE.md` for regeneration process
- Check `SWAGGER_API_GUIDE.md` for API usage examples
- Contact backend team about Swagger spec issues
