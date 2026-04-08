#!/bin/bash

# BharatTesting Utilities - Vercel Build Script
# Installs Flutter and builds web app for production deployment

set -e

echo "🚀 Starting BharatTesting Utilities build on Vercel..."
echo "Working directory: $(pwd)"
echo "User: $(whoami)"

# Define Flutter version and directory
FLUTTER_VERSION="3.29.0"
FLUTTER_DIR="/tmp/flutter"

# Fix git configuration for Vercel environment
git config --global --add safe.directory '*'
git config --global user.email "build@vercel.com"
git config --global user.name "Vercel Build"

# Download and install Flutter
if [ ! -d "$FLUTTER_DIR" ]; then
    echo "📦 Installing Flutter $FLUTTER_VERSION..."

    cd /tmp
    echo "Downloading Flutter..."
    curl -L -o flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

    if [ ! -f flutter.tar.xz ]; then
        echo "❌ Failed to download Flutter"
        exit 1
    fi

    echo "Extracting Flutter..."
    tar xf flutter.tar.xz
    rm flutter.tar.xz

    # Fix ownership and permissions
    chmod -R 755 $FLUTTER_DIR

    echo "✅ Flutter $FLUTTER_VERSION installed"
else
    echo "✅ Flutter already available"
fi

# Add Flutter to PATH
export PATH="$FLUTTER_DIR/bin:$PATH"
export PUB_CACHE="/tmp/.pub-cache"
export FLUTTER_ROOT="$FLUTTER_DIR"

# Disable analytics and crash reporting
export FLUTTER_ANALYTICS_DISABLED=true

# Navigate to project directory
cd $PWD

echo "🌐 Configuring Flutter for web..."
flutter config --enable-web --no-analytics --suppress-analytics

echo "📦 Installing app dependencies..."
cd app
flutter pub get --offline

echo "🏗️  Building Flutter web release..."
flutter build web --release --web-renderer canvaskit --source-maps

# Verify build output
if [ -f "build/web/index.html" ]; then
    echo "✅ Web build completed successfully!"
    echo "📁 Build output directory: build/web"
    ls -la build/web/ | head -10

    # Show build size
    echo "📊 Build size:"
    du -sh build/web/
else
    echo "❌ Web build failed - index.html not found"
    exit 1
fi

echo "🎉 BharatTesting Utilities build completed successfully!"