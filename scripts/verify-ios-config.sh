#!/bin/bash

# BharatTesting Utilities - iOS Configuration Verification
# This script verifies that iOS release configuration is set up correctly

set -e

echo "🍎 BharatTesting iOS Configuration Verification"
echo "=============================================="

cd "$(dirname "$0")/../app"

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ iOS builds require macOS"
    echo "   Current OS: $OSTYPE"
    exit 1
fi

echo "✅ Running on macOS"

# Check Xcode installation
echo ""
echo "🔧 Checking Xcode installation..."
if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -n 1 | awk '{print $2}')
    echo "   ✅ Xcode found: $XCODE_VERSION"

    # Check command line tools
    if xcode-select --print-path &> /dev/null; then
        XCODE_PATH=$(xcode-select --print-path)
        echo "   ✅ Command line tools: $XCODE_PATH"
    else
        echo "   ⚠️  Command line tools not configured"
    fi
else
    echo "   ❌ Xcode not found"
    echo "      Please install Xcode from the App Store"
    exit 1
fi

# Check CocoaPods
echo ""
echo "🍫 Checking CocoaPods..."
if command -v pod &> /dev/null; then
    POD_VERSION=$(pod --version)
    echo "   ✅ CocoaPods found: $POD_VERSION"
else
    echo "   ❌ CocoaPods not found"
    echo "      Install with: sudo gem install cocoapods"
    exit 1
fi

# Check iOS project structure
echo ""
echo "📱 Checking iOS project structure..."
IOS_DIR="ios"
if [ -d "$IOS_DIR" ]; then
    echo "   ✅ iOS directory found: $IOS_DIR"

    # Check Runner directory
    if [ -d "$IOS_DIR/Runner" ]; then
        echo "   ✅ Runner directory found"
    else
        echo "   ❌ Runner directory not found"
        exit 1
    fi

    # Check Xcode project
    if [ -d "$IOS_DIR/Runner.xcodeproj" ]; then
        echo "   ✅ Xcode project found"
    else
        echo "   ❌ Xcode project not found"
        exit 1
    fi

    # Check workspace (created by CocoaPods)
    if [ -d "$IOS_DIR/Runner.xcworkspace" ]; then
        echo "   ✅ Xcode workspace found"
    else
        echo "   ⚠️  Xcode workspace not found (run pod install)"
    fi
else
    echo "   ❌ iOS directory not found: $IOS_DIR"
    exit 1
fi

# Check Info.plist
INFO_PLIST_PATH="ios/Runner/Info.plist"
echo ""
echo "📄 Checking Info.plist..."
if [ -f "$INFO_PLIST_PATH" ]; then
    echo "   ✅ Info.plist found: $INFO_PLIST_PATH"

    # Check bundle identifier
    if /usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" "$INFO_PLIST_PATH" 2>/dev/null | grep -q "PRODUCT_BUNDLE_IDENTIFIER"; then
        echo "   ✅ Bundle identifier configured"
    else
        echo "   ⚠️  Bundle identifier may need configuration"
    fi

    # Check permissions
    if /usr/libexec/PlistBuddy -c "Print NSCameraUsageDescription" "$INFO_PLIST_PATH" &>/dev/null; then
        echo "   ✅ Camera permission description found"
    else
        echo "   ❌ Camera permission description not found"
    fi

    if /usr/libexec/PlistBuddy -c "Print NSPhotoLibraryUsageDescription" "$INFO_PLIST_PATH" &>/dev/null; then
        echo "   ✅ Photo library permission description found"
    else
        echo "   ❌ Photo library permission description not found"
    fi

    # Check deep linking
    if /usr/libexec/PlistBuddy -c "Print CFBundleURLTypes" "$INFO_PLIST_PATH" &>/dev/null; then
        echo "   ✅ URL schemes configured for deep linking"
    else
        echo "   ⚠️  URL schemes not configured"
    fi

    # Check associated domains
    if /usr/libexec/PlistBuddy -c "Print com.apple.developer.associated-domains" "$INFO_PLIST_PATH" &>/dev/null; then
        echo "   ✅ Associated domains configured"
    else
        echo "   ⚠️  Associated domains not configured"
    fi
