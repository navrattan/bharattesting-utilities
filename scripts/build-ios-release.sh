#!/bin/bash

# BharatTesting Utilities - iOS Release Build Script
# This script builds iOS release artifacts for App Store and TestFlight

set -e

echo "🍎 BharatTesting iOS Release Build"
echo "=================================="

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Error: Flutter SDK not found. Please install Flutter first."
    echo "   Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Check if Xcode is available (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v xcodebuild &> /dev/null; then
        echo "❌ Error: Xcode not found. Please install Xcode from the App Store."
        exit 1
    fi
    XCODE_VERSION=$(xcodebuild -version | head -n 1 | awk '{print $2}')
    echo "✅ Xcode version: $XCODE_VERSION"
else
    echo "❌ Error: iOS builds require macOS and Xcode"
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

# Check iOS configuration
IOS_RUNNER_PATH="ios/Runner"
if [ ! -d "$IOS_RUNNER_PATH" ]; then
    echo "❌ Error: iOS Runner directory not found at $IOS_RUNNER_PATH"
    echo "   Please ensure iOS platform is properly configured."
    exit 1
fi

echo "✅ iOS configuration found"

# Install iOS dependencies (CocoaPods)
echo "🍫 Installing CocoaPods dependencies..."
cd ios
if ! command -v pod &> /dev/null; then
    echo "❌ Error: CocoaPods not found. Please install with: sudo gem install cocoapods"
    exit 1
fi

# Clean pod cache and reinstall
pod cache clean --all
pod deintegrate || true
pod install --repo-update
cd ..

if [ $? -eq 0 ]; then
    echo "✅ CocoaPods dependencies installed successfully"
else
    echo "❌ Failed to install CocoaPods dependencies"
    exit 1
fi

# Build iOS release
echo "🏗️  Building iOS release..."
flutter build ios --release --no-tree-shake-icons

if [ $? -eq 0 ]; then
    echo "✅ iOS build successful!"

    # Find the generated .app file
    APP_PATH="build/ios/iphoneos/Runner.app"
    if [ -d "$APP_PATH" ]; then
        APP_SIZE=$(du -sh "$APP_PATH" | cut -f1)
        echo "   📱 App bundle size: $APP_SIZE"
        echo "   📁 Location: $APP_PATH"
    fi
else
    echo "❌ iOS build failed!"
    exit 1
fi

# Check signing configuration
echo "🔐 Checking signing configuration..."
XCODEPROJ_PATH="ios/Runner.xcodeproj"
if [ -f "$XCODEPROJ_PATH/project.pbxproj" ]; then
    if grep -q "DEVELOPMENT_TEAM" "$XCODEPROJ_PATH/project.pbxproj"; then
        TEAM_ID=$(grep "DEVELOPMENT_TEAM" "$XCODEPROJ_PATH/project.pbxproj" | head -1 | sed 's/.*= \(.*\);/\1/' | tr -d ' ')
        if [ "$TEAM_ID" != "\"\"" ] && [ "$TEAM_ID" != '""' ]; then
            echo "   ✅ Development team configured: $TEAM_ID"
        else
            echo "   ⚠️  Development team not configured - manual signing required"
        fi
    else
        echo "   ⚠️  Development team not found - manual signing required"
    fi

    if grep -q "CODE_SIGN_STYLE.*Automatic" "$XCODEPROJ_PATH/project.pbxproj"; then
        echo "   ✅ Automatic signing enabled"
    else
        echo "   ⚠️  Manual signing configured"
    fi
else
    echo "   ⚠️  Xcode project file not found"
fi

# Archive for distribution (if certificates are available)
echo "📦 Attempting to create archive for distribution..."
cd ios

# Check for valid certificates
CERTIFICATE_CHECK=$(security find-identity -v -p codesigning | grep "iPhone Distribution" | wc -l | tr -d ' ')
if [ "$CERTIFICATE_CHECK" -gt 0 ]; then
    echo "   ✅ Distribution certificate found"

    # Create archive
    echo "   🏗️  Creating archive..."
    xcodebuild -workspace Runner.xcworkspace \
               -scheme Runner \
               -configuration Release \
               -destination generic/platform=iOS \
               -archivePath build/Runner.xcarchive \
               archive

    if [ $? -eq 0 ]; then
        echo "   ✅ Archive created successfully"
        ARCHIVE_PATH="build/Runner.xcarchive"
        if [ -d "$ARCHIVE_PATH" ]; then
            ARCHIVE_SIZE=$(du -sh "$ARCHIVE_PATH" | cut -f1)
            echo "   📱 Archive size: $ARCHIVE_SIZE"
            echo "   📁 Location: ios/$ARCHIVE_PATH"
        fi

        # Export for App Store
        echo "   📤 Exporting for App Store..."
        # Note: This requires proper provisioning profiles and certificates
        echo "   ⚠️  App Store export requires manual configuration in Xcode"
        echo "   📝 Use Xcode -> Product -> Archive -> Distribute App"
    else
        echo "   ❌ Archive creation failed"
    fi
else
    echo "   ⚠️  No distribution certificate found"
    echo "   📝 For App Store distribution:"
    echo "      1. Join Apple Developer Program"
    echo "      2. Create certificates in Apple Developer Console"
    echo "      3. Configure provisioning profiles"
    echo "      4. Set DEVELOPMENT_TEAM in Xcode"
fi

cd ..

echo ""
echo "🎉 iOS release build completed!"
echo ""
echo "📋 Summary:"
echo "   • iOS .app bundle: build/ios/iphoneos/Runner.app"
if [ -d "ios/build/Runner.xcarchive" ]; then
    echo "   • Xcode archive: ios/build/Runner.xcarchive"
fi
echo ""
echo "🔗 Next steps:"
echo "   1. Test on real device or iOS Simulator"
echo "   2. Configure Apple Developer account and certificates"
echo "   3. Create archive in Xcode: Product > Archive"
echo "   4. Upload to App Store Connect or TestFlight"
echo ""
echo "📱 Simulator testing:"
echo "   1. Open iOS Simulator"
echo "   2. Drag build/ios/iphoneos/Runner.app to simulator"
echo "   3. Or: flutter run --release -d [simulator-id]"