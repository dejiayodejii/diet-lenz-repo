Subject: 🐛 Swagger Spec Issue: UserProfile fields should be nullable

Hi Backend Team,

We've discovered a mismatch between the Swagger spec and actual API responses for the UserProfile endpoint.

## The Problem

The API returns `null` for several fields, but the Swagger spec doesn't mark them as nullable:

**Actual API Response:**
```json
{
  "weight": null,
  "height": 140,
  "age": null,
  "goal": null,
  ...
}
```

**Current Swagger Spec:** Declares these as required/non-nullable

**Impact:** Auto-generated clients crash with deserialization errors:
```
ApiException 500: Exception during deserialization
(Inner exception: FormatException: null)
```

## The Fix Needed

Please update the Swagger spec to mark these fields as `nullable: true`:

- `weight`
- `height`
- `age`
- `goal`
- `macroTarget`

**Example:**
```yaml
UserProfile:
  properties:
    weight:
      type: number
      nullable: true  # ✅ Add this
```

## Why This Matters

- Mobile app is currently using a temporary patch that needs maintenance
- Any client using auto-generated code from Swagger will hit this issue
- New developers will encounter the same problem

## More Details

See attached `BACKEND_BUG_REPORT.md` for:
- Full API response example
- Complete list of affected fields
- Testing steps after the fix
- Recommendations for preventing similar issues

We've temporarily patched our client, but would love to remove the workaround once the spec is fixed!

Let me know if you need any clarification or want to discuss.

Thanks! 🙏

---
**Attachments:**
- BACKEND_BUG_REPORT.md (detailed technical report)
- Sample API response with null values
