#!/bin/bash

# BharatTesting Utilities - Manual Vercel Deployment
# Deploy Flutter web build to Vercel manually

set -e

echo "🚀 Deploying BharatTesting Utilities to Vercel..."

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "📦 Installing Vercel CLI..."
    npm i -g vercel
fi

# Check if we have a Flutter web build
if [ ! -f "app/build/web/index.html" ]; then
    echo "❌ Flutter web build not found. Building now..."
    echo "🏗️  Building Flutter web app..."

    cd app
    flutter pub get
    dart run build_runner build --delete-conflicting-outputs || true
    flutter build web --release --web-renderer canvaskit --base-href /
    cd ..

    if [ ! -f "app/build/web/index.html" ]; then
        echo "❌ Build failed!"
        exit 1
    fi
fi

echo "✅ Flutter web build found"

# Navigate to build output
cd app/build/web

# Deploy to Vercel
echo "🌐 Deploying to Vercel..."
vercel deploy --prod

echo "🎉 Deployment completed!"
echo ""
echo "🔗 Your app should now be live at:"
echo "   • Vercel URL: Check the output above"
echo "   • Custom domain: bharattesting.com (if configured)"
echo ""
echo "📝 Next steps:"
echo "   1. Configure bharattesting.com domain in Vercel dashboard"
echo "   2. Test all 5 tools in the web app"
echo "   3. Monitor performance and user feedback"