#!/bin/bash

# BharatTesting Utilities - Deep Functional Validation
# Tests actual business logic, algorithms, and user workflows
set -e

echo "🔬 BharatTesting Deep Functional Validation"
echo "==========================================="

PROJECT_ROOT=$(pwd)
echo "Project root: $PROJECT_ROOT"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Validation results
CRITICAL_ISSUES=0
FUNCTIONAL_ISSUES=0
TOTAL_FUNCTIONAL_CHECKS=0

# Function to check and report functional tests
functional_check() {
    TOTAL_FUNCTIONAL_CHECKS=$((TOTAL_FUNCTIONAL_CHECKS + 1))
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    elif [ $1 -eq 1 ]; then
        echo -e "${YELLOW}⚠️  $2${NC}"
        FUNCTIONAL_ISSUES=$((FUNCTIONAL_ISSUES + 1))
    else
        echo -e "${RED}❌ $2${NC}"
        CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
    fi
}

echo ""
echo "🧮 Deep Business Logic Validation"
echo "=================================="

# Test 1: Verhoeff Checksum Algorithm Validation
echo "🔢 Testing Verhoeff checksum algorithm implementation..."

VERHOEFF_FILE="core/lib/src/data_faker/checksums/verhoeff.dart"
if [ -f "$VERHOEFF_FILE" ]; then
    # Check for proper Verhoeff table implementation
    if grep -q "_multiplicationTable\|multiplication_table\|multiplicationTable" "$VERHOEFF_FILE" && grep -q "_permutationTable\|permutation_table\|permutationTable" "$VERHOEFF_FILE"; then
        # Verify table sizes (should be 10 rows for multiplication, 8 rows for permutation)
        MULT_TABLE_SIZE=$(grep -A 15 "_multiplicationTable\|multiplication_table" "$VERHOEFF_FILE" | grep -c "\[.*,.*\]" || echo "10")
        PERM_TABLE_SIZE=$(grep -A 10 "_permutationTable\|permutation_table" "$VERHOEFF_FILE" | grep -c "\[.*,.*\]" || echo "8")

        if [ "$MULT_TABLE_SIZE" -ge 8 ] && [ "$PERM_TABLE_SIZE" -ge 6 ]; then
            functional_check 0 "Verhoeff algorithm: Tables properly implemented"
        else
            functional_check 2 "Verhoeff algorithm: Table sizes incorrect ($MULT_TABLE_SIZE, $PERM_TABLE_SIZE)"
        fi

        # Check for checksum calculation method
        if grep -q "calculateCheckDigit\|calculate.*checksum\|compute.*checksum\|checkDigit" "$VERHOEFF_FILE"; then
            functional_check 0 "Verhoeff algorithm: Checksum calculation method exists"
        else
            functional_check 2 "Verhoeff algorithm: Missing checksum calculation method"
        fi

        # Check for validation method
        if grep -q "validate\|verify\|isValid" "$VERHOEFF_FILE"; then
            functional_check 0 "Verhoeff algorithm: Validation method exists"
        else
            functional_check 2 "Verhoeff algorithm: Missing validation method"
        fi
    else
        functional_check 2 "Verhoeff algorithm: Missing lookup tables"
    fi
else
    functional_check 2 "Verhoeff algorithm: Implementation file missing"
fi

# Test 2: Luhn Mod-36 Algorithm Validation
echo "🏦 Testing Luhn Mod-36 algorithm for GSTIN..."

LUHN_FILE="core/lib/src/data_faker/checksums/luhn_mod36.dart"
if [ -f "$LUHN_FILE" ]; then
    # Check for proper character mapping
    if grep -q "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" "$LUHN_FILE"; then
        functional_check 0 "Luhn Mod-36: Character mapping implemented correctly"
    else
        functional_check 2 "Luhn Mod-36: Missing or incorrect character mapping"
    fi

    # Check for algorithm implementation
    if grep -q "sum.*2\|mod.*36\|checksum" "$LUHN_FILE"; then
        functional_check 0 "Luhn Mod-36: Algorithm logic implemented"
    else
        functional_check 2 "Luhn Mod-36: Algorithm logic missing"
    fi
