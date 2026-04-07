#!/bin/bash

# BharatTesting Utilities - Vercel Build Script
# Installs Flutter and builds web app for production deployment

set -e

echo "🚀 Starting BharatTesting Utilities build on Vercel..."

# Define Flutter version and directory
FLUTTER_VERSION="3.29.0"
FLUTTER_DIR="$HOME/flutter"

# Check if Flutter is already installed
if [ ! -d "$FLUTTER_DIR" ]; then
    echo "📦 Installing Flutter $FLUTTER_VERSION..."

    # Download and install Flutter
    cd $HOME
    curl -s -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz
    tar xf flutter.tar.xz
    rm flutter.tar.xz

    echo "✅ Flutter $FLUTTER_VERSION installed"
else
    echo "✅ Flutter already installed"
fi

# Add Flutter to PATH
export PATH="$FLUTTER_DIR/bin:$PATH"

# Verify Flutter installation
echo "🔍 Verifying Flutter installation..."
flutter --version

# Enable web support (just in case)
flutter config --enable-web

# Install dependencies for core package
echo "📦 Installing core dependencies..."
cd core
flutter pub get
cd ..

# Install dependencies for app
echo "📦 Installing app dependencies..."
cd app
flutter pub get

# Run code generation
echo "🔄 Running code generation..."
dart run build_runner build --delete-conflicting-outputs

# Build web release
echo "🏗️  Building Flutter web release..."
flutter build web --release --web-renderer canvaskit --base-href /

# Verify build output
if [ -f "build/web/index.html" ]; then
    echo "✅ Web build completed successfully!"
    echo "📁 Build output directory: build/web"
    ls -la build/web/
else
    echo "❌ Web build failed - index.html not found"
    exit 1
fi

echo "🎉 BharatTesting Utilities build completed successfully!"