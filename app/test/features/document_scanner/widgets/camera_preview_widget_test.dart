import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:camera/camera.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/camera_preview_widget.dart';
import 'package:bharattesting_utilities/features/document_scanner/models/document_scanner_state.dart';

// Mock classes
class MockCameraController extends Mock implements CameraController {}

void main() {
  group('CameraPreviewWidget', () {
    late MockCameraController mockController;

    setUp(() {
      mockController = MockCameraController();
      when(() => mockController.value).thenReturn(
        const CameraValue(
          isInitialized: true,
          isRecordingVideo: false,
          isTakingPicture: false,
          isStreamingImages: false,
          isRecordingPaused: false,
          flashMode: FlashMode.auto,
          exposureMode: ExposureMode.auto,
          focusMode: FocusMode.auto,
          exposurePointSupported: true,
          focusPointSupported: true,
          deviceOrientation: DeviceOrientation.portraitUp,
          lockedCaptureOrientation: null,
          recordingOrientation: null,
          isPreviewPaused: false,
          previewSize: Size(640, 480),
          aspectRatio: 4/3,
          hasError: false,
        ),
      );
    });

    testWidgets('renders loading indicator when controller is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CameraPreviewWidget(
              controller: null,
              onTap: null,
              showGrid: false,
              aspectRatio: 16/9,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading camera...'), findsOneWidget);
    });

    testWidgets('renders camera preview when controller is initialized', (tester) async {
      when(() => mockController.buildPreview()).thenReturn(
        Container(
          width: 640,
          height: 480,
          color: Colors.black,
          child: const Center(child: Text('Camera Preview')),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CameraPreviewWidget(
              controller: mockController,
              onTap: (_) {},
              showGrid: true,
              aspectRatio: 16/9,
            ),
          ),
        ),
      );

      expect(find.text('Camera Preview'), findsOneWidget);
    });

    testWidgets('shows grid overlay when showGrid is true', (tester) async {
      when(() => mockController.buildPreview()).thenReturn(
        Container(
          width: 640,
          height: 480,
          color: Colors.black,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CameraPreviewWidget(
              controller: mockController,
              onTap: (_) {},
              showGrid: true,
              aspectRatio: 16/9,
            ),
          ),
        ),
      );

      // Grid should be visible
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('hides grid overlay when showGrid is false', (tester) async {
      when(() => mockController.buildPreview()).thenReturn(
        Container(
          width: 640,
          height: 480,
          color: Colors.black,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CameraPreviewWidget(
              controller: mockController,
              onTap: (_) {},
              showGrid: false,
              aspectRatio: 16/9,
            ),
          ),
        ),
      );

      // Should not show grid overlay
      expect(find.byType(CustomPaint), findsNothing);
    });

    testWidgets('handles tap events correctly', (tester) async {
      bool tapCalled = false;
      Offset? tapOffset;

      when(() => mockController.buildPreview()).thenReturn(
        Container(
          width: 640,
          height: 480,
          color: Colors.black,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CameraPreviewWidget(
              controller: mockController,
              onTap: (offset) {
                tapCalled = true;
                tapOffset = offset;
              },
              showGrid: false,
              aspectRatio: 16/9,
            ),
          ),
        ),
      );

      // Tap on the preview
      await tester.tapAt(const Offset(100, 100));
      await tester.pump();

      expect(tapCalled, isTrue);
      expect(tapOffset, isNotNull);
    });

    testWidgets('maintains aspect ratio correctly', (tester) async {
      when(() => mockController.buildPreview()).thenReturn(
        Container(
          width: 640,
          height: 480,
          color: Colors.black,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: CameraPreviewWidget(
                controller: mockController,
                onTap: (_) {},
                showGrid: false,
                aspectRatio: 16/9,
              ),
            ),
          ),
        ),
      );

      final aspectRatioWidget = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatioWidget.aspectRatio, equals(16/9));
    });

    testWidgets('handles controller errors gracefully', (tester) async {
      when(() => mockController.value).thenReturn(
        const CameraValue(
          isInitialized: false,
          isRecordingVideo: false,
          isTakingPicture: false,
          isStreamingImages: false,
          isRecordingPaused: false,
          flashMode: FlashMode.auto,
          exposureMode: ExposureMode.auto,
          focusMode: FocusMode.auto,
          exposurePointSupported: false,
          focusPointSupported: false,
          deviceOrientation: DeviceOrientation.portraitUp,
          lockedCaptureOrientation: null,
          recordingOrientation: null,
          isPreviewPaused: false,
          previewSize: null,
          aspectRatio: 1.0,
          hasError: true,
          errorDescription: 'Camera error',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CameraPreviewWidget(
              controller: mockController,
              onTap: (_) {},
              showGrid: false,
              aspectRatio: 16/9,
            ),
          ),
        ),
      );

      expect(find.text('Camera error'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('adapts to different screen sizes', (tester) async {
      when(() => mockController.buildPreview()).thenReturn(
        Container(color: Colors.black),
      );

      // Test mobile size
      await tester.binding.setSurfaceSize(const Size(375, 667));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CameraPreviewWidget(
              controller: mockController,
              onTap: (_) {},
              showGrid: false,
              aspectRatio: 16/9,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Test tablet size
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('supports focus and exposure controls when available', (tester) async {
      when(() => mockController.buildPreview()).thenReturn(
        Container(color: Colors.black),
      );

      when(() => mockController.value).thenReturn(
        const CameraValue(
          isInitialized: true,
          isRecordingVideo: false,
          isTakingPicture: false,
          isStreamingImages: false,
          isRecordingPaused: false,
          flashMode: FlashMode.auto,
          exposureMode: ExposureMode.auto,
          focusMode: FocusMode.auto,
          exposurePointSupported: true,
          focusPointSupported: true,
          deviceOrientation: DeviceOrientation.portraitUp,
          lockedCaptureOrientation: null,
          recordingOrientation: null,
          isPreviewPaused: false,
          previewSize: Size(640, 480),
          aspectRatio: 4/3,
          hasError: false,
        ),
      );

      bool tapCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CameraPreviewWidget(
              controller: mockController,
              onTap: (_) {
                tapCalled = true;
              },
              showGrid: false,
              aspectRatio: 16/9,
            ),
          ),
        ),
      );

      await tester.tapAt(const Offset(200, 200));
      await tester.pump();

      expect(tapCalled, isTrue);
    });
  });
}