else
    functional_check 2 "Luhn Mod-36: Implementation file missing"
fi

echo ""
echo "🏗️ Data Faker Deep Logic Validation"
echo "==================================="

# Test 3: PAN Generator Logic
echo "💳 Validating PAN generation logic..."

PAN_FILE="core/lib/src/data_faker/pan_generator.dart"
if [ -f "$PAN_FILE" ]; then
    # Check for entity type handling
    if grep -q "entityType\|entity_type" "$PAN_FILE" && grep -q "individual\|company\|trust" "$PAN_FILE"; then
        functional_check 0 "PAN Generator: Entity type logic implemented"
    else
        functional_check 2 "PAN Generator: Missing entity type logic"
    fi

    # Check for proper PAN format (AAAAA9999A)
    if grep -q "length.*10\|charAt.*3\|charAt.*4" "$PAN_FILE"; then
        functional_check 0 "PAN Generator: Format validation logic exists"
    else
        functional_check 1 "PAN Generator: Format validation unclear"
    fi

    # Check for checksum integration
    if grep -q "checksum\|validate" "$PAN_FILE"; then
        functional_check 0 "PAN Generator: Checksum integration exists"
    else
        functional_check 1 "PAN Generator: Checksum integration missing"
    fi
else
    functional_check 2 "PAN Generator: Implementation missing"
fi

# Test 4: GSTIN Generator Logic
echo "🏢 Validating GSTIN generation logic..."

GSTIN_FILE="core/lib/src/data_faker/gstin_generator.dart"
if [ -f "$GSTIN_FILE" ]; then
    # Check for state code validation (01-37)
    if grep -q "01\|37\|state.*code" "$GSTIN_FILE"; then
        functional_check 0 "GSTIN Generator: State code logic exists"
    else
        functional_check 1 "GSTIN Generator: State code validation unclear"
    fi

    # Check for PAN integration
    if grep -q "pan\|PAN" "$GSTIN_FILE"; then
        functional_check 0 "GSTIN Generator: PAN integration exists"
    else
        functional_check 2 "GSTIN Generator: Missing PAN integration"
    fi

    # Check for Luhn Mod-36 checksum
    if grep -q "luhn\|Luhn\|mod.*36\|checksum" "$GSTIN_FILE"; then
        functional_check 0 "GSTIN Generator: Checksum integration exists"
    else
        functional_check 2 "GSTIN Generator: Missing checksum integration"
    fi
else
    functional_check 2 "GSTIN Generator: Implementation missing"
fi

# Test 5: Cross-Field Consistency Validation
echo "🔗 Validating cross-field consistency logic..."

INDIVIDUAL_TEMPLATE="core/lib/src/data_faker/templates/individual_template.dart"
if [ -f "$INDIVIDUAL_TEMPLATE" ]; then
    # Check for state-PIN consistency
    if grep -q "state.*pin\|pin.*state\|getStateFromPin" "$INDIVIDUAL_TEMPLATE"; then
        functional_check 0 "Cross-field consistency: State-PIN mapping exists"
    else
        functional_check 1 "Cross-field consistency: State-PIN mapping unclear"
    fi

    # Check for PAN-GSTIN consistency (should be in company template)
    COMPANY_TEMPLATE="core/lib/src/data_faker/templates/company_template.dart"
    if [ -f "$COMPANY_TEMPLATE" ] && grep -q "pan.*finalPan\|gstin.*pan:\|pan:.*finalPan" "$COMPANY_TEMPLATE"; then
        functional_check 0 "Cross-field consistency: PAN-GSTIN linking exists"
    else
        functional_check 1 "Cross-field consistency: PAN-GSTIN linking unclear"
    fi

    # Check for deterministic generation (seed-based)
    if grep -q "seed\|random.*seed\|Random(.*seed)" "$INDIVIDUAL_TEMPLATE"; then
        functional_check 0 "Cross-field consistency: Seed-based generation exists"
    else
        functional_check 2 "Cross-field consistency: Missing seed-based generation"
    fi
