#!/bin/zsh

# Script to fix FVM Flutter SDK configuration for Android Studio
# This ensures Android Studio uses the FVM Flutter SDK

echo "🔧 Fixing FVM Flutter SDK configuration for Android Studio..."
echo ""

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
FVM_FLUTTER_SDK="$PROJECT_DIR/.fvm/flutter_sdk"

# Check if FVM symlink exists
if [ ! -L "$FVM_FLUTTER_SDK" ]; then
    echo "❌ Error: FVM Flutter SDK symlink not found at $FVM_FLUTTER_SDK"
    echo "Please run 'fvm install' and 'fvm use 3.38.9' first"
    exit 1
fi

echo "✅ FVM Flutter SDK found at: $FVM_FLUTTER_SDK"
echo ""

# Verify the symlink points to the correct version
FLUTTER_VERSION=$("$FVM_FLUTTER_SDK/bin/flutter" --version | head -n 1)
echo "📱 Flutter version: $FLUTTER_VERSION"
echo ""

# Update .idea/libraries/Dart_SDK.xml to use project-relative path
echo "📝 Updating Dart SDK library configuration..."
cat > "$PROJECT_DIR/.idea/libraries/Dart_SDK.xml" << 'EOF'
<component name="libraryTable">
  <library name="Dart SDK">
    <CLASSES>
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/_internal" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/async" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/cli" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/collection" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/concurrent" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/convert" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/core" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/developer" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/ffi" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/html" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/indexed_db" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/io" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/isolate" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/js" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/js_interop" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/js_interop_unsafe" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/js_util" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/math" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/mirrors" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/svg" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/typed_data" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/web_audio" />
      <root url="file://$PROJECT_DIR$/.fvm/flutter_sdk/bin/cache/dart-sdk/lib/web_gl" />
    </CLASSES>
    <JAVADOC />
    <SOURCES />
  </library>
</component>
EOF

# Create/update .idea/flutter.xml
echo "📝 Creating Flutter SDK configuration..."
cat > "$PROJECT_DIR/.idea/flutter.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="FlutterSettings">
    <option name="sdkPath" value="$PROJECT_DIR$/.fvm/flutter_sdk" />
  </component>
</project>
EOF

echo "✅ Configuration files updated!"
echo ""
echo "📋 Next steps:"
echo "1. Close Android Studio completely"
echo "2. Run: fvm flutter clean && fvm flutter pub get"
echo "3. Reopen Android Studio"
echo "4. Go to Preferences > Languages & Frameworks > Flutter"
echo "5. Set Flutter SDK path to: $FVM_FLUTTER_SDK"
echo "6. Click Apply and OK"
echo ""
echo "💡 Tip: If the setting still reverts, make sure Android Studio has write permissions"
echo "   to the .idea directory and the .idea/workspace.xml file is not read-only."
echo ""
