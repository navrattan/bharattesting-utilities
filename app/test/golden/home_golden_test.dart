import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bharattesting_utilities/features/home/home_screen.dart';
import 'golden_test_config.dart';

void main() {
  group('Home Screen Golden Tests', () {
    goldenTest(
      'home screen renders correctly across devices and themes',
      fileName: 'home_screen',
      builder: () {
        return GoldenTestConfig.responsiveScenarios(
          'home',
          (theme, device) => const HomeScreen(),
        );
      },
    );

    goldenTest(
      'home screen tool cards layout',
      fileName: 'home_tool_cards',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        // Test mobile layout with different card arrangements
        for (final theme in GoldenTestConfig.themes.keys) {
          scenarios.add(
            GoldenTestConfig.createScenario(
              name: 'tool_cards_grid',
              child: const HomeScreen(),
              theme: theme,
              device: const Device(name: 'mobile', size: Size(375, 667)),
            ),
          );

          // Test tablet layout with wider cards
          scenarios.add(
            GoldenTestConfig.createScenario(
              name: 'tool_cards_wide',
              child: const HomeScreen(),
              theme: theme,
              device: const Device(name: 'tablet', size: Size(768, 1024)),
            ),
          );

          // Test desktop layout with maximum width constraint
          scenarios.add(
            GoldenTestConfig.createScenario(
              name: 'tool_cards_desktop',
              child: const HomeScreen(),
              theme: theme,
              device: const Device(name: 'desktop', size: Size(1280, 800)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'home screen responsive breakpoints',
      fileName: 'home_breakpoints',
      builder: () {
        final scenarios = <GoldenTestScenario>[];
        final breakpoints = [
          const Size(320, 568), // iPhone SE
          const Size(375, 667), // iPhone 8
          const Size(414, 896), // iPhone 11
          const Size(600, 800), // Tablet portrait
          const Size(800, 600), // Tablet landscape
          const Size(1024, 768), // Desktop small
          const Size(1440, 900), // Desktop large
        ];

        for (final size in breakpoints) {
          scenarios.add(
            GoldenTestConfig.createScenario(
              name: 'breakpoint_${size.width.toInt()}x${size.height.toInt()}',
              child: const HomeScreen(),
              theme: 'dark',
              device: Device(name: 'custom', size: size),
            ),
          );
        }

        return scenarios;
      },
    );
  });

  group('Home Screen Component Golden Tests', () {
    goldenTest(
      'hero section variations',
      fileName: 'home_hero_section',
      builder: () {
        return GoldenTestConfig.responsiveScenarios(
          'hero_section',
          (theme, device) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mock hero section content
                Text(
                  'Developer Tools',
                  style: GoldenTestConfig.themes[theme]!.textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '5 free, privacy-first, offline developer tools',
                  style: GoldenTestConfig.themes[theme]!.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );

    goldenTest(
      'tool card individual states',
      fileName: 'home_tool_card_states',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        // Test individual tool cards in different states
        final tools = [
          {'title': 'Document Scanner', 'subtitle': 'Scan with edge detection'},
          {'title': 'Image Size Reducer', 'subtitle': 'Compress and resize images'},
          {'title': 'PDF Merger', 'subtitle': 'Merge and manipulate PDFs'},
          {'title': 'String-to-JSON', 'subtitle': 'Convert and validate JSON'},
          {'title': 'Indian Data Faker', 'subtitle': 'Generate Indian test data'},
        ];

        for (final theme in GoldenTestConfig.themes.keys) {
          for (final tool in tools) {
            scenarios.add(
              GoldenTestScenario(
                name: 'card_${tool['title']!.replaceAll(' ', '_').toLowerCase()}_$theme',
                child: GoldenTestConfig.themedWrapper(
                  Container(
                    width: 300,
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tool['title']!,
                              style: GoldenTestConfig.themes[theme]!.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tool['subtitle']!,
                              style: GoldenTestConfig.themes[theme]!.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  theme,
                ),
                constraints: const BoxConstraints.tight(Size(332, 120)),
              ),
            );
          }
        }

        return scenarios;
      },
    );

    goldenTest(
      'navigation states',
      fileName: 'home_navigation',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        // Test different navigation states
        for (final theme in GoldenTestConfig.themes.keys) {
          // Mobile bottom navigation
          scenarios.add(
            GoldenTestConfig.createScenario(
              name: 'bottom_nav',
              child: const Scaffold(
                body: HomeScreen(),
                bottomNavigationBar: NavigationBar(
                  destinations: [
                    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                    NavigationDestination(icon: Icon(Icons.camera), label: 'Scanner'),
                    NavigationDestination(icon: Icon(Icons.image), label: 'Images'),
                    NavigationDestination(icon: Icon(Icons.picture_as_pdf), label: 'PDF'),
                    NavigationDestination(icon: Icon(Icons.code), label: 'JSON'),
                  ],
                ),
              ),
              theme: theme,
              device: const Device(name: 'mobile', size: Size(375, 667)),
            ),
          );

          // Desktop side navigation
          scenarios.add(
            GoldenTestConfig.createScenario(
              name: 'side_nav',
              child: Row(
                children: [
                  NavigationRail(
                    destinations: const [
                      NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                      NavigationRailDestination(icon: Icon(Icons.camera), label: Text('Scanner')),
                      NavigationRailDestination(icon: Icon(Icons.image), label: Text('Images')),
                    ],
                    selectedIndex: 0,
                  ),
                  const Expanded(child: HomeScreen()),
                ],
              ),
              theme: theme,
              device: const Device(name: 'desktop', size: Size(1280, 800)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'accessibility features',
      fileName: 'home_accessibility',
      builder: () {
        final scenarios = <GoldenTestScenario>[];

        // Test with different text scale factors
        final textScales = [1.0, 1.3, 1.5, 2.0];

        for (final scale in textScales) {
          scenarios.add(
            GoldenTestScenario(
              name: 'text_scale_${scale.toString().replaceAll('.', '_')}',
              child: MediaQuery(
                data: const MediaQueryData().copyWith(textScaleFactor: scale),
                child: GoldenTestConfig.themedWrapper(
                  const HomeScreen(),
                  'dark',
                ),
              ),
              constraints: const BoxConstraints.tight(Size(375, 667)),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'performance indicators',
      fileName: 'home_performance',
      builder: () {
        return [
          // Test with performance overlay
          GoldenTestScenario(
            name: 'with_stats',
            child: GoldenTestConfig.themedWrapper(
              Stack(
                children: [
                  const HomeScreen(),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Tools: 5\nOffline: ✓\nPrivacy: ✓',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              'dark',
            ),
            constraints: const BoxConstraints.tight(Size(375, 667)),
          ),
        ];
      },
    );
  });

  group('Home Screen Edge Cases', () {
    goldenTest(
      'extreme viewport sizes',
      fileName: 'home_extreme_sizes',
      builder: () {
        final scenarios = <GoldenTestScenario>[];
        final extremeSizes = [
          const Size(240, 320), // Very small
          const Size(2560, 1440), // Very large
          const Size(1920, 480), // Ultra wide
          const Size(360, 1280), // Very tall
        ];

        for (final size in extremeSizes) {
          scenarios.add(
            GoldenTestConfig.createScenario(
              name: 'size_${size.width.toInt()}x${size.height.toInt()}',
              child: const HomeScreen(),
              theme: 'dark',
              device: Device(name: 'extreme', size: size),
            ),
          );
        }

        return scenarios;
      },
    );

    goldenTest(
      'theme edge cases',
      fileName: 'home_theme_edge_cases',
      builder: () {
        return [
          // Test with high contrast
          GoldenTestScenario(
            name: 'high_contrast',
            child: MediaQuery(
              data: const MediaQueryData().copyWith(
                highContrast: true,
                accessibleNavigation: true,
              ),
              child: GoldenTestConfig.themedWrapper(
                const HomeScreen(),
                'dark',
              ),
            ),
            constraints: const BoxConstraints.tight(Size(375, 667)),
          ),
        ];
      },
    );
  });
}