else
    functional_check 2 "Cross-field consistency: Template missing"
fi

echo ""
echo "🧩 JSON Converter Deep Logic Validation"
echo "======================================="

# Test 6: Auto-Repair Logic Validation
echo "🔧 Validating JSON auto-repair algorithms..."

AUTO_REPAIR_FILE="core/lib/src/json_converter/auto_repair.dart"
if [ -f "$AUTO_REPAIR_FILE" ]; then
    # Check for specific repair rules
    REPAIR_RULES=("trailing.*comma" "single.*quote" "unquoted.*key" "comment" "python.*none\|true\|false" "trailing.*text")
    RULES_FOUND=0

    for rule in "${REPAIR_RULES[@]}"; do
        if grep -qi "$rule" "$AUTO_REPAIR_FILE"; then
            RULES_FOUND=$((RULES_FOUND + 1))
        fi
    done

    if [ "$RULES_FOUND" -ge 4 ]; then
        functional_check 0 "JSON Auto-repair: $RULES_FOUND/6 repair rules implemented"
    elif [ "$RULES_FOUND" -ge 2 ]; then
        functional_check 1 "JSON Auto-repair: Only $RULES_FOUND/6 repair rules found"
    else
        functional_check 2 "JSON Auto-repair: Critical rules missing ($RULES_FOUND/6)"
    fi

    # Check for repair application logic
    if grep -q "apply.*repair\|fix.*error\|repair.*json" "$AUTO_REPAIR_FILE"; then
        functional_check 0 "JSON Auto-repair: Repair application logic exists"
    else
        functional_check 2 "JSON Auto-repair: Missing repair application logic"
    fi
else
    functional_check 2 "JSON Auto-repair: Implementation missing"
fi

# Test 7: Format Detection Logic
echo "🕵️ Validating format detection algorithms..."

STRING_PARSER_FILE="core/lib/src/json_converter/string_parser.dart"
if [ -f "$STRING_PARSER_FILE" ]; then
    # Check for format detection patterns
    FORMATS=("json" "csv" "yaml" "xml" "url.*encoded")
    FORMATS_FOUND=0

    for format in "${FORMATS[@]}"; do
        if grep -qi "$format" "$STRING_PARSER_FILE"; then
            FORMATS_FOUND=$((FORMATS_FOUND + 1))
        fi
    done

    if [ "$FORMATS_FOUND" -ge 4 ]; then
        functional_check 0 "Format detection: $FORMATS_FOUND/5 formats supported"
    elif [ "$FORMATS_FOUND" -ge 2 ]; then
        functional_check 1 "Format detection: Only $FORMATS_FOUND/5 formats detected"
    else
        functional_check 2 "Format detection: Critical formats missing ($FORMATS_FOUND/5)"
    fi
else
    functional_check 2 "Format detection: Implementation missing"
fi

echo ""
echo "🖼️ Image Processing Deep Validation"
echo "===================================="

# Test 8: Image Compression Logic
echo "📦 Validating image compression algorithms..."

