import 'package:alchemist/alchemist.dart';
import 'package:bharattesting_utilities/features/home/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'golden_test_config.dart';

/// Golden tests for the home screen
///
/// Tests the main landing page with tool cards, responsive layouts,
/// and different themes across multiple device sizes.
void main() {
  group('Home Screen Golden Tests', () {
    goldenTest(
      'home screen renders correctly across themes and devices',
      fileName: 'home_screen',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          for (final themeName in GoldenTestConfig.themes.keys)
            for (final device in GoldenTestConfig.devices)
              GoldenTestConfig.createScenario(
                name: 'home_${themeName}_${device.name}',
                theme: themeName,
                device: device,
                child: const HomeScreen(),
              ),
        ],
      ),
    );

    goldenTest(
      'home screen tool cards layout',
      fileName: 'home_tool_cards',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          // Focus on the tool cards grid specifically
          GoldenTestConfig.createScenario(
            name: 'tool_cards_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: const HomeScreen(),
          ),
          GoldenTestConfig.createScenario(
            name: 'tool_cards_dark_tablet',
            theme: 'dark',
            device: GoldenTestConfig.tabletDevice,
            child: const HomeScreen(),
          ),
          GoldenTestConfig.createScenario(
            name: 'tool_cards_dark_desktop',
            theme: 'dark',
            device: GoldenTestConfig.desktopDevice,
            child: const HomeScreen(),
          ),
        ],
      ),
    );

    goldenTest(
      'home screen light theme variations',
      fileName: 'home_light_theme',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'home_light_mobile',
            theme: 'light',
            device: GoldenTestConfig.mobileDevice,
            child: const HomeScreen(),
          ),
          GoldenTestConfig.createScenario(
            name: 'home_light_desktop',
            theme: 'light',
            device: GoldenTestConfig.desktopDevice,
            child: const HomeScreen(),
          ),
        ],
      ),
    );

    goldenTest(
      'home screen footer and branding',
      fileName: 'home_footer',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          // Test that BTQA footer is properly rendered
          GoldenTestConfig.createScenario(
            name: 'footer_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: const HomeScreen(),
          ),
          GoldenTestConfig.createScenario(
            name: 'footer_light_desktop',
            theme: 'light',
            device: GoldenTestConfig.desktopDevice,
            child: const HomeScreen(),
          ),
        ],
      ),
    );

    goldenTest(
      'home screen responsive breakpoints',
      fileName: 'home_responsive',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          // Test responsive layout transitions
          for (final width in [350, 600, 768, 1024, 1280])
            GoldenTestConfig.createScenario(
              name: 'responsive_${width}w',
              theme: 'dark',
              device: Device(
                name: '${width}w',
                size: Size(width.toDouble(), 800),
              ),
              child: const HomeScreen(),
            ),
        ],
      ),
    );
  });
}