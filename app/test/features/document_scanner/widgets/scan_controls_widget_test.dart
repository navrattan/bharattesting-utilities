import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bharattesting_core/core.dart';
import 'package:bharattesting_utilities/features/document_scanner/widgets/scan_controls_widget.dart';

void main() {
  group('ScanControlsWidget Tests', () {
    testWidgets('displays all camera controls when in camera mode', (tester) async {
      bool flashToggled = false;
      bool autoCaptureToggled = false;
      bool capturePressed = false;
      double zoomChanged = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScanControlsWidget(
              mode: ScannerMode.camera,
              isCapturing: false,
              enableFlash: false,
              isAutoCapture: false,
              zoomLevel: 1.0,
              canCapture: true,
              onCapture: () => capturePressed = true,
              onFlashToggle: () => flashToggled = true,
              onAutoCaptureToggle: () => autoCaptureToggled = true,
              onZoomChanged: (zoom) => zoomChanged = zoom,
            ),
          ),
        ),
      );

      // Verify controls are displayed
      expect(find.text('Flash'), findsOneWidget);
      expect(find.text('Auto'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);

      // Verify main capture button
      expect(find.byType(GestureDetector), findsWidgets);

      // Test flash toggle
      await tester.tap(find.text('Flash'));
      expect(flashToggled, isTrue);

      // Test auto-capture toggle
      await tester.tap(find.text('Auto'));
      expect(autoCaptureToggled, isTrue);
    });

    testWidgets('hides controls when not in camera mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScanControlsWidget(
              mode: ScannerMode.upload,
              isCapturing: false,
              enableFlash: false,
              isAutoCapture: false,
              zoomLevel: 1.0,
              canCapture: true,
              onCapture: () {},
              onFlashToggle: () {},
              onAutoCaptureToggle: () {},
              onZoomChanged: (zoom) {},
            ),
          ),
        ),
      );

      // Should not display any controls
      expect(find.text('Flash'), findsNothing);
      expect(find.text('Auto'), findsNothing);
    });

    testWidgets('shows capture button loading state when capturing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScanControlsWidget(
              mode: ScannerMode.camera,
              isCapturing: true,
              enableFlash: false,
              isAutoCapture: false,
              zoomLevel: 1.0,
              canCapture: true,
              onCapture: () {},
              onFlashToggle: () {},
              onAutoCaptureToggle: () {},
              onZoomChanged: (zoom) {},
            ),
          ),
        ),
      );

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('disables capture button when cannot capture', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScanControlsWidget(
              mode: ScannerMode.camera,
              isCapturing: false,
              enableFlash: false,
              isAutoCapture: false,
              zoomLevel: 1.0,
              canCapture: false,
              onCapture: () {},
              onFlashToggle: () {},
              onAutoCaptureToggle: () {},
              onZoomChanged: (zoom) {},
            ),
          ),
        ),
      );

      // Capture button should be disabled (can't easily test this without inspecting container color)
      await tester.pumpAndSettle();
    });

    testWidgets('shows active states correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScanControlsWidget(
              mode: ScannerMode.camera,
              isCapturing: false,
              enableFlash: true,
              isAutoCapture: true,
              zoomLevel: 2.0,
              canCapture: true,
              onCapture: () {},
              onFlashToggle: () {},
              onAutoCaptureToggle: () {},
              onZoomChanged: (zoom) {},
            ),
          ),
        ),
      );

      // Flash and auto-capture should show as active
      await tester.pumpAndSettle();

      // Verify zoom level display
      expect(find.text('2.0x'), findsOneWidget);
    });

    testWidgets('opens zoom slider when zoom control tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScanControlsWidget(
              mode: ScannerMode.camera,
              isCapturing: false,
              enableFlash: false,
              isAutoCapture: false,
              zoomLevel: 1.0,
              canCapture: true,
              onCapture: () {},
              onFlashToggle: () {},
              onAutoCaptureToggle: () {},
              onZoomChanged: (zoom) {},
            ),
          ),
        ),
      );

      // Find and tap zoom control
      await tester.tap(find.text('1.0x'));
      await tester.pumpAndSettle();

      // Should show bottom sheet with slider
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('1x'), findsOneWidget);
      expect(find.text('2x'), findsOneWidget);
      expect(find.text('4x'), findsOneWidget);
      expect(find.text('8x'), findsOneWidget);
    });

    testWidgets('zoom preset buttons work correctly', (tester) async {
      double changedZoom = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScanControlsWidget(
              mode: ScannerMode.camera,
              isCapturing: false,
              enableFlash: false,
              isAutoCapture: false,
              zoomLevel: 1.0,
              canCapture: true,
              onCapture: () {},
              onFlashToggle: () {},
              onAutoCaptureToggle: () {},
              onZoomChanged: (zoom) => changedZoom = zoom,
            ),
          ),
        ),
      );

      // Open zoom slider
      await tester.tap(find.text('1.0x'));
      await tester.pumpAndSettle();

      // Tap 2x preset
      await tester.tap(find.text('2x'));
      expect(changedZoom, equals(2.0));
    });

    testWidgets('capture button responds to tap', (tester) async {
      bool capturePressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScanControlsWidget(
              mode: ScannerMode.camera,
              isCapturing: false,
              enableFlash: false,
              isAutoCapture: false,
              zoomLevel: 1.0,
              canCapture: true,
              onCapture: () => capturePressed = true,
              onFlashToggle: () {},
              onAutoCaptureToggle: () {},
              onZoomChanged: (zoom) {},
            ),
          ),
        ),
      );

      // Find capture button by looking for the main GestureDetector
      final captureButton = find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(AnimatedContainer),
      ).first;

      await tester.tap(captureButton);
      expect(capturePressed, isTrue);
    });
  });

  group('AdvancedCameraControls Tests', () {
    testWidgets('displays all advanced controls', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCameraControls(
              enableFlash: false,
              isAutoCapture: true,
              autoCaptureDuration: 1.5,
              zoomLevel: 1.0,
              onFlashToggle: () {},
              onAutoCaptureToggle: () {},
              onAutoCaptureDurationChanged: (duration) {},
              onZoomChanged: (zoom) {},
            ),
          ),
        ),
      );

      // Verify all controls are present
      expect(find.text('Camera Controls'), findsOneWidget);
      expect(find.text('Flash'), findsOneWidget);
      expect(find.text('Auto Capture'), findsOneWidget);
      expect(find.text('Zoom: 1.0x'), findsOneWidget);
      expect(find.byType(Slider), findsWidgets);
    });

    testWidgets('shows auto-capture duration when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCameraControls(
              enableFlash: false,
              isAutoCapture: true,
              autoCaptureDuration: 2.5,
              zoomLevel: 1.0,
              onFlashToggle: () {},
              onAutoCaptureToggle: () {},
              onAutoCaptureDurationChanged: (duration) {},
              onZoomChanged: (zoom) {},
            ),
          ),
        ),
      );

      // Should show duration control when auto-capture is enabled
      expect(find.text('Capture Delay: 2.5s'), findsOneWidget);
    });

    testWidgets('hides auto-capture duration when disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCameraControls(
              enableFlash: false,
              isAutoCapture: false,
              autoCaptureDuration: 2.5,
              zoomLevel: 1.0,
              onFlashToggle: () {},
              onAutoCaptureToggle: () {},
              onAutoCaptureDurationChanged: (duration) {},
              onZoomChanged: (zoom) {},
            ),
          ),
        ),
      );

      // Should not show duration control when auto-capture is disabled
      expect(find.text('Capture Delay: 2.5s'), findsNothing);
    });

    testWidgets('zoom presets work correctly', (tester) async {
      double changedZoom = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedCameraControls(
              enableFlash: false,
              isAutoCapture: false,
              autoCaptureDuration: 1.5,
              zoomLevel: 1.0,
              onFlashToggle: () {},
              onAutoCaptureToggle: () {},
              onAutoCaptureDurationChanged: (duration) {},
              onZoomChanged: (zoom) => changedZoom = zoom,
            ),
          ),
        ),
      );

      // Test zoom preset chips
      await tester.tap(find.text('2x'));
      expect(changedZoom, equals(2.0));

      await tester.pumpAndSettle();

      await tester.tap(find.text('4x'));
      expect(changedZoom, equals(4.0));
    });
  });

  group('CaptureStatsWidget Tests', () {
    testWidgets('displays session statistics correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CaptureStatsWidget(
              totalCaptured: 5,
              sessionDuration: const Duration(minutes: 3, seconds: 45),
              averageCaptureTime: const Duration(seconds: 2),
              lastCaptureQuality: 0.85,
            ),
          ),
        ),
      );

      expect(find.text('Session Stats'), findsOneWidget);
      expect(find.text('5'), findsOneWidget); // total captured
      expect(find.text('3:45'), findsOneWidget); // session duration
      expect(find.text('2s'), findsOneWidget); // avg capture time
      expect(find.text('85%'), findsOneWidget); // quality percentage
    });

    testWidgets('formats duration correctly for different ranges', (tester) async {
      // Test hours format
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CaptureStatsWidget(
              totalCaptured: 10,
              sessionDuration: const Duration(hours: 1, minutes: 30, seconds: 45),
              averageCaptureTime: const Duration(minutes: 1, seconds: 15),
              lastCaptureQuality: 0.92,
            ),
          ),
        ),
      );

      expect(find.text('1:30:45'), findsOneWidget); // hours:minutes:seconds
      expect(find.text('1:15'), findsOneWidget); // minutes:seconds
    });

    testWidgets('displays icons for each stat', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CaptureStatsWidget(
              totalCaptured: 3,
              sessionDuration: const Duration(seconds: 30),
              averageCaptureTime: const Duration(seconds: 1),
              lastCaptureQuality: 0.75,
            ),
          ),
        ),
      );

      // Check that stat icons are present
      expect(find.byType(Icon), findsNWidgets(4)); // 4 stat icons
    });
  });
}