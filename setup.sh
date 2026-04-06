#!/bin/bash
# BharatTesting Utilities — Bootstrap Script
# Run this FIRST to set up the development environment.
# Usage: chmod +x setup.sh && ./setup.sh

set -e

echo "=== BharatTesting Utilities — Environment Setup ==="

# 1. Verify Flutter
echo ""
echo "[1/6] Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo "ERROR: Flutter not found. Install Flutter 3.29+ from https://docs.flutter.dev/get-started/install"
    exit 1
fi

FLUTTER_VERSION=$(flutter --version | head -1)
echo "  Found: $FLUTTER_VERSION"

# 2. Run flutter doctor
echo ""
echo "[2/6] Running flutter doctor..."
flutter doctor --verbose

# 3. Create project structure
echo ""
echo "[3/6] Creating monorepo structure..."
PROJECT_ROOT="bharattesting-utilities"

if [ -d "$PROJECT_ROOT" ]; then
    echo "  Directory $PROJECT_ROOT already exists. Skipping creation."
else
    mkdir -p "$PROJECT_ROOT"
    cd "$PROJECT_ROOT"

    # Core package (pure Dart)
    mkdir -p core/lib/src/data_faker/checksums
    mkdir -p core/lib/src/data_faker/data
    mkdir -p core/lib/src/data_faker/templates
    mkdir -p core/lib/src/image_reducer
    mkdir -p core/lib/src/pdf_merger
    mkdir -p core/lib/src/json_converter
    mkdir -p core/lib/src/document_scanner
    mkdir -p core/test

    # App (Flutter)
    flutter create --org com.btqas --project-name bharattesting_app app
    mkdir -p app/lib/router
    mkdir -p app/lib/theme
    mkdir -p app/lib/shared/widgets
    mkdir -p app/lib/shared/providers
    mkdir -p app/lib/features/home
    mkdir -p app/lib/features/document_scanner/widgets
    mkdir -p app/lib/features/image_reducer/widgets
    mkdir -p app/lib/features/pdf_merger/widgets
    mkdir -p app/lib/features/json_converter/widgets
    mkdir -p app/lib/features/data_faker/widgets
    mkdir -p app/lib/l10n
    mkdir -p app/test/golden/goldens
    mkdir -p app/integration_test
    mkdir -p app/assets/images
    mkdir -p app/assets/data

    # Docs
    mkdir -p docs

    # GitHub
    mkdir -p .github/ISSUE_TEMPLATE
    mkdir -p .github/workflows
    mkdir -p .github/actions/patrol-android

    echo "  Monorepo structure created."
    cd ..
fi

cd "$PROJECT_ROOT"

# 4. Initialize git
echo ""
echo "[4/6] Initializing git..."
if [ ! -d ".git" ]; then
    git init
    git checkout -b main
    echo "  Git initialized with main branch."
else
    echo "  Git already initialized."
fi

# 5. Get dependencies
echo ""
echo "[5/6] Getting dependencies..."
cd core
if [ -f "pubspec.yaml" ]; then
    dart pub get
    echo "  Core dependencies installed."
else
    echo "  Core pubspec.yaml not yet created. Will install after Task 1.1."
fi
cd ..

cd app
flutter pub get
echo "  App dependencies installed."
cd ..

# 6. Verify
echo ""
echo "[6/6] Verifying setup..."
cd app
flutter analyze || echo "  (Analysis warnings expected before code is written)"
cd ..

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Copy BharatTesting_Developer_Spec.pdf into docs/"
echo "  2. Read CLAUDE.md for full agent instructions"
echo "  3. Follow TASKS.md in order (start with Task 1.1)"
echo "  4. Follow RULES.md constraints at all times"
echo ""
echo "Project root: $(pwd)"
