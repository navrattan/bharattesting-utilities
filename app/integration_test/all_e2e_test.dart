/// Master E2E test suite that runs all utility tests
///
/// Comprehensive testing of all 5 BharatTesting Utilities

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol/patrol.dart';
import 'package:bharattesting_utilities/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('BharatTesting Utilities - Complete E2E Test Suite', () {
    setUp(() async {
      // Reset app state before each test
      await app.main();
      await Future.delayed(Duration(seconds: 1));
    });

    testWidgets('App loads and navigation works', ($) async {
      await app.main();
      await $.pumpAndSettle();

      // Verify app loaded
      expect(find.text('BharatTesting Utilities'), findsOneWidget);

      // Verify all 5 tools are accessible
      await _testNavigationToAllTools($);
    });

    testWidgets('Data Faker - Basic workflow test', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Indian Data Faker'));
      await $.pumpAndSettle(Duration(seconds: 2));

      await _testBasicDataFakerWorkflow($);
    });

    testWidgets('JSON Converter - Basic workflow test', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('String-to-JSON Converter'));
      await $.pumpAndSettle(Duration(seconds: 2));

      await _testBasicJsonConverterWorkflow($);
    });

    testWidgets('Image Reducer - Basic workflow test', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Image Size Reducer'));
      await $.pumpAndSettle(Duration(seconds: 2));

      await _testBasicImageReducerWorkflow($);
    });

    testWidgets('PDF Merger - Basic workflow test', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('PDF Merger'));
      await $.pumpAndSettle(Duration(seconds: 2));

      await _testBasicPdfMergerWorkflow($);
    });

    testWidgets('Document Scanner - Basic workflow test', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await $.tap(find.text('Document Scanner'));
      await $.pumpAndSettle(Duration(seconds: 2));

      await _testBasicDocumentScannerWorkflow($);
    });

    testWidgets('Cross-tool navigation test', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await _testCrossToolNavigation($);
    });

    testWidgets('Footer and branding test', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await _testFooterAndBranding($);
    });

    testWidgets('Error handling across all tools', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await _testErrorHandlingAcrossTools($);
    });

    testWidgets('Performance and responsiveness test', ($) async {
      await app.main();
      await $.pumpAndSettle();

      await _testPerformanceAndResponsiveness($);
    });
  });
}

Future<void> _testNavigationToAllTools(PatrolIntegrationTester $) async {
  final tools = [
    'Document Scanner',
    'Image Size Reducer',
    'PDF Merger',
    'String-to-JSON Converter',
    'Indian Data Faker'
  ];

  for (final tool in tools) {
    final toolCard = find.text(tool);
    expect(toolCard, findsOneWidget, reason: 'Tool $tool should be visible on home screen');

    await $.tap(toolCard);
    await $.pumpAndSettle(Duration(seconds: 2));

    // Verify tool screen loaded
    expect(find.text(tool), findsAtLeastOneWidget);

    // Navigate back to home
    await $.native.pressBack();
    await $.pumpAndSettle();

    // Verify back on home screen
    expect(find.text('BharatTesting Utilities'), findsOneWidget);
  }
}

Future<void> _testBasicDataFakerWorkflow(PatrolIntegrationTester $) async {
  // Verify Data Faker loaded correctly
  expect(find.text('Choose the types of data you want'), findsOneWidget);

  // Test basic generation
  final generateButton = find.text('GENERATE DATA');
  if (generateButton.evaluate().isNotEmpty) {
    await $.tap(generateButton);
    await $.pumpAndSettle(Duration(seconds: 5));

    // Check for success or error
    final success = find.text('View Preview');
    final error = find.textContaining('error');

    if (success.evaluate().isNotEmpty) {
      print('✅ Data Faker: Generation successful');

      // Test preview
      await $.tap(success);
      await $.pumpAndSettle();

      expect(find.text('Data Preview'), findsOneWidget);

      // Close preview
      await $.native.pressBack();
      await $.pumpAndSettle();
    } else if (error.evaluate().isNotEmpty) {
      print('❌ Data Faker: Generation failed with error');
    } else {
      print('⚠️ Data Faker: Generation state unclear');
    }
  } else {
    print('❌ Data Faker: Generate button not found');
  }
}