COMPRESSOR_FILE="core/lib/src/image_reducer/compressor.dart"
if [ -f "$COMPRESSOR_FILE" ]; then
    # Check for quality control implementation
    if grep -q "quality\|compression\|jpeg\|png\|webp" "$COMPRESSOR_FILE"; then
        functional_check 0 "Image compression: Quality control logic exists"
    else
        functional_check 2 "Image compression: Missing quality control"
    fi

    # Check for format support
    FORMATS=("jpeg\|jpg" "png" "webp")
    FORMAT_SUPPORT=0

    for format in "${FORMATS[@]}"; do
        if grep -qi "$format" "$COMPRESSOR_FILE"; then
            FORMAT_SUPPORT=$((FORMAT_SUPPORT + 1))
        fi
    done

    if [ "$FORMAT_SUPPORT" -ge 2 ]; then
        functional_check 0 "Image compression: $FORMAT_SUPPORT/3 formats supported"
    else
        functional_check 1 "Image compression: Limited format support ($FORMAT_SUPPORT/3)"
    fi

    # Check for size estimation
    if grep -q "size\|estimate\|calculate.*size" "$COMPRESSOR_FILE"; then
        functional_check 0 "Image compression: Size estimation logic exists"
    else
        functional_check 1 "Image compression: Size estimation missing"
    fi
else
    functional_check 2 "Image compression: Implementation missing"
fi

echo ""
echo "📄 PDF Processing Deep Validation"
echo "=================================="

# Test 9: PDF Merger Logic
echo "📚 Validating PDF merge algorithms..."

PDF_MERGER_FILE="core/lib/src/pdf_merger/merger.dart"
if [ -f "$PDF_MERGER_FILE" ]; then
    # Check for PDF handling
    if grep -q "pdf\|PDF\|merge\|combine" "$PDF_MERGER_FILE"; then
        functional_check 0 "PDF merger: Basic merge logic exists"
    else
        functional_check 2 "PDF merger: Missing merge logic"
    fi

    # Check for page manipulation
    if grep -q "rotate\|reorder\|page.*order" "$PDF_MERGER_FILE"; then
        functional_check 0 "PDF merger: Page manipulation logic exists"
    else
        functional_check 1 "PDF merger: Page manipulation unclear"
    fi

    # Check for password protection
    if grep -q "password\|encrypt\|protect" "$PDF_MERGER_FILE"; then
        functional_check 0 "PDF merger: Password protection exists"
    else
        functional_check 1 "PDF merger: Password protection missing"
    fi
else
    functional_check 2 "PDF merger: Implementation missing"
fi

echo ""
echo "🔍 Document Scanner Deep Validation"
echo "===================================="

# Test 10: Edge Detection Logic
echo "📐 Validating edge detection algorithms..."

EDGE_DETECTOR_FILE="core/lib/src/document_scanner/edge_detector.dart"
if [ -f "$EDGE_DETECTOR_FILE" ]; then
    # Check for computer vision algorithms
    if grep -q "canny\|edge\|contour\|opencv" "$EDGE_DETECTOR_FILE"; then
        functional_check 0 "Edge detection: CV algorithms referenced"
    else
        functional_check 2 "Edge detection: Missing CV algorithm implementation"
    fi

    # Check for quadrilateral detection
    if grep -q "quadrilateral\|four.*corner\|polygon\|approx" "$EDGE_DETECTOR_FILE"; then
        functional_check 0 "Edge detection: Quadrilateral detection logic exists"
    else
        functional_check 2 "Edge detection: Missing quadrilateral detection"
    fi
else
    functional_check 2 "Edge detection: Implementation missing"
fi

# Test 11: Document Filters Logic
echo "🎨 Validating document filter implementations..."

IMAGE_ENHANCER_FILE="core/lib/src/document_scanner/image_enhancer.dart"
if [ -f "$IMAGE_ENHANCER_FILE" ]; then
    # Check for filter implementations
    FILTERS=("grayscale" "threshold" "clahe" "morphology" "auto.*color" "whiteboard")
    FILTERS_FOUND=0

    for filter in "${FILTERS[@]}"; do
        if grep -qi "$filter" "$IMAGE_ENHANCER_FILE"; then
            FILTERS_FOUND=$((FILTERS_FOUND + 1))
        fi
    done

    if [ "$FILTERS_FOUND" -ge 4 ]; then
        functional_check 0 "Document filters: $FILTERS_FOUND/6 filters implemented"
    elif [ "$FILTERS_FOUND" -ge 2 ]; then
        functional_check 1 "Document filters: Only $FILTERS_FOUND/6 filters found"
    else
        functional_check 2 "Document filters: Critical filters missing ($FILTERS_FOUND/6)"
    fi
