#!/bin/bash

# BharatTesting Utilities - Web Configuration Verification
# This script verifies that web deployment configuration is set up correctly

set -e

echo "🌐 BharatTesting Web Configuration Verification"
echo "=============================================="

# Check Flutter web support
echo "🔧 Checking Flutter web support..."
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1 | awk '{print $2}')
    echo "   ✅ Flutter found: $FLUTTER_VERSION"

    # Check web support
    if flutter config | grep -q "enable-web: true"; then
        echo "   ✅ Flutter web support enabled"
    else
        echo "   ⚠️  Flutter web support may not be enabled"
        echo "      Enable with: flutter config --enable-web"
    fi
else
    echo "   ❌ Flutter not found"
    exit 1
fi

# Check project structure
echo ""
echo "📁 Checking project structure..."
if [ -d "app/web" ]; then
    echo "   ✅ Web directory found: app/web"
else
    echo "   ❌ Web directory not found: app/web"
    echo "      Create with: flutter create --platform web ."
    exit 1
fi

# Check web files
echo ""
echo "📄 Checking web files..."
WEB_FILES=(
    "app/web/index.html:HTML entry point"
    "app/web/manifest.json:PWA manifest"
    "app/web/favicon.png:Favicon"
    "app/web/icons/:App icons directory"
    "app/web/apple-touch-icon.png:iOS home screen icon"
    "app/web/browserconfig.xml:Windows tile config"
    "app/web/robots.txt:SEO robots file"
    "app/web/sitemap.xml:SEO sitemap"
)

for item in "${WEB_FILES[@]}"; do
    file=$(echo "$item" | cut -d: -f1)
    desc=$(echo "$item" | cut -d: -f2)

    if [ -e "$file" ]; then
        echo "   ✅ $file ($desc)"
    else
        echo "   ❌ $file not found ($desc)"
    fi
done

# Check index.html content
echo ""
echo "🔍 Checking index.html configuration..."
INDEX_HTML="app/web/index.html"
if [ -f "$INDEX_HTML" ]; then
    echo "   ✅ index.html found"

    # Check meta tags
    if grep -q "og:title" "$INDEX_HTML"; then
        echo "   ✅ OpenGraph meta tags found"
    else
        echo "   ⚠️  OpenGraph meta tags not found"
    fi

    if grep -q "twitter:card" "$INDEX_HTML"; then
        echo "   ✅ Twitter Card meta tags found"
    else
        echo "   ⚠️  Twitter Card meta tags not found"
    fi

    if grep -q "manifest.json" "$INDEX_HTML"; then
        echo "   ✅ PWA manifest linked"
    else
        echo "   ⚠️  PWA manifest not linked"
    fi

    if grep -q "service_worker.js" "$INDEX_HTML"; then
        echo "   ✅ Service worker registration found"
    else
        echo "   ⚠️  Service worker registration not found"
    fi
else
    echo "   ❌ index.html not found"
fi

# Check PWA manifest
echo ""
echo "📱 Checking PWA manifest..."
MANIFEST="app/web/manifest.json"
if [ -f "$MANIFEST" ]; then
    echo "   ✅ manifest.json found"

    # Check manifest content
    if command -v jq &> /dev/null; then
        if jq -e '.name' "$MANIFEST" &> /dev/null; then
            APP_NAME=$(jq -r '.name' "$MANIFEST")
            echo "   ✅ App name: $APP_NAME"
        else
            echo "   ⚠️  App name not found in manifest"
        fi

        if jq -e '.start_url' "$MANIFEST" &> /dev/null; then
            START_URL=$(jq -r '.start_url' "$MANIFEST")
            echo "   ✅ Start URL: $START_URL"
        else
            echo "   ⚠️  Start URL not found in manifest"
        fi

        if jq -e '.display' "$MANIFEST" &> /dev/null; then
            DISPLAY=$(jq -r '.display' "$MANIFEST")
            echo "   ✅ Display mode: $DISPLAY"
        else
            echo "   ⚠️  Display mode not found in manifest"
        fi

        if jq -e '.shortcuts' "$MANIFEST" &> /dev/null; then
            SHORTCUTS_COUNT=$(jq '.shortcuts | length' "$MANIFEST")
            echo "   ✅ App shortcuts: $SHORTCUTS_COUNT"
        else
            echo "   ⚠️  App shortcuts not found"
        fi
    else
        echo "   ⚠️  jq not found, skipping manifest content validation"
    fi
