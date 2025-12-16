# Bug Report: Swagger Spec Mismatch for UserProfile

**Priority:** Medium  
**Component:** API Documentation (Swagger/OpenAPI Spec)  
**Endpoint:** `GET /api/v1/users/profile` and `PUT /api/v1/users/profile`

---

## Summary

The Swagger specification for `UserProfile` incorrectly declares several fields as required/non-nullable, but the API returns `null` for these fields. This causes deserialization errors in client applications.

## The Issue

### What the API Returns (Actual Response)
```json
{
  "id": "b9f32ecc-95d2-4dad-b3ce-a58d4878dc6b",
  "height": 140,
  "weight": null,
  "age": null,
  "activityLevel": "MODERATELY_ACTIVE",
  "gender": "MALE",
  "currentWeight": 50,
  "dateOfBirth": "1993-12-11",
  ...
}
```

### What the Swagger Spec Says (Current)
```yaml
UserProfile:
  type: object
  properties:
    weight:
      type: number
      # Currently marked as required/non-nullable
    height:
      type: number
      # Currently marked as required/non-nullable
    age:
      type: integer
      # Currently marked as required/non-nullable
```

### The Problem
When users haven't set their weight, height, or age yet, the API returns `null` for these fields. However, the Swagger spec doesn't declare them as nullable, so auto-generated clients fail to deserialize the response.

**Error in mobile app:**
```
ApiException 500: Exception during deserialization
(Inner exception: FormatException: null)
```

This happens because generated code tries to parse: `num.parse('null')` which throws an exception.

---

## Impact

- ❌ Mobile app crashes when fetching user profile with null weight/height/age
- ❌ Auto-generated API clients (Dart, TypeScript, Java, etc.) fail
- ❌ API documentation misleads developers
- ⚠️ Required temporary patches on client side

**Affected Clients:**
- Flutter/Dart mobile app (currently patched)
- Any other clients using auto-generated code from the Swagger spec

---

## Proposed Fix

Update the Swagger/OpenAPI specification to mark these fields as **nullable**:

```yaml
UserProfile:
  type: object
  properties:
    weight:
      type: number
      nullable: true  # ✅ ADD THIS
      description: User's weight (nullable if not set)
    height:
      type: number
      nullable: true  # ✅ ADD THIS
      description: User's height (nullable if not set)
    age:
      type: integer
      nullable: true  # ✅ ADD THIS
      description: User's age (nullable if not calculated from dateOfBirth)
```

**Alternative (if using OpenAPI 3.1):**
```yaml
weight:
  type:
    - number
    - "null"
```

---

## Fields That Need Fixing

Based on the actual API response, these `UserProfile` fields should be marked as nullable:

1. ✅ `weight` - Can be null when user hasn't entered it
2. ✅ `height` - Can be null when user hasn't entered it  
3. ✅ `age` - Can be null (derived from dateOfBirth)
4. ✅ `goal` - Currently null in response
5. ✅ `macroTarget` - Currently null in response

Please verify and update all fields that can legitimately be null in real API responses.

---

## Testing the Fix

After updating the Swagger spec:

### 1. Validate the Spec
```bash
# Use Swagger validator
swagger-cli validate swagger.yaml

# Or use online validator
# https://editor.swagger.io/
```

### 2. Test with Sample Data
```bash
# Create a test user with null fields
curl -X GET https://diet-lenz-api.onrender.com/api/v1/users/profile \
  -H "Authorization: Bearer <token>"

# Verify response matches Swagger spec
```

### 3. Check Generated Code
```bash
# Mobile team will regenerate client
./regenerate_api.sh

# Verify no deserialization errors
```

---

## Current Workaround (Mobile Team)

We've applied a temporary patch to handle null values gracefully:

```dart
// Patched code in UserProfile.fromJson
height: json[r'height'] != null ? num.parse('${json[r'height']}') : null,
weight: json[r'weight'] != null ? num.parse('${json[r'weight']}') : null,
```

**This patch will be removed** once the Swagger spec is fixed and we regenerate our API client.

---

## Additional Recommendations

### 1. Add Swagger Validation to CI/CD
```yaml
# Example: Add to GitHub Actions
- name: Validate Swagger Spec
  run: swagger-cli validate src/main/resources/swagger.yaml
```

### 2. Use Swagger Lint Tools
- [Spectral](https://stoplight.io/open-source/spectral) - Advanced OpenAPI linting
- [Swagger Editor](https://editor.swagger.io/) - Real-time validation

### 3. Version Breaking Changes
If you need to make breaking changes in the future:
- Use API versioning: `/api/v2/users/profile`
- Document migration path for clients
- Give advance notice to client teams

---

## Timeline

**Requested completion:** Next sprint

**Why it matters:**
- We're maintaining a temporary patch that needs to be re-applied after every API regeneration
- New developers joining the project will encounter this issue
- Other client teams (web, iOS if Swift) may hit the same problem

---

## Questions or Need More Info?

- Swagger spec location: `https://diet-lenz-api.onrender.com/v3/api-docs`
- Contact: Mobile team (Flutter/Dart)
- Related docs: See `KNOWN_API_ISSUES.md` in mobile repo

Thank you! 🙏
