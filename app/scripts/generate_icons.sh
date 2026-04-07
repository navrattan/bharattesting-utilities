#!/bin/bash

# Icon generation script for BharatTesting Utilities
# Converts SVG to required PNG formats for all platforms

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$SCRIPT_DIR/../assets/images"
SVG_SOURCE="$ASSETS_DIR/app_icon.svg"

echo "🎨 Generating app icons from SVG..."

# Check if ImageMagick or Inkscape is available
if command -v magick >/dev/null 2>&1; then
    CONVERTER="magick"
elif command -v convert >/dev/null 2>&1; then
    CONVERTER="convert"
elif command -v inkscape >/dev/null 2>&1; then
    CONVERTER="inkscape"
else
    echo "❌ Error: ImageMagick or Inkscape required for icon generation"
    echo "Install with: brew install imagemagick  OR  brew install inkscape"
    exit 1
fi

# Create main app icon (1024x1024)
echo "📱 Creating main app icon (1024x1024)..."
if [ "$CONVERTER" = "inkscape" ]; then
    inkscape "$SVG_SOURCE" --export-type=png --export-filename="$ASSETS_DIR/app_icon.png" -w 1024 -h 1024
else
    $CONVERTER "$SVG_SOURCE" -resize 1024x1024 "$ASSETS_DIR/app_icon.png"
fi

# Create adaptive foreground (432x432 with padding for Android)
echo "🤖 Creating Android adaptive foreground..."
if [ "$CONVERTER" = "inkscape" ]; then
    inkscape "$SVG_SOURCE" --export-type=png --export-filename="$ASSETS_DIR/app_icon_foreground.png" -w 432 -h 432
else
    $CONVERTER "$SVG_SOURCE" -resize 432x432 -background transparent -gravity center -extent 432x432 "$ASSETS_DIR/app_icon_foreground.png"
fi

# Create monochrome version for Android 13+ themed icons
echo "⚫ Creating monochrome icon..."
if [ "$CONVERTER" = "inkscape" ]; then
    # Create monochrome version by converting to grayscale
    inkscape "$SVG_SOURCE" --export-type=png --export-filename="$ASSETS_DIR/app_icon_monochrome.png" -w 432 -h 432
    $CONVERTER "$ASSETS_DIR/app_icon_monochrome.png" -colorspace Gray -fill white -colorize 100% "$ASSETS_DIR/app_icon_monochrome.png"
else
    $CONVERTER "$SVG_SOURCE" -resize 432x432 -colorspace Gray -fill white -colorize 100% "$ASSETS_DIR/app_icon_monochrome.png"
fi

# Create splash branding
echo "✨ Creating splash screen branding..."
cat > "$ASSETS_DIR/splash_branding.svg" << 'EOF'
<svg width="300" height="60" viewBox="0 0 300 60" xmlns="http://www.w3.org/2000/svg">
  <text x="150" y="35" text-anchor="middle" font-family="SF Pro Display, Arial, sans-serif" font-size="24" font-weight="600" fill="#58A6FF">
    BharatTesting Utilities
  </text>
  <text x="150" y="50" text-anchor="middle" font-family="SF Pro Display, Arial, sans-serif" font-size="12" fill="#7D8590">
    5 free, offline developer tools
  </text>
</svg>
EOF

if [ "$CONVERTER" = "inkscape" ]; then
    inkscape "$ASSETS_DIR/splash_branding.svg" --export-type=png --export-filename="$ASSETS_DIR/splash_branding.png" -w 600 -h 120
else
    $CONVERTER "$ASSETS_DIR/splash_branding.svg" -resize 600x120 "$ASSETS_DIR/splash_branding.png"
fi

echo "✅ Icon generation complete!"
echo "📁 Generated files in $ASSETS_DIR:"
echo "   • app_icon.png (1024x1024)"
echo "   • app_icon_foreground.png (432x432)"
echo "   • app_icon_monochrome.png (432x432)"
echo "   • splash_branding.png (600x120)"
echo ""
echo "🚀 Run the following commands to apply:"
echo "   cd app"
echo "   dart run flutter_launcher_icons"
echo "   dart run flutter_native_splash:create"