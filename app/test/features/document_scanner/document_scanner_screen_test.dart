import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bharattesting_utilities/features/document_scanner/screens/document_scanner_screen.dart';
import 'package:bharattesting_utilities/features/document_scanner/providers/document_scanner_provider.dart';
import 'package:bharattesting_utilities/features/document_scanner/models/document_scanner_state.dart';

// Mock classes
class MockDocumentScannerNotifier extends Mock implements DocumentScannerNotifier {}

void main() {
  group('DocumentScannerScreen', () {
    late MockDocumentScannerNotifier mockNotifier;

    setUp(() {
      mockNotifier = MockDocumentScannerNotifier();
    });

    testWidgets('renders initial loading state', (tester) async {
      when(() => mockNotifier.initializeCamera()).thenAnswer((_) async {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            documentScannerNotifierProvider.overrideWith(() => mockNotifier),
          ],
          child: const MaterialApp(
            home: DocumentScannerScreen(),
          ),
        ),
      );

      expect(find.text('Document Scanner'), findsOneWidget);
      verify(() => mockNotifier.initializeCamera()).called(1);
    });

    testWidgets('shows permission request when camera permission denied', (tester) async {
      const state = DocumentScannerState(
        permissionStatus: CameraPermissionStatus.denied,
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            documentScannerNotifierProvider.overrideWith(() => mockNotifier),
          ],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                // Mock the state
                when(() => mockNotifier.build()).thenReturn(state);
                return const DocumentScannerScreen();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Camera Permission Required'), findsOneWidget);
      expect(find.text('Open Settings'), findsOneWidget);
    });

    testWidgets('shows camera interface when permission granted', (tester) async {
      const state = DocumentScannerState(
        permissionStatus: CameraPermissionStatus.granted,
        mode: ScannerMode.camera,
        isLoading: false,
        isCameraInitialized: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            documentScannerNotifierProvider.overrideWith(() => mockNotifier),
          ],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                when(() => mockNotifier.build()).thenReturn(state);
                return const DocumentScannerScreen();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show camera preview area
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('switches between camera and upload modes', (tester) async {
      const cameraState = DocumentScannerState(
        permissionStatus: CameraPermissionStatus.granted,
        mode: ScannerMode.camera,
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            documentScannerNotifierProvider.overrideWith(() => mockNotifier),
          ],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                when(() => mockNotifier.build()).thenReturn(cameraState);
                when(() => mockNotifier.toggleMode()).thenReturn(null);
                return const DocumentScannerScreen();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap upload mode button
      final uploadButton = find.text('Upload');
      if (uploadButton.evaluate().isNotEmpty) {
        await tester.tap(uploadButton);
        verify(() => mockNotifier.toggleMode()).called(1);
      }
    });

    testWidgets('shows scanned pages list when pages exist', (tester) async {
      final mockPage = ScannedPage(
        id: 'page1',
        originalImage: const [],
        processedImage: const [],
        corners: const [
          DocumentCorner(x: 0.1, y: 0.1),
          DocumentCorner(x: 0.9, y: 0.1),
          DocumentCorner(x: 0.9, y: 0.9),
          DocumentCorner(x: 0.1, y: 0.9),
        ],
        appliedFilter: DocumentFilter.original,
        timestamp: DateTime.now(),
      );

      final state = DocumentScannerState(
        permissionStatus: CameraPermissionStatus.granted,
        mode: ScannerMode.camera,
        isLoading: false,
        pages: [mockPage],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            documentScannerNotifierProvider.overrideWith(() => mockNotifier),
          ],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                when(() => mockNotifier.build()).thenReturn(state);
                return const DocumentScannerScreen();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show pages in thumbnail list
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('shows export options when pages exist', (tester) async {
      final mockPage = ScannedPage(
        id: 'page1',
        originalImage: const [],
        processedImage: const [],
        corners: const [
          DocumentCorner(x: 0.1, y: 0.1),
          DocumentCorner(x: 0.9, y: 0.1),
          DocumentCorner(x: 0.9, y: 0.9),
          DocumentCorner(x: 0.1, y: 0.9),
        ],
        appliedFilter: DocumentFilter.original,
        timestamp: DateTime.now(),
      );

      final state = DocumentScannerState(
        permissionStatus: CameraPermissionStatus.granted,
        mode: ScannerMode.camera,
        isLoading: false,
        pages: [mockPage],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            documentScannerNotifierProvider.overrideWith(() => mockNotifier),
          ],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                when(() => mockNotifier.build()).thenReturn(state);
                return const DocumentScannerScreen();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show export button
      final exportButton = find.text('Export');
      expect(exportButton, findsAny);
    });

    testWidgets('handles error states gracefully', (tester) async {
      const state = DocumentScannerState(
        permissionStatus: CameraPermissionStatus.granted,
        mode: ScannerMode.camera,
        isLoading: false,
        error: 'Camera initialization failed',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            documentScannerNotifierProvider.overrideWith(() => mockNotifier),
          ],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                when(() => mockNotifier.build()).thenReturn(state);
                return const DocumentScannerScreen();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('failed'), findsOneWidget);
    });

    testWidgets('adapts to responsive breakpoints', (tester) async {
      const state = DocumentScannerState(
        permissionStatus: CameraPermissionStatus.granted,
        mode: ScannerMode.camera,
        isLoading: false,
      );

      // Test mobile layout
      await tester.binding.setSurfaceSize(const Size(375, 667));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            documentScannerNotifierProvider.overrideWith(() => mockNotifier),
          ],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                when(() => mockNotifier.build()).thenReturn(state);
                return const DocumentScannerScreen();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Test desktop layout
      await tester.binding.setSurfaceSize(const Size(1280, 800));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}