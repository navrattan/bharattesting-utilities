#!/bin/bash

# BharatTesting Utilities - Web Deployment Script
# This script deploys the Flutter web app to Vercel

set -e

echo "🌐 BharatTesting Web Deployment"
echo "==============================="

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Error: Flutter SDK not found. Please install Flutter first."
    echo "   Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Check if Vercel CLI is available
if ! command -v vercel &> /dev/null; then
    echo "⚠️  Vercel CLI not found. Install with: npm i -g vercel"
    echo "   This script will still build the web app for manual deployment."
fi

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1 | awk '{print $2}')
echo "✅ Flutter version: $FLUTTER_VERSION"

# Ensure we're in the project root
if [ ! -f "vercel.json" ]; then
    echo "❌ Error: vercel.json not found. Please run this script from the project root."
    exit 1
fi

# Clean and prepare
echo "🧹 Cleaning previous builds..."
cd app
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Run code generation
echo "🔄 Running code generation..."
dart run build_runner build --delete-conflicting-outputs

# Build web release
echo "🏗️  Building Flutter web release..."
flutter build web --release --web-renderer canvaskit --base-href /

if [ $? -eq 0 ]; then
    echo "✅ Web build successful!"

    WEB_BUILD_DIR="build/web"
    if [ -d "$WEB_BUILD_DIR" ]; then
        BUILD_SIZE=$(du -sh "$WEB_BUILD_DIR" | cut -f1)
        echo "   📦 Build size: $BUILD_SIZE"
        echo "   📁 Location: app/$WEB_BUILD_DIR"

        # Check critical files
        if [ -f "$WEB_BUILD_DIR/index.html" ]; then
            echo "   ✅ index.html found"
        else
            echo "   ❌ index.html not found"
            exit 1
        fi

        if [ -f "$WEB_BUILD_DIR/main.dart.js" ]; then
            echo "   ✅ main.dart.js found"
        else
            echo "   ❌ main.dart.js not found"
            exit 1
        fi

        if [ -f "$WEB_BUILD_DIR/flutter_service_worker.js" ]; then
            echo "   ✅ Service worker found"
        else
            echo "   ⚠️  Service worker not found"
        fi
    else
        echo "   ❌ Build directory not found"
        exit 1
    fi
else
    echo "❌ Web build failed!"
    exit 1
fi

cd ..

# Verify deployment configuration
echo ""
echo "🔍 Verifying deployment configuration..."

if [ -f "vercel.json" ]; then
    echo "   ✅ vercel.json found"

    # Check buildCommand
    if grep -q "flutter build web" vercel.json; then
        echo "   ✅ Flutter build command configured"
    else
        echo "   ❌ Flutter build command not configured"
        exit 1
    fi

    # Check outputDirectory
    if grep -q "app/build/web" vercel.json; then
        echo "   ✅ Output directory configured"
    else
        echo "   ❌ Output directory not configured"
        exit 1
    fi
else
    echo "   ❌ vercel.json not found"
    exit 1
fi

# Check web-specific files
echo ""
echo "📄 Checking web-specific files..."

WEB_FILES=(
    "app/web/index.html"
    "app/web/manifest.json"
    "app/web/favicon.png"
    "app/web/icons/"
)

for file in "${WEB_FILES[@]}"; do
    if [ -e "$file" ]; then
        echo "   ✅ $file found"
    else
        echo "   ⚠️  $file not found"
    fi
done

# Test local web server
echo ""
echo "🧪 Testing local web server..."
if command -v python3 &> /dev/null; then
    echo "   🚀 Starting local server on http://localhost:8000"
    echo "   📝 Press Ctrl+C to stop the server"
    echo "   🔗 Test the app before deploying"
    echo ""
    cd app/build/web
    python3 -m http.server 8000 &
    SERVER_PID=$!
    cd ../../..

    # Wait a moment for server to start
    sleep 2

    echo "   ✅ Local server started (PID: $SERVER_PID)"
    echo "   🌐 Open http://localhost:8000 in your browser"
    echo ""

    # Auto-open browser if available
    if command -v open &> /dev/null; then
        open http://localhost:8000
    elif command -v xdg-open &> /dev/null; then
        xdg-open http://localhost:8000
    fi

    echo "   Press Enter to continue with deployment or Ctrl+C to test manually..."
    read -r

    # Stop local server
    kill $SERVER_PID 2>/dev/null || true
    echo "   🛑 Local server stopped"
else
    echo "   ⚠️  Python not found, skipping local server test"
fi

# Deploy with Vercel CLI if available
echo ""
if command -v vercel &> /dev/null; then
    echo "🚀 Deploying to Vercel..."

    # Check if logged in
    if vercel whoami &> /dev/null; then
        echo "   ✅ Logged in to Vercel"
    else
        echo "   🔑 Please log in to Vercel:"
        vercel login
    fi

    # Deploy
    echo "   📤 Starting deployment..."
    vercel deploy --prod

    if [ $? -eq 0 ]; then
        echo "   ✅ Deployment successful!"
        echo "   🌐 Your app is now live at: https://bharattesting.com"
    else
        echo "   ❌ Deployment failed!"
        exit 1
    fi
else
    echo "📝 Manual deployment steps:"
    echo ""
    echo "1. Install Vercel CLI:"
    echo "   npm i -g vercel"
    echo ""
    echo "2. Login to Vercel:"
    echo "   vercel login"
    echo ""
    echo "3. Deploy the project:"
    echo "   vercel deploy --prod"
    echo ""
    echo "4. Configure custom domain in Vercel dashboard:"
    echo "   • Add domain: bharattesting.com"
    echo "   • Configure DNS: CNAME www -> cname.vercel-dns.com"
    echo "   • Configure DNS: A @ -> 76.76.19.19"
    echo ""
    echo "🏗️  Build artifacts ready at: app/build/web"
fi

echo ""
echo "🎉 Web deployment process completed!"
echo ""
echo "🔗 Next steps:"
echo "   1. Verify the deployment at bharattesting.com"
echo "   2. Test all 5 tools in the web app"
echo "   3. Check mobile responsiveness"
echo "   4. Verify PWA installation works"
echo "   5. Test deep links and URL routing"
echo ""
echo "📊 Performance tips:"
echo "   • Enable Vercel Analytics for monitoring"
echo "   • Configure Vercel Edge Network for global CDN"
echo "   • Monitor Core Web Vitals in Vercel dashboard"