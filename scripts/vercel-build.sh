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
        echo "⬇️  Downloading Linux x64 Flutter $FLUTTER_VERSION stable bundle..."
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

echo "📦 Getting core dependencies..."
if [ -d "../core" ]; then
    (cd ../core && flutter pub get)
fi
flutter pub get

echo "🌍 Generating localizations..."
flutter gen-l10n

echo "⚙️  Generating code with build_runner..."
# Use --quiet and limit memory if possible for build_runner
dart run build_runner build --delete-conflicting-outputs

echo "🏗️  Building Flutter web release..."
echo "Debug: Current directory: $(pwd)"
echo "Debug: Available memory: $(free -h 2>/dev/null || echo 'Memory info not available')"
echo "Debug: Flutter version: $(flutter --version --machine 2>/dev/null || flutter --version)"

# Try building with memory-optimized settings first
echo "Attempting Flutter web build with optimized settings..."
if flutter build web --release --base-href / --tree-shake-icons; then
    echo "✅ Optimized build succeeded!"
elif flutter build web --release --base-href / --no-tree-shake-icons; then
    echo "✅ Fallback build succeeded!"
else
    echo "❌ All Flutter web build attempts failed!"
    echo "Checking Flutter doctor for issues..."
    flutter doctor -v || echo "Flutter doctor failed"
    echo "Directory contents:"
    ls -la . || echo "Directory listing failed"
    echo "Pub cache info:"
    flutter pub cache list 2>/dev/null || echo "Pub cache listing failed"
    exit 1
fi

# NEW: Run integrity audit to prevent "Blank Screen" or "Failed to Fetch" issues
echo "🛡️  Running build integrity audit..."
cd "$PROJECT_ROOT"
bash scripts/verify-web-build.sh

# NEW: Generate SEO-friendly landing pages for AI agents
echo "🔍 Generating SEO landing pages for AI agents..."
python3 scripts/generate-seo-pages.py
cp -r public/tools app/build/web/

echo "✅ Web build completed successfully!"
