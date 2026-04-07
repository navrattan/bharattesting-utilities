import 'package:alchemist/alchemist.dart';
import 'package:bharattesting_utilities/features/data_faker/faker_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'golden_test_config.dart';

/// Golden tests for the Indian Data Faker
///
/// Tests the data generation interface, template selection,
/// identifier controls, and generated data display.
void main() {
  group('Data Faker Golden Tests', () {
    goldenTest(
      'data faker initial state',
      fileName: 'data_faker_initial',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          for (final themeName in GoldenTestConfig.themes.keys)
            for (final device in GoldenTestConfig.devices)
              GoldenTestConfig.createScenario(
                name: 'initial_${themeName}_${device.name}',
                theme: themeName,
                device: device,
                child: const FakerScreen(),
              ),
        ],
      ),
    );

    goldenTest(
      'data faker with generated data',
      fileName: 'data_faker_generated',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          // Test with mock generated data
          GoldenTestConfig.createScenario(
            name: 'generated_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withMockData(
              const FakerScreen(),
              GoldenTestData.sampleIndianData,
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'generated_dark_desktop',
            theme: 'dark',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withMockData(
              const FakerScreen(),
              GoldenTestData.sampleIndianData,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'data faker loading states',
      fileName: 'data_faker_loading',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'loading_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withLoadingState(
              const FakerScreen(),
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'loading_light_tablet',
            theme: 'light',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withLoadingState(
              const FakerScreen(),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'data faker error states',
      fileName: 'data_faker_error',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'error_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withErrorState(
              const FakerScreen(),
              'Failed to generate data. Please try again.',
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'data faker template variations',
      fileName: 'data_faker_templates',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          // Test different template selections
          for (final template in ['Individual', 'Company', 'Proprietorship'])
            GoldenTestConfig.createScenario(
              name: '${template.toLowerCase()}_template_dark_mobile',
              theme: 'dark',
              device: GoldenTestConfig.mobileDevice,
              child: GoldenTestConfig.withSelectedTemplate(
                const FakerScreen(),
                template,
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'data faker disclaimer visibility',
      fileName: 'data_faker_disclaimer',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          // Ensure safety disclaimer is always visible
          GoldenTestConfig.createScenario(
            name: 'disclaimer_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: const FakerScreen(),
          ),
          GoldenTestConfig.createScenario(
            name: 'disclaimer_light_desktop',
            theme: 'light',
            device: GoldenTestConfig.desktopDevice,
            child: const FakerScreen(),
          ),
        ],
      ),
    );

    goldenTest(
      'data faker export options',
      fileName: 'data_faker_export',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'export_options_dark_tablet',
            theme: 'dark',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withExportOptions(
              const FakerScreen(),
            ),
          ),
        ],
      ),
    );
  });
}