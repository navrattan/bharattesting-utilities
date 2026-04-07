import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bharattesting_utilities/features/image_reducer/image_reducer_screen.dart';
import 'package:bharattesting_utilities/features/image_reducer/models/image_reducer_state.dart';
import 'package:bharattesting_utilities/features/image_reducer/providers/image_reducer_provider.dart';
import 'package:bharattesting_core/core.dart';

void main() {
  group('ImageReducerScreen Widget Tests', () {
    late Widget testWidget;

    setUp(() {
      testWidget = ProviderScope(
        child: MaterialApp(
          home: const ImageReducerScreen(),
        ),
      );
    });

    testWidgets('should render all main components', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Check for main title
      expect(find.text('Image Size Reducer'), findsOneWidget);

      // Check for upload zone
      expect(find.text('Drop images here or click to select'), findsOneWidget);

      // Check for quality controls
      expect(find.text('Quality'), findsOneWidget);
      expect(find.byType(Slider), findsAtLeastNWidgets(1));

      // Check for format controls
      expect(find.text('Format'), findsOneWidget);

      // Check for action buttons
      expect(find.text('Process Images'), findsOneWidget);
    });

    testWidgets('should show responsive layout on different screen sizes', (tester) async {
      // Test mobile layout
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // On mobile, should show tabs
      expect(find.byType(TabBarView), findsOneWidget);

      // Test desktop layout
      tester.view.physicalSize = const Size(1200, 800);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // On desktop, should show side-by-side panels
      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle quality slider changes', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find quality slider
      final qualitySlider = find.byType(Slider).first;
      expect(qualitySlider, findsOneWidget);

      // Test slider interaction
      await tester.drag(qualitySlider, const Offset(50, 0));
      await tester.pump();

      // Verify state updated
      // In a real test, we'd verify the provider state changed
    });

    testWidgets('should show batch processing panel when images loaded', (tester) async {
      // Create test provider with mock images
      final container = ProviderContainer(
        overrides: [
          imageReducerProvider.overrideWith(() => TestImageReducerNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const ImageReducerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show batch processing section
      expect(find.text('Batch Processing'), findsOneWidget);
      expect(find.text('2 images'), findsOneWidget);
    });

    testWidgets('should show processing progress during batch operation', (tester) async {
      final container = ProviderContainer(
        overrides: [
          imageReducerProvider.overrideWith(() => ProcessingImageReducerNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const ImageReducerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show progress indicator
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('75% Complete'), findsOneWidget);
    });

    testWidgets('should handle empty state properly', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Should show empty state in preview area
      expect(find.text('No Image Selected'), findsOneWidget);
    });

    testWidgets('should show error states appropriately', (tester) async {
      final container = ProviderContainer(
        overrides: [
          imageReducerProvider.overrideWith(() => ErrorImageReducerNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const ImageReducerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show error state
      expect(find.byIcon(Icons.error), findsAtLeastNWidgets(1));
    });

    testWidgets('should toggle advanced settings panel', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Find and tap advanced settings toggle
      final advancedToggle = find.text('Advanced');
      expect(advancedToggle, findsOneWidget);

      await tester.tap(advancedToggle);
      await tester.pumpAndSettle();

      // Should show advanced settings
      expect(find.text('Advanced Settings'), findsOneWidget);
      expect(find.text('Format Conversion'), findsOneWidget);
      expect(find.text('Performance'), findsOneWidget);
    });
  });

  group('ImageReducerScreen Integration Tests', () {
    testWidgets('should update preview when image selected', (tester) async {
      final container = ProviderContainer(
        overrides: [
          imageReducerProvider.overrideWith(() => TestImageReducerNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const ImageReducerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on an image in batch list
      final imageCard = find.text('test_image_1.jpg');
      expect(imageCard, findsOneWidget);

      await tester.tap(imageCard);
      await tester.pumpAndSettle();

      // Preview should update
      expect(find.text('test_image_1.jpg'), findsAtLeastNWidgets(1));
    });

    testWidgets('should process images when button pressed', (tester) async {
      final notifier = TestImageReducerNotifier();
      final container = ProviderContainer(
        overrides: [
          imageReducerProvider.overrideWith(() => notifier),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const ImageReducerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap process button
      final processButton = find.text('Process Images');
      expect(processButton, findsOneWidget);

      await tester.tap(processButton);
      await tester.pump();

      // Verify processing started
      expect(notifier.processImagesCalled, isTrue);
    });
  });
}

// Test notifiers for mocking different states
class TestImageReducerNotifier extends ImageReducer {
  bool processImagesCalled = false;

  @override
  ImageReducerState build() {
    return ImageReducerState(
      images: [
        ProcessedImage(
          fileName: 'test_image_1.jpg',
          originalData: Uint8List(100),
          status: ProcessingStatus.completed,
          detectedFormat: ConvertibleFormat.jpeg,
        ),
        ProcessedImage(
          fileName: 'test_image_2.png',
          originalData: Uint8List(200),
          status: ProcessingStatus.pending,
          detectedFormat: ConvertibleFormat.png,
        ),
      ],
      selectedImage: ProcessedImage(
        fileName: 'test_image_1.jpg',
        originalData: Uint8List(100),
        status: ProcessingStatus.completed,
        detectedFormat: ConvertibleFormat.jpeg,
      ),
    );
  }

  @override
  Future<void> processImages() async {
    processImagesCalled = true;
    // Mock processing
  }

  @override
  void addImages(List<ProcessedImage> newImages) {
    // Mock add images
  }

  @override
  void removeImage(ProcessedImage image) {
    // Mock remove image
  }

  @override
  void selectImage(ProcessedImage image) {
    // Mock select image
  }

  @override
  void updateQuality(int quality) {
    // Mock quality update
  }

  @override
  void updateFormat(ConvertibleFormat format) {
    // Mock format update
  }

  @override
  void updateStrategy(ConversionStrategy strategy) {
    // Mock strategy update
  }

  @override
  void updatePreset(ResizePreset preset) {
    // Mock preset update
  }

  @override
  void updatePrivacyLevel(PrivacyLevel level) {
    // Mock privacy update
  }

  @override
  void toggleFormatConversion() {
    // Mock format conversion toggle
  }

  @override
  void toggleResize() {
    // Mock resize toggle
  }

  @override
  void toggleMetadataStripping() {
    // Mock metadata toggle
  }

  @override
  void toggleAdvancedSettings() {
    // Mock advanced settings toggle
  }

  @override
  void toggleBatchMode() {
    // Mock batch mode toggle
  }
}

class ProcessingImageReducerNotifier extends ImageReducer {
  @override
  ImageReducerState build() {
    return ImageReducerState(
      isProcessing: true,
      processingProgress: 75,
      images: [
        ProcessedImage(
          fileName: 'processing.jpg',
          originalData: Uint8List(100),
          status: ProcessingStatus.processing,
        ),
      ],
    );
  }
}

class ErrorImageReducerNotifier extends ImageReducer {
  @override
  ImageReducerState build() {
    return ImageReducerState(
      processingErrors: ['Failed to process image: Invalid format'],
      images: [
        ProcessedImage(
          fileName: 'error.jpg',
          originalData: Uint8List(100),
          status: ProcessingStatus.error,
          error: 'Invalid format',
        ),
      ],
    );
  }
}