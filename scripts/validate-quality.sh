#!/bin/bash

# BharatTesting Utilities - Quality Validation Script
set -e

echo "🔍 BharatTesting Quality Validation Starting..."

# Save the initial directory (project root)
PROJECT_ROOT=$(pwd)
echo "Project root: $PROJECT_ROOT"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validation results
ISSUES_FOUND=0
TOTAL_CHECKS=0

# Function to check and report
check_and_report() {
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
}

echo ""
echo "🏗️  Architecture Compliance Checks"
echo "=================================="

# Check 1: All screens use ToolScaffold
echo "📱 Checking ToolScaffold usage across screens..."

# Check FakerScreen
if grep -q "ToolScaffold" app/lib/features/data_faker/faker_screen.dart; then
    check_and_report 0 "FakerScreen uses ToolScaffold"
else
    check_and_report 1 "FakerScreen missing ToolScaffold"
fi

# Check JsonConverterScreen
if grep -q "ToolScaffold" app/lib/features/json_converter/json_converter_screen.dart; then
    check_and_report 0 "JsonConverterScreen uses ToolScaffold"
else
    check_and_report 1 "JsonConverterScreen missing ToolScaffold"
fi

# Check DocumentScannerScreen
if grep -q "ToolScaffold" app/lib/features/document_scanner/screens/document_scanner_screen.dart; then
    check_and_report 0 "DocumentScannerScreen uses ToolScaffold"
else
    check_and_report 1 "DocumentScannerScreen missing ToolScaffold"
fi

# Check PdfMergerScreen
if grep -q "ToolScaffold" app/lib/features/pdf_merger/pdf_merger_screen.dart; then
    check_and_report 0 "PdfMergerScreen uses ToolScaffold"
else
    check_and_report 1 "PdfMergerScreen missing ToolScaffold"
fi

# Check ImageReducerScreen
if grep -q "ToolScaffold" app/lib/features/image_reducer/image_reducer_screen.dart; then
    check_and_report 0 "ImageReducerScreen uses ToolScaffold"
else
    check_and_report 1 "ImageReducerScreen missing ToolScaffold"
fi

echo ""
echo "🔧 Core Integration Checks"
echo "=========================="

# Check 2: Core library imports
echo "📦 Checking core library integration..."

# Check for consistent core imports
if grep -rq "package:bharattesting_core/core.dart" app/lib/features/; then
    check_and_report 0 "Core library imports found"
else
    check_and_report 1 "Missing core library imports"
fi

# Check for enum conflicts
if grep -rq "hide TemplateType" app/lib/features/data_faker/; then
    check_and_report 1 "TemplateType enum conflict still exists"
else
    check_and_report 0 "TemplateType enum conflicts resolved"
fi

echo ""
echo "🎨 UI/UX Quality Checks"
echo "======================="

# Check 3: Footer branding presence
echo "🏷️  Checking footer branding..."

if grep -rq "BTQA\|Built by\|Open Source" app/lib/shared/widgets/btqa_footer.dart; then
    check_and_report 0 "BTQA footer branding found"
else
    check_and_report 1 "Missing BTQA footer branding"
fi

# Check 4: Error handling
echo "⚠️  Checking error handling implementation..."

if grep -rq "errorMessage\|Error\|AlertCircle" app/lib/features/data_faker/faker_screen.dart; then
    check_and_report 0 "Data Faker error handling implemented"
else
    check_and_report 1 "Data Faker missing error handling"
fi

# Check 5: Disclaimer presence
echo "📋 Checking disclaimer presence..."

if grep -rq "synthetic\|testing only\|do not use for fraud" app/lib/features/data_faker/faker_screen.dart; then
    check_and_report 0 "Data Faker disclaimer present"
else
    check_and_report 1 "Data Faker missing disclaimer"
fi

echo ""
echo "🔒 Security & Privacy Checks"
echo "============================"

# Check 6: No actual network calls in core (exclude comments/URLs)
echo "🌐 Checking for network calls in core..."

NETWORK_CALLS=$(grep -r "HttpClient\|http\.get\|http\.post\|dio\|requests\|fetch(" core/lib/src/ 2>/dev/null | grep -v "comment\|//\|website.*bharattesting" || true)
if [ -n "$NETWORK_CALLS" ]; then
    check_and_report 1 "Network calls found in core (violates offline-first)"