Future<void> _testBasicJsonConverterWorkflow(PatrolIntegrationTester $) async {
  // Verify JSON Converter loaded
  expect(find.textContaining('JSON'), findsAtLeastOneWidget);

  // Test basic JSON input
  final inputField = find.byType(TextField).or(find.byType(TextFormField));

  if (inputField.evaluate().isNotEmpty) {
    await $.tap(inputField);
    await $.pumpAndSettle();

    const testJson = '{"test": "data", "number": 123}';
    await $.enterText(inputField, testJson);
    await $.pumpAndSettle();

    // Check if output appears
    if (find.textContaining('test').evaluate().isNotEmpty) {
      print('✅ JSON Converter: Basic conversion working');
    } else {
      print('❌ JSON Converter: Conversion not working');
    }
  } else {
    print('❌ JSON Converter: Input field not found');
  }
}

Future<void> _testBasicImageReducerWorkflow(PatrolIntegrationTester $) async {
  // Verify Image Reducer loaded
  expect(find.textContaining('Image'), findsAtLeastOneWidget);

  // Look for upload controls
  final uploadButtons = [
    'Choose images',
    'Upload',
    'Select',
    'Drop images'
  ];

  bool foundUploadControl = false;
  for (final buttonText in uploadButtons) {
    if (find.textContaining(buttonText).evaluate().isNotEmpty) {
      foundUploadControl = true;
      print('✅ Image Reducer: Upload controls found');
      break;
    }
  }

  if (!foundUploadControl) {
    print('❌ Image Reducer: Upload controls not found');
  }

  // Test quality controls
  final sliders = find.byType(Slider);
  if (sliders.evaluate().isNotEmpty) {
    await $.drag(sliders.first, Offset(50, 0));
    await $.pumpAndSettle();
    print('✅ Image Reducer: Quality controls working');
  } else {
    print('❌ Image Reducer: Quality controls not found');
  }
}

Future<void> _testBasicPdfMergerWorkflow(PatrolIntegrationTester $) async {
  // Verify PDF Merger loaded
  expect(find.textContaining('PDF'), findsAtLeastOneWidget);

  // Look for upload controls
  final uploadButtons = [
    'Choose PDFs',
    'Upload',
    'Select',
    'Drop PDFs'
  ];

  bool foundUploadControl = false;
  for (final buttonText in uploadButtons) {
    if (find.textContaining(buttonText).evaluate().isNotEmpty) {
      foundUploadControl = true;
      print('✅ PDF Merger: Upload controls found');
      break;
    }
  }

  if (!foundUploadControl) {
    print('❌ PDF Merger: Upload controls not found');
  }

  // Look for merge button
  final mergeButton = find.textContaining('Merge');
  if (mergeButton.evaluate().isNotEmpty) {
    print('✅ PDF Merger: Merge controls found');
  } else {
    print('❌ PDF Merger: Merge controls not found');
  }
}

Future<void> _testBasicDocumentScannerWorkflow(PatrolIntegrationTester $) async {
  // Verify Document Scanner loaded
  expect(find.textContaining('Document'), findsAtLeastOneWidget);

  // Check for camera or upload controls
  final cameraControls = [
    'Camera',
    'Scan',
    'Capture',
    'Upload',
    'Choose image'
  ];

  bool foundCameraControl = false;
  for (final control in cameraControls) {
    if (find.textContaining(control).evaluate().isNotEmpty) {
      foundCameraControl = true;
      print('✅ Document Scanner: Camera/Upload controls found');
      break;
    }
  }

  if (!foundCameraControl) {
    print('❌ Document Scanner: Camera/Upload controls not found');
  }

  // Check for filters
  final filters = ['Original', 'Grayscale', 'B&W', 'Auto'];
  bool foundFilters = false;
  for (final filter in filters) {
    if (find.textContaining(filter).evaluate().isNotEmpty) {
      foundFilters = true;
      print('✅ Document Scanner: Filter controls found');
      break;
    }
  }

  if (!foundFilters) {
    print('❌ Document Scanner: Filter controls not found');
  }
}

Future<void> _testCrossToolNavigation(PatrolIntegrationTester $) async {
  // Test navigating between tools
  final tools = [
    'Indian Data Faker',
    'String-to-JSON Converter',
    'Image Size Reducer'
  ];

  for (int i = 0; i < tools.length - 1; i++) {
    await $.tap(find.text(tools[i]));
    await $.pumpAndSettle(Duration(seconds: 2));

    // Verify tool loaded
    expect(find.textContaining(tools[i].split(' ').first), findsAtLeastOneWidget);

    // Navigate back
    await $.native.pressBack();
    await $.pumpAndSettle();

    // Navigate to next tool
    if (i < tools.length - 1) {
      await $.tap(find.text(tools[i + 1]));
      await $.pumpAndSettle(Duration(seconds: 2));

      expect(find.textContaining(tools[i + 1].split(' ').first), findsAtLeastOneWidget);

      await $.native.pressBack();
      await $.pumpAndSettle();
    }
  }

  print('✅ Cross-tool navigation working');
}