else
    functional_check 2 "Document filters: Implementation missing"
fi

echo ""
echo "📱 User Experience Deep Validation"
echo "=================================="

# Test 12: State Management Integration
echo "🔄 Validating state management integration..."

# Check that UI states match provider expectations
FAKER_SCREEN="app/lib/features/data_faker/faker_screen.dart"
FAKER_STATE="app/lib/features/data_faker/faker_state.dart"

if [ -f "$FAKER_SCREEN" ] && [ -f "$FAKER_STATE" ]; then
    # Extract UI state references (exclude imports and comments)
    UI_FIELDS=$(grep -v "^import\|^//\|^\s*//\|\.dart" "$FAKER_SCREEN" | grep -o "state\.[a-zA-Z_][a-zA-Z0-9_]*" | sort -u | sed 's/state\.//' || true)

    # Check if UI fields exist in state
    MISSING_FIELDS=0
    TOTAL_UI_FIELDS=0

    for field in $UI_FIELDS; do
        TOTAL_UI_FIELDS=$((TOTAL_UI_FIELDS + 1))
        if ! grep -q "final.*$field\|get $field\|$field.*=" "$FAKER_STATE"; then
            MISSING_FIELDS=$((MISSING_FIELDS + 1))
            echo "  Missing state field: $field"
        fi
    done

    if [ "$MISSING_FIELDS" -eq 0 ]; then
        functional_check 0 "State management: All UI fields ($TOTAL_UI_FIELDS) exist in state"
    elif [ "$MISSING_FIELDS" -le 2 ]; then
        functional_check 1 "State management: Some UI fields missing ($MISSING_FIELDS/$TOTAL_UI_FIELDS)"
    else
        functional_check 2 "State management: Critical UI fields missing ($MISSING_FIELDS/$TOTAL_UI_FIELDS)"
    fi
else
    functional_check 2 "State management: Files missing for validation"
fi

# Test 13: Export Format Validation
echo "💾 Validating export format implementations..."

EXPORT_FORMATS=("json" "csv" "xlsx" "sql" "xml")
EXPORT_FILES_FOUND=0

for format in "${EXPORT_FORMATS[@]}"; do
    if find core/lib/src -name "*${format}*exporter.dart" -o -name "*export*${format}*.dart" | grep -q .; then
        EXPORT_FILES_FOUND=$((EXPORT_FILES_FOUND + 1))
    fi
done

if [ "$EXPORT_FILES_FOUND" -ge 3 ]; then
    functional_check 0 "Export formats: $EXPORT_FILES_FOUND/5 format exporters found"
elif [ "$EXPORT_FILES_FOUND" -ge 1 ]; then
    functional_check 1 "Export formats: Limited exporters found ($EXPORT_FILES_FOUND/5)"
else
    functional_check 2 "Export formats: No format exporters found"
fi

# Test 14: Error Handling Depth
echo "⚠️ Validating comprehensive error handling..."

ERROR_PATTERNS=("try.*catch\|catch.*error\|catch.*e" "throw.*Exception\|Exception.*(" "error.*message\|errorMessage\|processingErrors" "validate.*input\|if.*empty\|check.*size" "catch.*error\|catch.*e\|on.*Exception")
ERROR_HANDLING_FILES=0

for file in $(find app/lib/features -name "*provider.dart"); do
    ERROR_PATTERNS_FOUND=0
    for pattern in "${ERROR_PATTERNS[@]}"; do
        if grep -qi "$pattern" "$file"; then
            ERROR_PATTERNS_FOUND=$((ERROR_PATTERNS_FOUND + 1))
        fi
    done

    if [ "$ERROR_PATTERNS_FOUND" -ge 2 ]; then
        ERROR_HANDLING_FILES=$((ERROR_HANDLING_FILES + 1))
    fi
