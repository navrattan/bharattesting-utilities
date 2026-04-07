#!/bin/bash

# BharatTesting Utilities - Android Release Build Script
# This script builds signed Android release artifacts

set -e

echo "🔵 BharatTesting Android Release Build"
echo "========================================"

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Error: Flutter SDK not found. Please install Flutter first."
    echo "   Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1 | awk '{print $2}')
echo "✅ Flutter version: $FLUTTER_VERSION"

# Ensure we're in the app directory
cd "$(dirname "$0")/../app"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Run code generation
echo "🔄 Running code generation..."
dart run build_runner build --delete-conflicting-outputs

# Check keystore exists
KEYSTORE_PATH="android/bharattesting-release.keystore"
if [ ! -f "$KEYSTORE_PATH" ]; then
    echo "❌ Error: Keystore not found at $KEYSTORE_PATH"
    echo "   Please ensure the keystore was created properly."
    exit 1
fi

# Check key.properties exists
KEY_PROPS_PATH="android/key.properties"
if [ ! -f "$KEY_PROPS_PATH" ]; then
    echo "❌ Error: key.properties not found at $KEY_PROPS_PATH"
    exit 1
fi

echo "✅ Keystore and signing configuration found"

# Build Android App Bundle (AAB) - preferred for Play Store
echo "🏗️  Building Android App Bundle (AAB)..."
flutter build appbundle --release --no-tree-shake-icons

if [ $? -eq 0 ]; then
    echo "✅ AAB build successful!"
    AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
    if [ -f "$AAB_PATH" ]; then
        AAB_SIZE=$(du -h "$AAB_PATH" | cut -f1)
        echo "   📱 AAB size: $AAB_SIZE"
        echo "   📁 Location: $AAB_PATH"
    fi
else
    echo "❌ AAB build failed!"
    exit 1
fi

# Build APKs with ABI splits - for direct distribution
echo "🏗️  Building split APKs..."
flutter build apk --release --split-per-abi --no-tree-shake-icons

if [ $? -eq 0 ]; then
    echo "✅ APK builds successful!"

    # List all generated APKs
    APK_DIR="build/app/outputs/flutter-apk"
    if [ -d "$APK_DIR" ]; then
        echo "   📱 Generated APKs:"
        for apk in "$APK_DIR"/*.apk; do
            if [ -f "$apk" ]; then
                APK_SIZE=$(du -h "$apk" | cut -f1)
                APK_NAME=$(basename "$apk")
                echo "      • $APK_NAME ($APK_SIZE)"
            fi
        done
        echo "   📁 Location: $APK_DIR"
    fi
else
    echo "❌ APK build failed!"
    exit 1
fi

# Build universal APK for testing
echo "🏗️  Building universal APK..."
flutter build apk --release --no-tree-shake-icons

if [ $? -eq 0 ]; then
    echo "✅ Universal APK build successful!"
    UNIVERSAL_APK="build/app/outputs/flutter-apk/app-release.apk"
    if [ -f "$UNIVERSAL_APK" ]; then
        UNIVERSAL_SIZE=$(du -h "$UNIVERSAL_APK" | cut -f1)
        echo "   📱 Universal APK size: $UNIVERSAL_SIZE"
        echo "   📁 Location: $UNIVERSAL_APK"
    fi
else
    echo "❌ Universal APK build failed!"
    exit 1
fi

# Verify signatures
echo "🔐 Verifying APK signatures..."
APK_ANALYZER_PATH="$ANDROID_HOME/cmdline-tools/latest/bin/apkanalyzer"
UNIVERSAL_APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

if [ -f "$APK_ANALYZER_PATH" ] && [ -f "$UNIVERSAL_APK_PATH" ]; then
    echo "   Checking signature for universal APK..."
    $APK_ANALYZER_PATH apk verify "$UNIVERSAL_APK_PATH"
    if [ $? -eq 0 ]; then
        echo "   ✅ APK signature verification passed"
    else
        echo "   ⚠️  APK signature verification failed"
    fi
else
    echo "   ⚠️  APK analyzer not found, skipping verification"
fi

echo ""
echo "🎉 Android release build completed successfully!"
echo ""
echo "📋 Summary:"
echo "   • AAB (Play Store): build/app/outputs/bundle/release/app-release.aab"
echo "   • Universal APK: build/app/outputs/flutter-apk/app-release.apk"
echo "   • Split APKs: build/app/outputs/flutter-apk/app-*-release.apk"
echo ""
echo "🔗 Next steps:"
echo "   1. Test the APK on a real device"
echo "   2. Upload AAB to Google Play Console"
echo "   3. Distribute APKs for direct installation"
echo ""
echo "📱 Installation command:"
echo "   adb install build/app/outputs/flutter-apk/app-release.apk"