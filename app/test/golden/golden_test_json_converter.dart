import 'package:alchemist/alchemist.dart';
import 'package:bharattesting_utilities/features/json_converter/json_converter_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'golden_test_config.dart';

/// Golden tests for the String-to-JSON Converter
///
/// Tests the input/output interface, syntax highlighting,
/// error states, and format detection.
void main() {
  group('JSON Converter Golden Tests', () {
    goldenTest(
      'json converter initial state',
      fileName: 'json_converter_initial',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          for (final themeName in GoldenTestConfig.themes.keys)
            for (final device in GoldenTestConfig.devices)
              GoldenTestConfig.createScenario(
                name: 'initial_${themeName}_${device.name}',
                theme: themeName,
                device: device,
                child: const JsonConverterScreen(),
              ),
        ],
      ),
    );

    goldenTest(
      'json converter with valid json',
      fileName: 'json_converter_valid',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'valid_json_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withJsonInput(
              const JsonConverterScreen(),
              GoldenTestData.sampleJson,
              isValid: true,
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'valid_json_light_desktop',
            theme: 'light',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withJsonInput(
              const JsonConverterScreen(),
              GoldenTestData.sampleJson,
              isValid: true,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'json converter with broken json',
      fileName: 'json_converter_broken',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'broken_json_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withJsonInput(
              const JsonConverterScreen(),
              GoldenTestData.brokenJson,
              isValid: false,
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'broken_json_light_tablet',
            theme: 'light',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withJsonInput(
              const JsonConverterScreen(),
              GoldenTestData.brokenJson,
              isValid: false,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'json converter csv input',
      fileName: 'json_converter_csv',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'csv_input_dark_desktop',
            theme: 'dark',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withJsonInput(
              const JsonConverterScreen(),
              GoldenTestData.sampleCsv,
              detectedFormat: 'CSV',
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'json converter syntax highlighting',
      fileName: 'json_converter_highlight',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          // Test syntax highlighting in both themes
          GoldenTestConfig.createScenario(
            name: 'highlighting_dark',
            theme: 'dark',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withJsonInput(
              const JsonConverterScreen(),
              GoldenTestData.complexJson,
              isValid: true,
              showHighlighting: true,
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'highlighting_light',
            theme: 'light',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withJsonInput(
              const JsonConverterScreen(),
              GoldenTestData.complexJson,
              isValid: true,
              showHighlighting: true,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'json converter error highlighting',
      fileName: 'json_converter_error_highlight',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'error_highlight_dark_desktop',
            theme: 'dark',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withJsonError(
              const JsonConverterScreen(),
              GoldenTestData.brokenJson,
              errorLine: 3,
              errorColumn: 15,
              errorMessage: 'Unexpected token \',\' at line 3, column 15',
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'json converter auto-repair suggestion',
      fileName: 'json_converter_repair',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'repair_suggestion_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withRepairSuggestion(
              const JsonConverterScreen(),
              GoldenTestData.brokenJson,
              repairSuggestion: 'Remove trailing comma',
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'json converter format detection',
      fileName: 'json_converter_format_detection',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          for (final format in ['JSON', 'CSV', 'YAML', 'XML'])
            GoldenTestConfig.createScenario(
              name: '${format.toLowerCase()}_detection_dark_tablet',
              theme: 'dark',
              device: GoldenTestConfig.tabletDevice,
              child: GoldenTestConfig.withDetectedFormat(
                const JsonConverterScreen(),
                format,
              ),
            ),
        ],
      ),
    );
  });
}