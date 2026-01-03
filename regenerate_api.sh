#!/bin/bash

# Regenerate API Client from Swagger Specification
# Usage: ./regenerate_api.sh [swagger-url-or-file]

echo "🔄 Regenerating API Client..."

# Default Swagger URL (update this with your actual endpoint)
SWAGGER_SOURCE="${1:-https://diet-lenz-stagingapi-d3mbl.ondigitalocean.app/v3/api-docs}"

echo "📥 Source: $SWAGGER_SOURCE"

# Backup current API client
if [ -d "lib/api_client" ]; then
  echo "📦 Backing up current API client..."
  BACKUP_DIR="lib/api_client_backup_$(date +%Y%m%d_%H%M%S)"
  mv lib/api_client "$BACKUP_DIR"
  echo "✅ Backup saved to: $BACKUP_DIR"
fi

# Generate new API client
echo "🔨 Generating new API client..."
npx @openapitools/openapi-generator-cli generate \
  -i "$SWAGGER_SOURCE" \
  -g dart \
  -o lib/api_client \
  --additional-properties=pubName=openapi,pubAuthor=DietLenz,pubAuthorEmail=support@dietlenz.com \
  --skip-validate-spec

if [ $? -eq 0 ]; then
  echo "✅ API client generated successfully!"
  
  # Install dependencies
  echo "📦 Installing dependencies..."
  cd lib/api_client
  flutter pub get
  cd ../..
  flutter pub get
  
  # Apply temporary patch for null handling (until backend Swagger is fixed)
  echo "🔧 Applying temporary null-handling patch..."
  if [ -f "fix_user_profile_nullability.dart" ]; then
    dart fix_user_profile_nullability.dart
    if [ $? -eq 0 ]; then
      echo "✅ Patch applied successfully"
    else
      echo "⚠️  Warning: Patch failed. You may encounter deserialization errors."
    fi
  else
    echo "⚠️  Warning: Patch script not found. You may encounter null-handling issues."
  fi
  
  echo "✨ Done! Your API client is now up to date."
  echo ""
  echo "⚠️  Important: Review the changes and update your code if needed:"
  echo "   - Check for new enum values"
  echo "   - Check for changed field types"
  echo "   - Update your viewmodels if API signatures changed"
else
  echo "❌ API generation failed!"
  echo "Restoring backup..."
  if [ -d "$BACKUP_DIR" ]; then
    rm -rf lib/api_client
    mv "$BACKUP_DIR" lib/api_client
    echo "✅ Backup restored"
  fi
  exit 1
fi
