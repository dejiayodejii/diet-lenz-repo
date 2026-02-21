# FVM Flutter SDK Configuration Fix for Android Studio

## Problem
Android Studio keeps reverting the Flutter SDK path back to the old version even after changing it in **Settings > Languages & Frameworks > Flutter**.

## Root Cause
Android Studio stores the Flutter SDK path in multiple configuration files within the `.idea` directory. When these files use absolute paths (like `/Users/ayodeji/fvm/versions/3.38.9`) instead of project-relative paths, Android Studio may not persist the changes correctly.

## Solution Applied
I've fixed this issue by updating the following configuration files to use **project-relative paths** (`$PROJECT_DIR$/.fvm/flutter_sdk`):

### 1. ✅ Updated Files

#### `.idea/libraries/Dart_SDK.xml`
- Changed all Dart SDK paths from absolute paths to use `$PROJECT_DIR$/.fvm/flutter_sdk`
- This ensures the Dart SDK always points to the FVM symlink

#### `.idea/flutter.xml` (Created)
- New file that explicitly sets the Flutter SDK path
- Uses `$PROJECT_DIR$/.fvm/flutter_sdk` for portability

#### `.idea/workspace.xml`
- Added Flutter SDK settings component
- Added SDK paths to the PropertiesComponent

#### `.vscode/settings.json`
- Updated `dart.flutterSdkPath` to use `.fvm/flutter_sdk` (the symlink)
- This ensures VS Code also uses the correct FVM version

### 2. 🛠️ Helper Script Created

I've created `fix_fvm_android_studio.sh` that you can run anytime to restore these settings if they get corrupted.

## Steps to Complete the Fix

### Step 1: Close Android Studio
**IMPORTANT:** Completely quit Android Studio (not just close the window).

```bash
# On macOS, you can use:
osascript -e 'quit app "Android Studio"'
```

### Step 2: Clean and Update Dependencies
```bash
cd "/Users/ayodeji/Desktop/untitled folder/diet_lenz"
fvm flutter clean
fvm flutter pub get
```

### Step 3: Reopen Android Studio
1. Open Android Studio
2. Open your project
3. Go to **Android Studio > Preferences** (or **Settings** on other OS)
4. Navigate to **Languages & Frameworks > Flutter**
5. Set the Flutter SDK path to:
   ```
   /Users/ayodeji/Desktop/untitled folder/diet_lenz/.fvm/flutter_sdk
   ```
6. Click **Apply** then **OK**

### Step 4: Verify the Configuration
1. Close and reopen the Flutter settings
2. The path should remain as `.fvm/flutter_sdk`
3. If it reverts, check the troubleshooting section below

## Troubleshooting

### If Settings Still Revert

#### 1. Check File Permissions
```bash
# Make sure .idea directory is writable
ls -la .idea/

# If files have @ symbol (extended attributes), clear them:
xattr -c .idea/workspace.xml
xattr -c .idea/flutter.xml
xattr -c .idea/libraries/Dart_SDK.xml
```

#### 2. Check for Multiple Android Studio Instances
- Make sure no other Android Studio windows are open
- Check Activity Monitor for any lingering Android Studio processes

#### 3. Invalidate Caches
In Android Studio:
1. Go to **File > Invalidate Caches...**
2. Select **Invalidate and Restart**

#### 4. Re-run the Fix Script
```bash
./fix_fvm_android_studio.sh
```

#### 5. Check FVM Configuration
```bash
# Verify FVM is properly configured
fvm list
fvm flutter --version

# Reinstall the Flutter version if needed
fvm install 3.38.9
fvm use 3.38.9
```

### If You Get "Flutter SDK not found" Error

This usually means the symlink is broken. Fix it with:
```bash
cd "/Users/ayodeji/Desktop/untitled folder/diet_lenz"
rm -rf .fvm/flutter_sdk
fvm use 3.38.9
```

## Why This Approach Works

1. **Project-Relative Paths**: Using `$PROJECT_DIR$/.fvm/flutter_sdk` makes the configuration portable and prevents Android Studio from trying to resolve absolute paths that may not exist.

2. **Symlink Usage**: The `.fvm/flutter_sdk` is a symlink that FVM manages. It always points to the correct Flutter version, so even if you change versions with `fvm use`, Android Studio will automatically use the new version.

3. **Multiple Configuration Points**: Android Studio reads Flutter SDK settings from multiple places. By updating all of them, we ensure consistency.

## Verification Commands

```bash
# Check FVM version
fvm --version

# Check Flutter version through FVM
fvm flutter --version

# Verify symlink
ls -la .fvm/flutter_sdk

# Check which Flutter is being used
which flutter
```

## Expected Output

When you run `fvm flutter --version`, you should see:
```
Flutter 3.38.9 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 67323de285 (6 days ago) • 2026-01-28 13:43:12 -0800
Engine • hash 5eb06b7ad5bb8cbc22c5230264c7a00ceac7674b (revision 587c18f873) (7 days ago) • 2026-01-27 23:23:03.000Z
Tools • Dart 3.10.8 • DevTools 2.51.1
```

## Additional Notes

- **Always use FVM commands**: When running Flutter commands, prefix them with `fvm`, e.g., `fvm flutter run`
- **Terminal configuration**: If you want to use `flutter` directly without the `fvm` prefix, add the FVM global bin to your PATH
- **Team collaboration**: These changes are safe to commit to git (except `.idea/workspace.xml` which is usually gitignored)

## Related Files Modified

- ✅ `.idea/libraries/Dart_SDK.xml` - Updated Dart SDK paths
- ✅ `.idea/flutter.xml` - Created with Flutter SDK configuration
- ✅ `.idea/workspace.xml` - Added Flutter SDK settings
- ✅ `.vscode/settings.json` - Updated to use symlink path
- ✅ `fix_fvm_android_studio.sh` - Created helper script

---

**Last Updated**: February 4, 2026
**Flutter Version**: 3.38.9 (via FVM)
**Android Studio**: 2024.x compatible
