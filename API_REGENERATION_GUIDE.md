# API Client Regeneration Guide

## When to Regenerate

Regenerate the API client whenever:
- ✅ Backend API endpoints change
- ✅ Request/response models are updated
- ✅ New API endpoints are added
- ✅ Enum values are modified
- ✅ Field types change in the Swagger spec

## Quick Start

### Method 1: Using the Regeneration Script (Easiest)

```bash
# Make sure you're in the project root
cd "/Users/ayodeji/Desktop/untitled folder/diet_lenz"

# Run the script (it will use the default Swagger URL)
./regenerate_api.sh

# OR specify a custom Swagger URL/file
./regenerate_api.sh https://your-api.com/v3/api-docs
./regenerate_api.sh path/to/swagger.json
```

The script will:
1. ✅ Backup your current API client
2. ✅ Generate new API client code
3. ✅ Install dependencies automatically
4. ✅ Restore backup if generation fails

### Method 2: Manual Regeneration

1. **Get the updated Swagger spec:**
```bash
# Download from your API
curl https://diet-lenz-api.onrender.com/v3/api-docs -o swagger.json

# OR get it from your backend team
```

2. **Backup current API client:**
```bash
mv lib/api_client lib/api_client_backup
```

3. **Generate new client:**
```bash
npx @openapitools/openapi-generator-cli generate \
  -i swagger.json \
  -g dart \
  -o lib/api_client \
  --additional-properties=pubName=openapi
```

4. **Install dependencies:**
```bash
cd lib/api_client && flutter pub get
cd ../.. && flutter pub get
```

## After Regeneration Checklist

After regenerating the API client, you need to:

### 1. Check for Breaking Changes

```bash
# Compare the old and new API clients
diff -r lib/api_client_backup/lib/api lib/api_client/lib/api
diff -r lib/api_client_backup/lib/model lib/api_client/lib/model
```

### 2. Update Your Code

Review and update:

#### Enum Values
```dart
// Old enum value might have changed
ProfileRequestDtoDesiredGoalEnum.WEIGHT_LOSS  // Check if this still exists
ProfileRequestDtoDesiredGoalEnum.LOSE_WEIGHT  // Or if it changed to this
```

#### Field Types
```dart
// Check if field types changed
int? age  // might have changed to
String? age
```

#### New Required Fields
```dart
// Check if new required fields were added to models
ProfileRequestDto(
  // ... existing fields
  newRequiredField: value,  // Add this if required
)
```

### 3. Update ViewModels

Check these files for potential updates:

- `lib/features/auth/controller/auth_viewmodel.dart`
- `lib/features/user/controller/user_profile_viewmodel.dart`
- `lib/features/recipe/controller/recipe_viewmodel.dart`

### 4. Update Onboarding Flow

If profile fields changed, update:
- `lib/features/auth/controller/onboarding_profile_provider.dart`
- `lib/features/auth/view/personization/setup_finished.dart`

### 5. Test Your App

```bash
# Run the app and test critical flows
flutter run

# Check for:
- Login/Register
- Profile update
- API calls
- Enum mappings
```

## Common Issues & Solutions

### Issue 1: Enum Values Changed

**Error:** `The getter 'WEIGHT_LOSS' isn't defined`

**Solution:** Check the new enum values in the generated model:
```bash
# Find the enum definition
grep -A 10 "class ProfileRequestDtoDesiredGoalEnum" lib/api_client/lib/model/profile_request_dto.dart
```

Then update your code with the correct enum values.

### Issue 2: Field Types Changed

**Error:** `The argument type 'int' can't be assigned to parameter type 'String'`

**Solution:** Update the field type in your code to match the new API spec.

### Issue 3: New Required Fields

**Error:** `The named parameter 'newField' is required`

**Solution:** Add the new required field to your API calls:
```dart
ProfileRequestDto(
  // ... existing fields
  newField: value,  // Add this
)
```

### Issue 4: API Endpoints Changed

**Error:** `MissingStubError: 'methodName'`

**Solution:** Check the new API controller:
```bash
ls lib/api_client/lib/api/
```

Update your code to use the correct API method names.

## Rollback

If something goes wrong, restore the backup:

```bash
rm -rf lib/api_client
mv lib/api_client_backup lib/api_client
flutter pub get
```

## Best Practices

1. ✅ **Always backup before regenerating** (the script does this automatically)
2. ✅ **Test in a separate branch** before merging
3. ✅ **Review the diff** to understand what changed
4. ✅ **Update documentation** if API behavior changed
5. ✅ **Run tests** after regeneration
6. ✅ **Commit the changes** with a clear message like "chore: regenerate API client from updated Swagger spec"

## Questions?

- Check `SWAGGER_API_GUIDE.md` for API usage examples
- Check generated documentation in `lib/api_client/doc/`
- Review the API models in `lib/api_client/lib/model/`

---

**Quick Command Reference:**

```bash
# Regenerate API
./regenerate_api.sh

# Regenerate with custom URL
./regenerate_api.sh https://custom-api.com/v3/api-docs

# Check differences
diff -r lib/api_client_backup lib/api_client

# Rollback
rm -rf lib/api_client && mv lib/api_client_backup lib/api_client

# Clean and rebuild
flutter clean && flutter pub get && flutter run
```