else
    echo "   ❌ Info.plist not found: $INFO_PLIST_PATH"
    exit 1
fi

# Check signing configuration
echo ""
echo "🔐 Checking signing configuration..."
PBXPROJ_PATH="ios/Runner.xcodeproj/project.pbxproj"
if [ -f "$PBXPROJ_PATH" ]; then
    echo "   ✅ Xcode project file found"

    # Check development team
    if grep -q "DEVELOPMENT_TEAM" "$PBXPROJ_PATH"; then
        TEAM_ID=$(grep "DEVELOPMENT_TEAM" "$PBXPROJ_PATH" | head -1 | sed 's/.*= \(.*\);/\1/' | tr -d ' "')
        if [ -n "$TEAM_ID" ] && [ "$TEAM_ID" != "" ]; then
            echo "   ✅ Development team configured: $TEAM_ID"
        else
            echo "   ⚠️  Development team not configured"
        fi
    else
        echo "   ⚠️  Development team configuration not found"
    fi

    # Check code sign style
    if grep -q "CODE_SIGN_STYLE.*Automatic" "$PBXPROJ_PATH"; then
        echo "   ✅ Automatic signing enabled"
    elif grep -q "CODE_SIGN_STYLE.*Manual" "$PBXPROJ_PATH"; then
        echo "   ⚠️  Manual signing configured"
    else
        echo "   ⚠️  Signing style not explicitly configured"
    fi

    # Check bundle identifier
    if grep -q "PRODUCT_BUNDLE_IDENTIFIER.*com.btqaservices.bharattesting" "$PBXPROJ_PATH"; then
        echo "   ✅ Bundle identifier set to com.btqaservices.bharattesting"
    else
        echo "   ⚠️  Bundle identifier may need manual configuration"
    fi
else
    echo "   ❌ Xcode project file not found"
    exit 1
fi

# Check certificates and provisioning profiles
echo ""
echo "📜 Checking certificates and provisioning profiles..."
DEV_CERTS=$(security find-identity -v -p codesigning | grep "iPhone Developer" | wc -l | tr -d ' ')
DIST_CERTS=$(security find-identity -v -p codesigning | grep "iPhone Distribution" | wc -l | tr -d ' ')

if [ "$DEV_CERTS" -gt 0 ]; then
    echo "   ✅ Development certificates found: $DEV_CERTS"
else
    echo "   ⚠️  No development certificates found"
fi

if [ "$DIST_CERTS" -gt 0 ]; then
    echo "   ✅ Distribution certificates found: $DIST_CERTS"
else
    echo "   ⚠️  No distribution certificates found"
fi

# Check provisioning profiles
PROFILES_DIR="$HOME/Library/MobileDevice/Provisioning Profiles"
if [ -d "$PROFILES_DIR" ]; then
    PROFILE_COUNT=$(find "$PROFILES_DIR" -name "*.mobileprovision" | wc -l | tr -d ' ')
    if [ "$PROFILE_COUNT" -gt 0 ]; then
        echo "   ✅ Provisioning profiles found: $PROFILE_COUNT"
    else
        echo "   ⚠️  No provisioning profiles found"
    fi
else
    echo "   ⚠️  Provisioning profiles directory not found"
fi

# Check Flutter iOS configuration
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
    echo "   ❌ Flutter not found - builds will require Flutter SDK"
fi

echo ""
echo "🎉 iOS configuration verification completed!"
echo ""

# Summary and recommendations
if [ "$DEV_CERTS" -eq 0 ] || [ "$DIST_CERTS" -eq 0 ]; then
    echo "⚠️  Certificate Setup Required:"
    echo "   1. Join Apple Developer Program ($99/year)"
    echo "   2. Create certificates in Apple Developer Console"
    echo "   3. Download and install certificates"
    echo "   4. Create App ID: com.btqaservices.bharattesting"
    echo "   5. Create provisioning profiles"
    echo "   6. Configure DEVELOPMENT_TEAM in Xcode"
    echo ""
fi

echo "✅ Ready for iOS builds:"
echo "   • Run: ./scripts/build-ios-release.sh"
echo "   • Or: flutter build ios --release"
echo "   • Archive: Open ios/Runner.xcworkspace in Xcode"