else
    echo "   ❌ manifest.json not found"
fi

# Check Vercel configuration
echo ""
echo "🚀 Checking Vercel configuration..."
if [ -f "vercel.json" ]; then
    echo "   ✅ vercel.json found"

    # Check build configuration
    if grep -q "flutter build web" vercel.json; then
        echo "   ✅ Flutter build command configured"
    else
        echo "   ❌ Flutter build command not configured"
    fi

    if grep -q "canvaskit" vercel.json; then
        echo "   ✅ CanvasKit renderer configured"
    else
        echo "   ⚠️  CanvasKit renderer not specified"
    fi

    if grep -q "app/build/web" vercel.json; then
        echo "   ✅ Output directory configured"
    else
        echo "   ❌ Output directory not configured"
    fi

    # Check headers
    if grep -q "Cache-Control" vercel.json; then
        echo "   ✅ Cache headers configured"
    else
        echo "   ⚠️  Cache headers not configured"
    fi

    if grep -q "X-Content-Type-Options" vercel.json; then
        echo "   ✅ Security headers configured"
    else
        echo "   ⚠️  Security headers not configured"
    fi

    # Check SPA routing
    if grep -q "index.html" vercel.json; then
        echo "   ✅ SPA routing configured"
    else
        echo "   ⚠️  SPA routing not configured"
    fi
else
    echo "   ❌ vercel.json not found"
    exit 1
fi

# Check SEO files
echo ""
echo "🔍 Checking SEO configuration..."

# Robots.txt
if [ -f "app/web/robots.txt" ]; then
    echo "   ✅ robots.txt found"
    if grep -q "bharattesting.com" "app/web/robots.txt"; then
        echo "      ✅ Domain configured in robots.txt"
    else
        echo "      ⚠️  Domain not configured in robots.txt"
    fi
else
    echo "   ⚠️  robots.txt not found"
fi

# Sitemap
if [ -f "app/web/sitemap.xml" ]; then
    echo "   ✅ sitemap.xml found"
    if grep -q "bharattesting.com" "app/web/sitemap.xml"; then
        echo "      ✅ Domain configured in sitemap"
    else
        echo "      ⚠️  Domain not configured in sitemap"
    fi
else
    echo "   ⚠️  sitemap.xml not found"
fi

# Check Flutter web dependencies
echo ""
echo "📦 Checking Flutter web dependencies..."
cd app
if [ -f "pubspec.yaml" ]; then
    echo "   ✅ pubspec.yaml found"

    # Check for web-specific dependencies
    if grep -q "go_router" pubspec.yaml; then
        echo "   ✅ GoRouter (web routing) configured"
    else
        echo "   ⚠️  GoRouter not found"
    fi

    if grep -q "url_strategy" pubspec.yaml; then
        echo "   ✅ URL strategy package found"
    else
        echo "   ⚠️  URL strategy package not found"
    fi
else
    echo "   ❌ pubspec.yaml not found"
fi
cd ..

# Test build capability
echo ""
echo "🧪 Testing build capability..."
cd app
flutter pub get &> /dev/null
if [ $? -eq 0 ]; then
    echo "   ✅ Dependencies resolved successfully"

    # Try a dry run build check
    if flutter build web --help &> /dev/null; then
        echo "   ✅ Flutter web build command available"
    else
        echo "   ❌ Flutter web build command not available"
    fi
else
    echo "   ❌ Failed to resolve dependencies"
fi
cd ..

echo ""
echo "🎉 Web configuration verification completed!"
echo ""

# Summary and recommendations
echo "📋 Deployment checklist:"
echo "   □ Verify all web files are present"
echo "   □ Test local build: flutter build web --release"
echo "   □ Test local server: python3 -m http.server (in build/web)"
echo "   □ Install Vercel CLI: npm i -g vercel"
echo "   □ Login to Vercel: vercel login"
echo "   □ Deploy: vercel deploy --prod"
echo "   □ Configure custom domain: bharattesting.com"
echo "   □ Test all 5 tools in production"
echo "   □ Verify PWA installation"
echo "   □ Test responsive design"
echo ""
echo "🚀 Ready to deploy:"
echo "   • Run: ./scripts/deploy-web.sh"
echo "   • Or: vercel deploy --prod"
echo "   • Domain: https://bharattesting.com"