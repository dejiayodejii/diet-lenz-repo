#!/bin/bash

# Regenerate API Client from Swagger Specification
# Usage: ./regenerate_api.sh [swagger-url-or-file]

set -u

echo "🔄 Regenerating API Client..."

# Default Swagger URL (update this with your actual endpoint)
SWAGGER_SOURCE="${1:-https://diet-lenz-stagingapi-d3mbl.ondigitalocean.app/v3/api-docs}"
CLIENT_DIR="packages/openapi_client"
NEXT_DIR="packages/openapi_client_next"
BACKUP_ROOT="archive/generated_api_clients"
BACKUP_DIR="$BACKUP_ROOT/api_client_backup_latest"

echo "📥 Source: $SWAGGER_SOURCE"

mkdir -p "$BACKUP_ROOT"
rm -rf "$NEXT_DIR"

# Generate new API client
echo "🔨 Generating new API client..."
npx @openapitools/openapi-generator-cli generate \
  -i "$SWAGGER_SOURCE" \
  -g dart \
  -o "$NEXT_DIR" \
  --additional-properties=pubName=openapi,pubAuthor=DietLenz,pubAuthorEmail=support@dietlenz.com \
  --skip-validate-spec

if [ $? -eq 0 ]; then
  echo "✅ API client generated successfully!"

  # Keep only one backup: the previous generated client.
  if [ -d "$CLIENT_DIR" ]; then
    echo "📦 Backing up current API client..."
    rm -rf "$BACKUP_DIR"
    mv "$CLIENT_DIR" "$BACKUP_DIR"
    echo "✅ Backup saved to: $BACKUP_DIR"
  fi

  mv "$NEXT_DIR" "$CLIENT_DIR"
  
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

  rm -rf "$CLIENT_DIR/.dart_tool" "$CLIENT_DIR/pubspec.lock"

  # Install root dependencies so the path package is resolved.
  echo "📦 Installing dependencies..."
  if command -v fvm >/dev/null 2>&1; then
    fvm flutter pub get
  else
    flutter pub get
  fi
  
  echo "✨ Done! Your API client is now up to date."
  echo ""
  echo "⚠️  Important: Review the changes and update your code if needed:"
  echo "   - Check for new enum values"
  echo "   - Check for changed field types"
  echo "   - Update your viewmodels if API signatures changed"
else
  echo "❌ API generation failed!"
  rm -rf "$NEXT_DIR"
  echo "Current API client left unchanged."
  exit 1
fi
