#!/bin/bash

# BharatTesting Utilities - Vercel Build Script
set -e

# Save the initial directory (project root)
PROJECT_ROOT=$(pwd)
echo "🚀 Starting BharatTesting Utilities build on Vercel..."
echo "Project root: $PROJECT_ROOT"

# Define Flutter version and directory
FLUTTER_VERSION="3.29.0"
FLUTTER_DIR="/tmp/flutter"

# Download and install Flutter if not present
if [ ! -d "$FLUTTER_DIR" ]; then
    echo "📦 Installing Flutter $FLUTTER_VERSION..."
    (
        cd /tmp
        curl -L -o flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
        tar xf flutter.tar.xz
        rm flutter.tar.xz
    )
    echo "✅ Flutter installed at $FLUTTER_DIR"
fi

# Add Flutter to PATH
export PATH="$FLUTTER_DIR/bin:$PATH"
export FLUTTER_ROOT="$FLUTTER_DIR"
export FLUTTER_ANALYTICS_DISABLED=true

# CRITICAL: Resolve git ownership issues for Flutter SDK
git config --global --add safe.directory /tmp/flutter
git config --global --add safe.directory "$PROJECT_ROOT"

# Ensure we are back in the project root
cd "$PROJECT_ROOT"

if [ -d "app" ]; then
    echo "✅ Moving to app directory"
    cd app
fi

echo "🌐 Configuring Flutter for web..."
flutter config --enable-web --no-analytics

echo "📦 Installing dependencies..."
if [ -d "../core" ]; then
    echo "📦 Getting core dependencies..."
    (cd ../core && flutter pub get)
fi
flutter pub get

echo "🏗️  Building Flutter web release..."
# Using the most compatible web build command for Flutter 3.29
flutter build web --release --base-href /

echo "✅ Web build completed successfully!"
