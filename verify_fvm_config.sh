#!/bin/zsh

# FVM Configuration Verification Script
# Run this script to verify FVM is correctly configured

echo "🔍 Verifying FVM Configuration..."
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check 1: FVM installed
echo "1️⃣  Checking FVM installation..."
if command -v fvm &> /dev/null; then
    echo "${GREEN}✅ FVM is installed${NC}"
else
    echo "${RED}❌ FVM is not installed${NC}"
    exit 1
fi
echo ""

# Check 2: Global FVM version
echo "2️⃣  Checking global FVM version..."
GLOBAL_VERSION=$(fvm list 2>/dev/null | grep "●" | awk '{print $1}')
if [ -n "$GLOBAL_VERSION" ]; then
    echo "${GREEN}✅ Global version set to: $GLOBAL_VERSION${NC}"
else
    echo "${RED}❌ No global version set${NC}"
fi
echo ""

# Check 3: Project FVM configuration
echo "3️⃣  Checking project FVM configuration..."
if [ -f ".fvm/fvm_config.json" ]; then
    PROJECT_VERSION=$(cat .fvm/fvm_config.json | grep -o '"flutterSdkVersion": *"[^"]*"' | sed 's/"flutterSdkVersion": *"\([^"]*\)"/\1/')
    echo "${GREEN}✅ Project version: $PROJECT_VERSION${NC}"
else
    echo "${YELLOW}⚠️  No project-specific FVM version set${NC}"
fi
echo ""

# Check 4: Flutter SDK symlink
echo "4️⃣  Checking Flutter SDK symlink..."
if [ -L ".fvm/flutter_sdk" ]; then
    SYMLINK_TARGET=$(readlink .fvm/flutter_sdk)
    echo "${GREEN}✅ Symlink exists: .fvm/flutter_sdk → $SYMLINK_TARGET${NC}"
else
    echo "${RED}❌ Flutter SDK symlink not found${NC}"
fi
echo ""

# Check 5: Shell PATH configuration
echo "5️⃣  Checking shell PATH..."
if grep -q "fvm/default/bin" ~/.zshrc; then
    echo "${GREEN}✅ FVM path is in ~/.zshrc${NC}"
else
    echo "${YELLOW}⚠️  FVM path not found in ~/.zshrc${NC}"
fi
echo ""

# Check 6: Flutter command location
echo "6️⃣  Checking Flutter command..."
FLUTTER_PATH=$(which flutter 2>/dev/null)
if [ -n "$FLUTTER_PATH" ]; then
    if [[ "$FLUTTER_PATH" == *"fvm"* ]]; then
        echo "${GREEN}✅ Flutter command uses FVM: $FLUTTER_PATH${NC}"
    else
        echo "${YELLOW}⚠️  Flutter command NOT using FVM: $FLUTTER_PATH${NC}"
        echo "${YELLOW}   Run 'source ~/.zshrc' or open a new terminal${NC}"
    fi
else
    echo "${RED}❌ Flutter command not found${NC}"
fi
echo ""

# Check 7: Flutter version
echo "7️⃣  Checking Flutter version..."
if command -v fvm &> /dev/null; then
    FLUTTER_VERSION=$(fvm flutter --version 2>/dev/null | head -n 1)
    if [ -n "$FLUTTER_VERSION" ]; then
        echo "${GREEN}✅ $FLUTTER_VERSION${NC}"
    else
        echo "${RED}❌ Could not get Flutter version${NC}"
    fi
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "For Android Studio, use this Flutter SDK path:"
echo "${YELLOW}/Users/ayodeji/Desktop/untitled folder/diet_lenz/.fvm/flutter_sdk${NC}"
echo ""
echo "Steps:"
echo "1. Open Android Studio"
echo "2. Preferences → Languages & Frameworks → Flutter"
echo "3. Set Flutter SDK path to the path above"
echo "4. Click Apply → OK"
echo "5. RESTART Android Studio completely"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
