#!/bin/zsh

# Script to verify FVM Flutter SDK configuration
# Run this to check if everything is properly configured

echo "🔍 Verifying FVM Flutter SDK Configuration for Android Studio"
echo "=============================================================="
echo ""

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
FVM_FLUTTER_SDK="$PROJECT_DIR/.fvm/flutter_sdk"

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success_count=0
total_checks=0

check() {
    ((total_checks++))
    if [ $1 -eq 0 ]; then
        echo "${GREEN}✅${NC} $2"
        ((success_count++))
    else
        echo "${RED}❌${NC} $2"
    fi
}

# Check 1: FVM symlink exists
echo "1️⃣  Checking FVM symlink..."
if [ -L "$FVM_FLUTTER_SDK" ]; then
    check 0 "FVM Flutter SDK symlink exists"
    RESOLVED_PATH=$(readlink "$FVM_FLUTTER_SDK")
    echo "   → Points to: $RESOLVED_PATH"
else
    check 1 "FVM Flutter SDK symlink NOT found"
fi
echo ""

# Check 2: Flutter SDK is accessible
echo "2️⃣  Checking Flutter SDK accessibility..."
if [ -f "$FVM_FLUTTER_SDK/bin/flutter" ]; then
    check 0 "Flutter binary is accessible"
    FLUTTER_VERSION=$("$FVM_FLUTTER_SDK/bin/flutter" --version 2>&1 | head -n 1)
    echo "   → Version: $FLUTTER_VERSION"
else
    check 1 "Flutter binary NOT accessible"
fi
echo ""

# Check 3: .idea/flutter.xml exists
echo "3️⃣  Checking Android Studio Flutter configuration..."
if [ -f "$PROJECT_DIR/.idea/flutter.xml" ]; then
    check 0 ".idea/flutter.xml exists"
    if grep -q "\$PROJECT_DIR\$/.fvm/flutter_sdk" "$PROJECT_DIR/.idea/flutter.xml"; then
        check 0 "flutter.xml uses correct path"
    else
        check 1 "flutter.xml does NOT use correct path"
    fi
else
    check 1 ".idea/flutter.xml NOT found"
fi
echo ""

# Check 4: Dart SDK configuration
echo "4️⃣  Checking Dart SDK configuration..."
if [ -f "$PROJECT_DIR/.idea/libraries/Dart_SDK.xml" ]; then
    check 0 ".idea/libraries/Dart_SDK.xml exists"
    if grep -q "\$PROJECT_DIR\$/.fvm/flutter_sdk" "$PROJECT_DIR/.idea/libraries/Dart_SDK.xml"; then
        check 0 "Dart_SDK.xml uses correct path"
    else
        check 1 "Dart_SDK.xml does NOT use correct path"
    fi
else
    check 1 ".idea/libraries/Dart_SDK.xml NOT found"
fi
echo ""

# Check 5: workspace.xml configuration
echo "5️⃣  Checking workspace.xml configuration..."
if [ -f "$PROJECT_DIR/.idea/workspace.xml" ]; then
    check 0 ".idea/workspace.xml exists"
    if grep -q "FlutterSettings" "$PROJECT_DIR/.idea/workspace.xml"; then
        check 0 "workspace.xml contains FlutterSettings"
    else
        check 1 "workspace.xml does NOT contain FlutterSettings"
    fi
else
    check 1 ".idea/workspace.xml NOT found"
fi
echo ""

# Check 6: VSCode configuration
echo "6️⃣  Checking VS Code configuration..."
if [ -f "$PROJECT_DIR/.vscode/settings.json" ]; then
    check 0 ".vscode/settings.json exists"
    if grep -q ".fvm/flutter_sdk" "$PROJECT_DIR/.vscode/settings.json"; then
        check 0 "VSCode settings use correct path"
    else
        check 1 "VSCode settings do NOT use correct path"
    fi
else
    check 1 ".vscode/settings.json NOT found"
fi
echo ""

# Check 7: .fvmrc configuration
echo "7️⃣  Checking FVM configuration..."
if [ -f "$PROJECT_DIR/.fvmrc" ]; then
    check 0 ".fvmrc exists"
    FVM_VERSION=$(cat "$PROJECT_DIR/.fvmrc" | grep "flutter" | grep -o '"[0-9.]*"' | tr -d '"')
    echo "   → FVM version: $FVM_VERSION"
else
    check 1 ".fvmrc NOT found"
fi
echo ""

# Check 8: File permissions
echo "8️⃣  Checking file permissions..."
if [ -w "$PROJECT_DIR/.idea/workspace.xml" ]; then
    check 0 "workspace.xml is writable"
else
    check 1 "workspace.xml is NOT writable"
fi

if [ -w "$PROJECT_DIR/.idea/flutter.xml" ]; then
    check 0 "flutter.xml is writable"
else
    check 1 "flutter.xml is NOT writable"
fi
echo ""

# Check 9: Extended attributes
echo "9️⃣  Checking for extended attributes..."
# Check for problematic extended attributes (ignore harmless com.apple.provenance)
XATTR_WS=$(xattr "$PROJECT_DIR/.idea/workspace.xml" 2>/dev/null | grep -v "com.apple.provenance" | wc -l | tr -d ' ')
XATTR_FL=$(xattr "$PROJECT_DIR/.idea/flutter.xml" 2>/dev/null | grep -v "com.apple.provenance" | wc -l | tr -d ' ')
XATTR_TOTAL=$((XATTR_WS + XATTR_FL))
if [ "$XATTR_TOTAL" -eq 0 ]; then
    check 0 "No problematic extended attributes found"
else
    check 1 "Extended attributes found (may cause issues)"
    echo "   ${YELLOW}⚠️  Run: xattr -c .idea/workspace.xml .idea/flutter.xml${NC}"
fi
echo ""

# Summary
echo "=============================================================="
echo "📊 Summary: ${GREEN}$success_count${NC}/$total_checks checks passed"
echo ""

if [ $success_count -eq $total_checks ]; then
    echo "${GREEN}🎉 All checks passed! Your FVM configuration looks good.${NC}"
    echo ""
    echo "✨ Next steps:"
    echo "   1. Close Android Studio completely"
    echo "   2. Reopen Android Studio"
    echo "   3. Go to Settings > Languages & Frameworks > Flutter"
    echo "   4. Verify the path is: $FVM_FLUTTER_SDK"
    echo "   5. If it shows a different path, manually set it to the above"
    echo ""
elif [ $success_count -ge $((total_checks * 3 / 4)) ]; then
    echo "${YELLOW}⚠️  Most checks passed, but some issues were found.${NC}"
    echo "   Run: ./fix_fvm_android_studio.sh to fix remaining issues"
    echo ""
else
    echo "${RED}❌ Several issues found. Running fix script...${NC}"
    echo ""
    if [ -f "$PROJECT_DIR/fix_fvm_android_studio.sh" ]; then
        echo "🔧 Running fix script..."
        "$PROJECT_DIR/fix_fvm_android_studio.sh"
    else
        echo "${RED}Fix script not found!${NC}"
    fi
fi
