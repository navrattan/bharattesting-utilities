#!/bin/bash

# BharatTesting Utilities - Android Configuration Verification
# This script verifies that Android release configuration is set up correctly

set -e

echo "🔵 BharatTesting Android Configuration Verification"
echo "=================================================="

cd "$(dirname "$0")/../app"

# Check keystore
KEYSTORE_PATH="android/bharattesting-release.keystore"
echo "🔐 Checking keystore..."
if [ -f "$KEYSTORE_PATH" ]; then
    echo "   ✅ Keystore found at: $KEYSTORE_PATH"

    # Check keystore validity
    if command -v keytool &> /dev/null; then
        echo "   🔍 Verifying keystore contents..."
        keytool -list -v -keystore "$KEYSTORE_PATH" -storepass bt@2024release | head -20
        echo "   ✅ Keystore verification completed"
    else
        echo "   ⚠️  keytool not found, skipping keystore verification"
    fi
else
    echo "   ❌ Keystore not found at: $KEYSTORE_PATH"
    exit 1
fi

# Check key.properties
KEY_PROPS_PATH="android/key.properties"
echo ""
echo "🔑 Checking key.properties..."
if [ -f "$KEY_PROPS_PATH" ]; then
    echo "   ✅ key.properties found at: $KEY_PROPS_PATH"
    echo "   📄 Contents (without sensitive data):"
    sed 's/Password=.*/Password=***REDACTED***/g' "$KEY_PROPS_PATH" | sed 's/storeFile=.*/storeFile=bharattesting-release.keystore/g'
else
    echo "   ❌ key.properties not found at: $KEY_PROPS_PATH"
    exit 1
fi

# Check build.gradle signing configuration
BUILD_GRADLE_PATH="android/app/build.gradle"
echo ""
echo "🏗️  Checking build.gradle signing configuration..."
if [ -f "$BUILD_GRADLE_PATH" ]; then
    echo "   ✅ build.gradle found at: $BUILD_GRADLE_PATH"

    if grep -q "signingConfigs" "$BUILD_GRADLE_PATH"; then
        echo "   ✅ Signing configuration found"
    else
        echo "   ❌ Signing configuration not found in build.gradle"
        exit 1
    fi

    if grep -q "signingConfig signingConfigs.release" "$BUILD_GRADLE_PATH"; then
        echo "   ✅ Release signing configuration applied"
    else
        echo "   ❌ Release signing configuration not applied"
        exit 1
    fi
else
    echo "   ❌ build.gradle not found at: $BUILD_GRADLE_PATH"
    exit 1
fi

# Check AndroidManifest.xml
MANIFEST_PATH="android/app/src/main/AndroidManifest.xml"
echo ""
echo "📱 Checking AndroidManifest.xml..."
if [ -f "$MANIFEST_PATH" ]; then
    echo "   ✅ AndroidManifest.xml found at: $MANIFEST_PATH"

    # Check application ID
    if grep -q "com.btqaservices.bharattesting" "$MANIFEST_PATH"; then
        echo "   ✅ Application ID correctly set to com.btqaservices.bharattesting"
    else
        echo "   ⚠️  Application ID not found or incorrect"
    fi

    # Check permissions
    if grep -q "android.permission.CAMERA" "$MANIFEST_PATH"; then
        echo "   ✅ Camera permission declared"
    else
        echo "   ❌ Camera permission not found"
    fi
else
    echo "   ❌ AndroidManifest.xml not found at: $MANIFEST_PATH"
    exit 1
fi

# Check ProGuard rules
PROGUARD_PATH="android/app/proguard-rules.pro"
echo ""
echo "🛡️  Checking ProGuard configuration..."
if [ -f "$PROGUARD_PATH" ]; then
    echo "   ✅ ProGuard rules found at: $PROGUARD_PATH"

    if grep -q "opencv" "$PROGUARD_PATH"; then
        echo "   ✅ OpenCV ProGuard rules found"
    else
        echo "   ⚠️  OpenCV ProGuard rules not found"
    fi

    if grep -q "mlkit" "$PROGUARD_PATH"; then
        echo "   ✅ ML Kit ProGuard rules found"
    else
        echo "   ⚠️  ML Kit ProGuard rules not found"
    fi
else
    echo "   ❌ ProGuard rules not found at: $PROGUARD_PATH"
    exit 1
fi

# Check if Flutter is available for actual build test
echo ""
echo "🔧 Checking Flutter environment..."
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1 | awk '{print $2}')
    echo "   ✅ Flutter found: $FLUTTER_VERSION"

    # Quick dependency check
    echo "   📦 Checking dependencies..."
    flutter pub get &> /dev/null
    if [ $? -eq 0 ]; then
        echo "   ✅ Dependencies resolved successfully"
    else
        echo "   ❌ Failed to resolve dependencies"
        exit 1
    fi
else
    echo "   ⚠️  Flutter not found - builds will require Flutter SDK"
fi

echo ""
echo "🎉 Android release configuration verification completed!"
echo ""
echo "✅ Ready for release builds:"
echo "   • Run: ./scripts/build-android-release.sh"
echo "   • Or: flutter build appbundle --release"
echo "   • Or: flutter build apk --release --split-per-abi"