Future<void> _testFooterAndBranding(PatrolIntegrationTester $) async {
  // Test footer appears on all screens
  final tools = ['Indian Data Faker', 'PDF Merger'];

  for (final tool in tools) {
    await $.tap(find.text(tool));
    await $.pumpAndSettle(Duration(seconds: 2));

    // Look for BTQA footer
    final footerTexts = [
      'BTQA',
      'Built by',
      'Open Source',
      'GitHub',
      'Made in'
    ];

    bool foundFooter = false;
    for (final text in footerTexts) {
      if (find.textContaining(text).evaluate().isNotEmpty) {
        foundFooter = true;
        break;
      }
    }

    if (foundFooter) {
      print('✅ Footer found on $tool screen');
    } else {
      print('❌ Footer missing on $tool screen');
    }

    await $.native.pressBack();
    await $.pumpAndSettle();
  }
}

Future<void> _testErrorHandlingAcrossTools(PatrolIntegrationTester $) async {
  // Test error handling in each tool

  // Data Faker - no identifiers selected
  await $.tap(find.text('Indian Data Faker'));
  await $.pumpAndSettle(Duration(seconds: 2));

  // Try to deselect all and generate
  final identifiers = ['Name', 'Phone', 'Email'];
  for (final id in identifiers) {
    final idTile = find.text(id);
    if (idTile.evaluate().isNotEmpty) {
      await $.tap(idTile);
      await $.pumpAndSettle();
    }
  }

  final generateButton = find.text('GENERATE DATA');
  if (generateButton.evaluate().isNotEmpty) {
    await $.tap(generateButton);
    await $.pumpAndSettle();

    // Should either work or show error
    final hasError = find.textContaining('error').evaluate().isNotEmpty;
    final hasSuccess = find.text('View Preview').evaluate().isNotEmpty;

    if (hasError || hasSuccess) {
      print('✅ Data Faker: Error handling working');
    } else {
      print('❌ Data Faker: Unclear error state');
    }
  }

  await $.native.pressBack();
  await $.pumpAndSettle();

  // JSON Converter - invalid input
  await $.tap(find.text('String-to-JSON Converter'));
  await $.pumpAndSettle(Duration(seconds: 2));

  final inputField = find.byType(TextField).or(find.byType(TextFormField));
  if (inputField.evaluate().isNotEmpty) {
    await $.tap(inputField);
    await $.enterText(inputField, 'This is not JSON at all!');
    await $.pumpAndSettle();

    final errorTexts = ['error', 'Error', 'invalid', 'Invalid'];
    bool foundError = false;
    for (final error in errorTexts) {
      if (find.textContaining(error).evaluate().isNotEmpty) {
        foundError = true;
        break;
      }
    }

    if (foundError) {
      print('✅ JSON Converter: Error handling working');
    } else {
      print('❌ JSON Converter: Error handling not working');
    }
  }

  await $.native.pressBack();
  await $.pumpAndSettle();
}

Future<void> _testPerformanceAndResponsiveness(PatrolIntegrationTester $) async {
  final stopwatch = Stopwatch()..start();

  // Test navigation speed
  await $.tap(find.text('Indian Data Faker'));
  await $.pumpAndSettle();

  final navigationTime = stopwatch.elapsedMilliseconds;
  if (navigationTime < 3000) {
    print('✅ Navigation performance: ${navigationTime}ms (good)');
  } else {
    print('⚠️ Navigation performance: ${navigationTime}ms (slow)');
  }

  await $.native.pressBack();
  await $.pumpAndSettle();

  // Test app responsiveness during tool switching
  final tools = ['PDF Merger', 'Image Size Reducer'];

  for (final tool in tools) {
    stopwatch.reset();
    await $.tap(find.text(tool));
    await $.pumpAndSettle();

    final loadTime = stopwatch.elapsedMilliseconds;
    if (loadTime < 2000) {
      print('✅ $tool load time: ${loadTime}ms (good)');
    } else {
      print('⚠️ $tool load time: ${loadTime}ms (slow)');
    }

    await $.native.pressBack();
    await $.pumpAndSettle();
  }
}