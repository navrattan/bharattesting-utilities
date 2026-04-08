#!/bin/bash

# BharatTesting Utilities - Vercel Build Script
set -e

echo "🚀 Starting BharatTesting Utilities build on Vercel..."

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
fi

# Add Flutter to PATH
export PATH="$FLUTTER_DIR/bin:$PATH"
export FLUTTER_ROOT="$FLUTTER_DIR"
export FLUTTER_ANALYTICS_DISABLED=true

# Find and move to app directory
cd "$(dirname "$0")/.."
if [ -d "app" ]; then
    cd app
fi

echo "🌐 Configuring Flutter for web..."
flutter config --enable-web --no-analytics

echo "📦 Installing dependencies..."
# Core first
if [ -d "../core" ]; then
    cd ../core && flutter pub get && cd ../app
fi
flutter pub get

echo "🏗️  Building Flutter web release..."
flutter build web --release --web-renderer canvaskit --base-href /

echo "✅ Web build completed successfully!"
