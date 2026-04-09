#!/bin/bash

# BharatTesting - Web Build Integrity Auditor
# This script runs after 'flutter build web' to ensure no deployment-breaking issues.

TARGET_DIR="app/build/web"

echo "🔍 Auditing web build integrity at $TARGET_DIR..."

if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: Build directory not found. Run 'flutter build web' first."
    exit 1
fi

# 1. Check for modern bootstrap
if grep -q "flutter_bootstrap.js" "$TARGET_DIR/index.html"; then
    echo "✅ Modern bootstrap found in index.html"
else
    echo "❌ Error: index.html is missing flutter_bootstrap.js reference!"
    exit 1
fi

# 2. Check for manual service worker registration (should be avoided in 3.24+)
if grep -q "navigator.serviceWorker.register" "$TARGET_DIR/index.html"; then
    # We allow it ONLY if it's our nuclear reset script
    if grep -q "NUCLEAR RESET" "$TARGET_DIR/index.html"; then
        echo "⚠️  Found nuclear reset script. Proceeding with caution."
    else
        echo "❌ Error: Manual service worker registration found. This will conflict with bootstrap!"
        exit 1
    fi
fi

# 3. Check for SEO landing pages
TOOL_PAGES=("indian-data-faker.html" "string-to-json.html" "image-reducer.html" "pdf-merger.html" "document-scanner.html")
for page in "${TOOL_PAGES[@]}"; do
    if [ -f "$TARGET_DIR/$page" ]; then
        echo "✅ SEO page found: $page"
    else
        echo "❌ Error: Missing SEO landing page: $page"
        exit 1
    fi
done

echo "🚀 Build audit passed! Ready for deployment."
exit 0