else
    check_and_report 0 "Core is offline-first (no network calls)"
fi

# Check 7: No actual analytics/tracking (exclude icon names)
echo "📊 Checking for analytics/tracking..."

ANALYTICS_CALLS=$(grep -r "firebase\|amplitude\|mixpanel\|google.*analytics\|gtag\|trackEvent" app/lib/ 2>/dev/null || true)
if [ -n "$ANALYTICS_CALLS" ]; then
    check_and_report 1 "Analytics/tracking found (violates privacy)"
else
    check_and_report 0 "No analytics/tracking found (privacy-first)"
fi

echo ""
echo "📱 App Configuration Checks"
echo "==========================="

# Check 8: PWA manifest exists
echo "🌍 Checking PWA configuration..."

if [ -f "app/web/manifest.json" ]; then
    check_and_report 0 "PWA manifest.json exists"
else
    check_and_report 1 "Missing PWA manifest.json"
fi

# Check 9: App icons configured
echo "🎨 Checking app icons..."

if [ -f "app/assets/images/app_icon.png" ] || [ -f "app/web/favicon.svg" ]; then
    check_and_report 0 "App icons configured"
else
    check_and_report 1 "App icons missing"
fi

echo ""
echo "🧪 Test Infrastructure Checks"
echo "============================="

# Check 10: E2E tests exist
echo "🧪 Checking E2E test coverage..."

E2E_TEST_COUNT=$(find app/integration_test -name "*_test.dart" 2>/dev/null | wc -l)
if [ "$E2E_TEST_COUNT" -ge 5 ]; then
    check_and_report 0 "E2E tests created ($E2E_TEST_COUNT test files)"
else
    check_and_report 1 "Insufficient E2E test coverage ($E2E_TEST_COUNT/5)"
fi

# Check 11: Patrol dependency
echo "🤖 Checking Patrol E2E framework..."

if grep -q "patrol:" app/pubspec.yaml; then
    check_and_report 0 "Patrol E2E framework configured"
else
    check_and_report 1 "Missing Patrol E2E framework"
fi

echo ""
echo "🏢 Business Logic Checks"
echo "======================="

# Check 12: Data Faker templates
echo "🏭 Checking Data Faker template implementation..."

TEMPLATE_COUNT=$(find core/lib/src/data_faker/templates -name "*_template.dart" 2>/dev/null | wc -l)
if [ "$TEMPLATE_COUNT" -ge 3 ]; then
    check_and_report 0 "Data Faker templates implemented ($TEMPLATE_COUNT templates)"
else
    check_and_report 1 "Missing Data Faker templates ($TEMPLATE_COUNT/3+)"
fi

# Check 13: Checksum implementations
echo "🧮 Checking checksum algorithms..."

if [ -f "core/lib/src/data_faker/checksums/verhoeff.dart" ] && [ -f "core/lib/src/data_faker/checksums/luhn_mod36.dart" ]; then
    check_and_report 0 "Checksum algorithms implemented"
else
    check_and_report 1 "Missing checksum algorithms"
fi

# Check 14: JSON Converter auto-repair
echo "🔧 Checking JSON Converter features..."

if grep -rq "auto.*repair\|repair.*rule" core/lib/src/json_converter/; then
    check_and_report 0 "JSON Converter auto-repair implemented"
else
    check_and_report 1 "JSON Converter auto-repair missing"
fi

echo ""
echo "📋 Summary"
echo "=========="

PASS_RATE=$((($TOTAL_CHECKS - $ISSUES_FOUND) * 100 / $TOTAL_CHECKS))

echo -e "Total Checks: ${BLUE}$TOTAL_CHECKS${NC}"
echo -e "Issues Found: ${RED}$ISSUES_FOUND${NC}"
echo -e "Pass Rate: ${GREEN}$PASS_RATE%${NC}"

if [ $ISSUES_FOUND -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 All quality checks passed! BharatTesting Utilities is ready for deployment.${NC}"
    exit 0
elif [ $ISSUES_FOUND -le 3 ]; then
    echo ""
    echo -e "${YELLOW}⚠️  Minor issues found. Consider fixing before deployment.${NC}"
    exit 1
else
    echo ""
    echo -e "${RED}🚨 Critical issues found. Please fix before deployment.${NC}"
    exit 1
fi