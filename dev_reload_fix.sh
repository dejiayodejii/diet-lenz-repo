#!/bin/bash
# Quick fix for hot reload issues during development

echo "Clearing Flutter and Gradle caches..."

# Clear Flutter build
flutter clean

# Clear Gradle cache (Android specific)
rm -rf build/
rm -rf android/.gradle
rm -rf android/app/build

# Clear pub cache for this project
rm -rf .dart_tool/

# Reinstall dependencies
flutter pub get

# For iOS (uncomment if testing on iOS)
# rm -rf ios/Pods ios/Podfile.lock
# cd ios && pod install && cd ..

echo "✓ Caches cleared. Run 'flutter run' to start fresh."