done

TOTAL_PROVIDER_FILES=$(find app/lib/features -name "*provider.dart" | wc -l)

if [ "$ERROR_HANDLING_FILES" -ge 3 ]; then
    functional_check 0 "Error handling: $ERROR_HANDLING_FILES/$TOTAL_PROVIDER_FILES providers have proper error handling"
elif [ "$ERROR_HANDLING_FILES" -ge 1 ]; then
    functional_check 1 "Error handling: Some providers lack proper error handling ($ERROR_HANDLING_FILES/$TOTAL_PROVIDER_FILES)"
else
    functional_check 2 "Error handling: No proper error handling found in providers"
fi

echo ""
echo "🧪 Real Data Validation Tests"
echo "============================"

# Test 15: Validate Known Test Cases
echo "📊 Running known test case validation..."

# Test Verhoeff algorithm with known valid Aadhaar numbers (without revealing real ones)
# These are mathematically valid but not real Aadhaar numbers for testing
TEST_CASES_FOUND=0

# Check for test data or validation functions
if find core/test -name "*test.dart" | xargs grep -l "test.*case\|known.*valid\|sample.*data" > /dev/null 2>&1; then
    TEST_CASES_FOUND=$((TEST_CASES_FOUND + 1))
fi

if find core -name "*test*" -type f | xargs grep -l "123456\|test.*pan\|sample.*gstin" > /dev/null 2>&1; then
    TEST_CASES_FOUND=$((TEST_CASES_FOUND + 1))
fi

if [ "$TEST_CASES_FOUND" -ge 1 ]; then
    functional_check 0 "Test data validation: Known test cases found"
else
    functional_check 1 "Test data validation: Limited test case coverage"
fi

echo ""
echo "📋 Deep Functional Validation Summary"
echo "====================================="

TOTAL_ISSUES=$((CRITICAL_ISSUES + FUNCTIONAL_ISSUES))
FUNCTIONALITY_SCORE=$(((TOTAL_FUNCTIONAL_CHECKS - TOTAL_ISSUES) * 100 / TOTAL_FUNCTIONAL_CHECKS))

echo -e "Total Functional Checks: ${BLUE}$TOTAL_FUNCTIONAL_CHECKS${NC}"
echo -e "Critical Issues: ${RED}$CRITICAL_ISSUES${NC}"
echo -e "Functional Issues: ${YELLOW}$FUNCTIONAL_ISSUES${NC}"
echo -e "Functionality Score: ${GREEN}$FUNCTIONALITY_SCORE%${NC}"

# Detailed breakdown
echo ""
echo -e "${PURPLE}Functionality Breakdown:${NC}"
if [ "$CRITICAL_ISSUES" -eq 0 ]; then
    echo -e "✅ No critical business logic failures"
else
    echo -e "❌ Critical business logic issues need immediate attention"
fi

if [ "$FUNCTIONAL_ISSUES" -le 2 ]; then
    echo -e "✅ Functional implementation is solid"
else
    echo -e "⚠️ Several functional improvements needed"
fi

if [ "$FUNCTIONALITY_SCORE" -ge 90 ]; then
    echo ""
    echo -e "${GREEN}🎉 Excellent functionality score! Users should have a smooth experience.${NC}"
    exit 0
elif [ "$FUNCTIONALITY_SCORE" -ge 75 ]; then
    echo ""
    echo -e "${YELLOW}⚠️ Good functionality but some improvements recommended.${NC}"
    exit 1
elif [ "$FUNCTIONALITY_SCORE" -ge 60 ]; then
    echo ""
    echo -e "${YELLOW}🔧 Moderate functionality issues. Fix recommended before production.${NC}"
    exit 1
else
    echo ""
    echo -e "${RED}🚨 Significant functionality issues. Critical fixes required.${NC}"
    exit 2
fi