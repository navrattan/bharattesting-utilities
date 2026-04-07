#!/bin/bash

# BharatTesting Utilities - Vercel Build Script
# Installs Flutter and builds web app for production deployment

set -e

echo "🚀 Starting BharatTesting Utilities build on Vercel..."
echo "Working directory: $(pwd)"
echo "Home directory: $HOME"

# Create necessary directories
mkdir -p $HOME/bin

# Define Flutter version and directory
FLUTTER_VERSION="3.29.0"
FLUTTER_DIR="$HOME/flutter"

# Check if Flutter is already installed
if [ ! -d "$FLUTTER_DIR" ]; then
    echo "📦 Installing Flutter $FLUTTER_VERSION..."

    # Create Flutter directory
    mkdir -p $FLUTTER_DIR

    # Download and install Flutter (with better error handling)
    cd $HOME
    echo "Downloading Flutter..."
    curl -L -o flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

    if [ ! -f flutter.tar.xz ]; then
        echo "❌ Failed to download Flutter"
        exit 1
    fi

    echo "Extracting Flutter..."
    tar xf flutter.tar.xz
    rm flutter.tar.xz

    echo "✅ Flutter $FLUTTER_VERSION installed"
else
    echo "✅ Flutter already installed"
fi

# Add Flutter to PATH
export PATH="$FLUTTER_DIR/bin:$PATH"
export PUB_CACHE="$HOME/.pub-cache"

# Verify Flutter installation
echo "🔍 Verifying Flutter installation..."
which flutter || echo "Flutter not in PATH"
flutter --version || echo "Flutter version check failed"

# Navigate back to project root
cd $VERCEL_PROJECT_DIR

# Enable web support
echo "🌐 Enabling web support..."
flutter config --enable-web --no-analytics

# Install dependencies for core package
echo "📦 Installing core dependencies..."
if [ -d "core" ]; then
    cd core
    flutter pub get --no-precompile
    cd ..
else
    echo "⚠️  Core directory not found"
fi

# Install dependencies for app
echo "📦 Installing app dependencies..."
if [ -d "app" ]; then
    cd app
    flutter pub get --no-precompile

    # Check if build_runner is available
    echo "🔄 Running code generation..."
    dart run build_runner build --delete-conflicting-outputs || echo "⚠️  Code generation skipped"

    # Build web release
    echo "🏗️  Building Flutter web release..."
    flutter build web --release --web-renderer canvaskit --base-href /

    # Verify build output
    if [ -f "build/web/index.html" ]; then
        echo "✅ Web build completed successfully!"
        echo "📁 Build output directory: build/web"
        ls -la build/web/ | head -10
    else
        echo "❌ Web build failed - index.html not found"
        echo "Contents of build directory:"
        ls -la build/ || echo "Build directory not found"
        exit 1
    fi

    cd ..
else
    echo "❌ App directory not found"
    exit 1
fi

echo "🎉 BharatTesting Utilities build completed successfully!"