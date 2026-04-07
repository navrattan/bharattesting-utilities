#!/bin/bash

# BharatTesting Utilities - Final Pre-Launch Verification
# This script performs comprehensive checks before production launch

set -e

echo "🔍 BharatTesting Utilities - Final Verification"
echo "==============================================="

ERRORS=0
WARNINGS=0

# Function to report errors and warnings
report_error() {
    echo "   ❌ ERROR: $1"
    ((ERRORS++))
}

report_warning() {
    echo "   ⚠️  WARNING: $1"
    ((WARNINGS++))
}

report_success() {
    echo "   ✅ $1"
}

# Check project structure
echo ""
echo "📁 Checking project structure..."

REQUIRED_DIRS=(
    "core/lib/src"
    "core/test"
    "app/lib"
    "app/test"
    "app/web"
    "app/android"
    "app/ios"
    ".github/workflows"
    "docs"
    "scripts"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        report_success "Directory $dir exists"
    else
        report_error "Directory $dir missing"
    fi
done

# Check essential files
echo ""
echo "📄 Checking essential files..."

REQUIRED_FILES=(
    "README.md"
    "LICENSE"
    "CONTRIBUTING.md"
    "DEPLOYMENT.md"
    "TASKS.md"
    "core/pubspec.yaml"
    "app/pubspec.yaml"
    "vercel.json"
    ".gitignore"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        report_success "File $file exists"
    else
        report_error "File $file missing"
    fi
done

# Check GitHub configuration
echo ""
echo "🐙 Checking GitHub configuration..."

GITHUB_FILES=(
    ".github/CODEOWNERS"
    ".github/workflows"
    ".github/ISSUE_TEMPLATE"
    ".github/PULL_REQUEST_TEMPLATE.md"
)

for file in "${GITHUB_FILES[@]}"; do
    if [ -e "$file" ]; then
        report_success "GitHub config $file exists"
    else
        report_warning "GitHub config $file missing"
    fi
done

# Check CODEOWNERS content
if [ -f ".github/CODEOWNERS" ]; then
    if grep -q "@navrattan" ".github/CODEOWNERS"; then
        report_success "CODEOWNERS correctly configured with @navrattan"
    else
        report_error "CODEOWNERS missing @navrattan"
    fi
fi

# Check build configuration
echo ""
echo "🏗️  Checking build configuration..."

# Android
if [ -f "app/android/app/build.gradle" ]; then
    report_success "Android build.gradle exists"

    if grep -q "signingConfigs" "app/android/app/build.gradle"; then
        report_success "Android signing configuration found"
    else
        report_error "Android signing configuration missing"
    fi

    if grep -q "com.btqaservices.bharattesting" "app/android/app/build.gradle"; then
        report_success "Android application ID correctly set"
    else
        report_error "Android application ID incorrect"
    fi
else
    report_error "Android build.gradle missing"
fi

# iOS
if [ -f "app/ios/Runner/Info.plist" ]; then
    report_success "iOS Info.plist exists"

    if grep -q "com.btqaservices.bharattesting" "app/ios/Runner/Info.plist"; then
        report_success "iOS bundle identifier correctly set"
    else
        report_error "iOS bundle identifier incorrect"
    fi
else
    report_error "iOS Info.plist missing"
fi

# Web
if [ -f "app/web/index.html" ]; then
    report_success "Web index.html exists"

    if grep -q "BharatTesting Utilities" "app/web/index.html"; then
        report_success "Web app title correctly set"
    else
        report_error "Web app title incorrect"
    fi

    if grep -q "bharattesting.com" "app/web/index.html"; then
        report_success "Web domain configuration found"
    else
        report_warning "Web domain not configured in index.html"
    fi
else
    report_error "Web index.html missing"
fi

# Check scripts
echo ""
echo "🔧 Checking deployment scripts..."

SCRIPTS=(
    "scripts/build-android-release.sh"
    "scripts/build-ios-release.sh"
    "scripts/deploy-web.sh"
    "scripts/verify-android-config.sh"
    "scripts/verify-ios-config.sh"
    "scripts/verify-web-config.sh"
    "scripts/final-verification.sh"
)

for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            report_success "Script $script executable"
        else
            report_warning "Script $script not executable"
        fi
    else
        report_error "Script $script missing"
    fi
done

# Check dependencies
echo ""
echo "📦 Checking dependencies..."

if [ -f "core/pubspec.yaml" ]; then
    if grep -q "build_runner" "core/pubspec.yaml"; then
        report_success "Core build_runner dependency found"
    else
        report_warning "Core build_runner dependency missing"
    fi
fi

if [ -f "app/pubspec.yaml" ]; then
    FLUTTER_DEPS=(
        "riverpod"
        "go_router"
        "camera"
        "google_mlkit_text_recognition"
        "pdf"
        "flutter_highlight"
        "lucide_icons"
    )

    for dep in "${FLUTTER_DEPS[@]}"; do
        if grep -q "$dep" "app/pubspec.yaml"; then
            report_success "Flutter dependency $dep found"
        else
            report_error "Flutter dependency $dep missing"
        fi
    done
fi

# Check version consistency
echo ""
echo "📊 Checking version consistency..."

if [ -f "app/pubspec.yaml" ]; then
    APP_VERSION=$(grep "^version:" "app/pubspec.yaml" | cut -d' ' -f2)
    if [ -n "$APP_VERSION" ]; then
        report_success "App version: $APP_VERSION"
    else
        report_error "App version not found"
    fi
fi

if [ -f "core/pubspec.yaml" ]; then
    CORE_VERSION=$(grep "^version:" "core/pubspec.yaml" | cut -d' ' -f2)
    if [ -n "$CORE_VERSION" ]; then
        report_success "Core version: $CORE_VERSION"
    else
        report_error "Core version not found"
    fi
fi

# Check documentation
echo ""
echo "📚 Checking documentation..."

# README completeness
if [ -f "README.md" ]; then
    DOC_CHECKS=(
        "bharattesting.com:Web app URL"
        "MIT License:License information"
        "Flutter 3.29:Flutter version requirement"
        "btqaservices.bharattesting:App identifier"
        "5 free:App description"
    )

    for check in "${DOC_CHECKS[@]}"; do
        pattern=$(echo "$check" | cut -d: -f1)
        desc=$(echo "$check" | cut -d: -f2)

        if grep -qi "$pattern" "README.md"; then
            report_success "README contains $desc"
        else
            report_warning "README missing $desc"
        fi
    done
fi

# License file
if [ -f "LICENSE" ]; then
    if grep -q "MIT License" "LICENSE"; then
        report_success "MIT License file correct"
    else
        report_error "License file incorrect"
    fi
else
    report_error "LICENSE file missing"
fi

# Check security configuration
echo ""
echo "🔐 Checking security configuration..."

# Gitignore sensitive files
if [ -f ".gitignore" ]; then
    GITIGNORE_PATTERNS=(
        "*.keystore"
        "key.properties"
        ".env"
        "local.properties"
    )

    for pattern in "${GITIGNORE_PATTERNS[@]}"; do
        if grep -q "$pattern" ".gitignore"; then
            report_success "Gitignore excludes $pattern"
        else
            report_warning "Gitignore missing $pattern"
        fi
    done
fi

# Android ProGuard rules
if [ -f "app/android/app/proguard-rules.pro" ]; then
    if grep -q "opencv" "app/android/app/proguard-rules.pro"; then
        report_success "ProGuard rules for OpenCV found"
    else
        report_warning "ProGuard rules for OpenCV missing"
    fi
fi

# Check UI/UX requirements
echo ""
echo "🎨 Checking UI/UX requirements..."

# Check for BTQA footer requirement
if [ -f "app/lib/shared/widgets/btqa_footer.dart" ]; then
    report_success "BTQA footer widget exists"
else
    report_warning "BTQA footer widget missing"
fi

# Check for disclaimer requirement
if find app/lib -name "*.dart" -exec grep -l "synthetic.*fraud" {} \; | grep -q .; then
    report_success "Data faker disclaimer found"
else
    report_warning "Data faker disclaimer missing"
fi

# Performance and build checks
echo ""
echo "⚡ Checking performance configuration..."

# Web build optimization
if [ -f "vercel.json" ]; then
    if grep -q "canvaskit" "vercel.json"; then
        report_success "CanvasKit renderer configured"
    else
        report_warning "CanvasKit renderer not configured"
    fi

    if grep -q "Cache-Control" "vercel.json"; then
        report_success "Web caching configured"
    else
        report_warning "Web caching not configured"
    fi
fi

# Android optimization
if [ -f "app/android/app/build.gradle" ]; then
    if grep -q "minifyEnabled true" "app/android/app/build.gradle"; then
        report_success "Android minification enabled"
    else
        report_warning "Android minification not enabled"
    fi

    if grep -q "shrinkResources true" "app/android/app/build.gradle"; then
        report_success "Android resource shrinking enabled"
    else
        report_warning "Android resource shrinking not enabled"
    fi
fi

# Final summary
echo ""
echo "📊 VERIFICATION SUMMARY"
echo "======================"
report_success "Checks completed"

if [ $ERRORS -gt 0 ]; then
    echo ""
    echo "❌ $ERRORS ERRORS found - Must fix before launch!"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo ""
    echo "⚠️  $WARNINGS WARNINGS found - Recommended to fix"
    echo "✅ No critical errors - Safe to launch"
    exit 0
else
    echo ""
    echo "🎉 ALL CHECKS PASSED!"
    echo "✅ Project is ready for production launch"
    echo ""
    echo "🚀 Ready to deploy:"
    echo "   • Web: ./scripts/deploy-web.sh"
    echo "   • Android: ./scripts/build-android-release.sh"
    echo "   • iOS: ./scripts/build-ios-release.sh"
    echo ""
    echo "🌐 Production URL: https://bharattesting.com"
    exit 0
fi