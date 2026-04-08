#!/bin/bash

# BharatTesting Utilities - Vercel Build Script
set -e

echo "🚀 Starting BharatTesting Utilities build on Vercel..."
echo "Current directory: $(pwd)"

# Define Flutter version and directory
FLUTTER_VERSION="3.29.0"
FLUTTER_DIR="/tmp/flutter"

# Download and install Flutter if not present
if [ ! -d "$FLUTTER_DIR" ]; then
    echo "📦 Installing Flutter $FLUTTER_VERSION..."
    cd /tmp
    curl -L -o flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
    tar xf flutter.tar.xz
    rm flutter.tar.xz
    echo "✅ Flutter installed at $FLUTTER_DIR"
fi

# Add Flutter to PATH
export PATH="$FLUTTER_DIR/bin:$PATH"
export FLUTTER_ROOT="$FLUTTER_DIR"
export FLUTTER_ANALYTICS_DISABLED=true

# Get back to the repository root
# We are currently in /tmp if we installed flutter, or at the original PWD
# Vercel sets the starting directory to the repo root.
cd "$VERCEL_PROJECT_ROOT" 2>/dev/null || cd "$GITHUB_WORKSPACE" 2>/dev/null || echo "Using current directory as fallback"

echo "📁 Checking repository structure..."
ls -F

if [ -d "app" ]; then
    echo "✅ Moving to app directory"
    cd app
elif [ -f "pubspec.yaml" ]; then
    echo "✅ Already in a directory with pubspec.yaml"
else
    echo "❌ Could not locate app directory."
    exit 1
fi

echo "🌐 Configuring Flutter for web..."
flutter config --enable-web --no-analytics

echo "📦 Installing dependencies..."
# Core first if available
if [ -d "../core" ]; then
    echo "📦 Getting core dependencies..."
    cd ../core && flutter pub get && cd ../app
fi
flutter pub get

echo "🏗️  Building Flutter web release..."
# Use canvaskit for best fidelity as per spec
flutter build web --release --web-renderer canvaskit --base-href /

echo "✅ Web build completed successfully!"
