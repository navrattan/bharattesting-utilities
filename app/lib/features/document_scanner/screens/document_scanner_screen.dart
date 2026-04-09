import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bharattesting_core/core.dart' as core;
import '../models/document_scanner_state.dart';
import '../providers/document_scanner_provider.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/document_overlay_widget.dart';
import '../widgets/page_thumbnail_list.dart';
import '../widgets/scan_controls_widget.dart';

class DocumentScannerScreen extends ConsumerStatefulWidget {
  const DocumentScannerScreen({super.key});

  @override
  ConsumerState<DocumentScannerScreen> createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends ConsumerState<DocumentScannerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(documentScannerNotifierProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(documentScannerNotifierProvider);
    final notifier = ref.read(documentScannerNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Scanner'),
        actions: [
          IconButton(
            icon: Icon(state.enableFlash ? Icons.flash_on : Icons.flash_off),
            onPressed: () => notifier.toggleFlash(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context, state, notifier),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                if (state.isCameraInitialized && state.cameraController != null)
                  CameraPreviewWidget(controller: state.cameraController!)
                else
                  const Center(child: CircularProgressIndicator()),
                
                if (state.detectedDocument != null)
                  DocumentOverlayWidget(
                    quadrilateral: state.detectedDocument!,
                    isStable: state.isDocumentStable,
                  ),
                
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: ScanControlsWidget(
                    isCapturing: state.isCapturing,
                    isAutoCapture: state.isAutoCapture,
                    canCapture: state.isCameraInitialized,
                    enableFlash: state.enableFlash,
                    zoomLevel: state.zoomLevel,
                    mode: state.mode,
                    onCapture: () => notifier.captureDocument(),
                    onAutoCaptureToggle: () => notifier.toggleAutoCapture(),
                    onFlashToggle: () => notifier.toggleFlash(),
                    onSwitchMode: () {
                      final newMode = state.mode == ScannerMode.camera ? ScannerMode.upload : ScannerMode.camera;
                      notifier.setScannerMode(newMode);
                    },
                    onZoomChanged: (val) => notifier.setZoomLevel(val),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: PageThumbnailList(
              pages: state.scannedPages,
              selectedPageId: state.selectedPage?.id,
              onPageSelected: (page) => notifier.selectPage(page),
              onPageDeleted: (id) => notifier.deletePage(id),
              onPagesReordered: (oldIdx, newIdx) => notifier.reorderPages(oldIdx, newIdx),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context, DocumentScannerState state, DocumentScannerNotifier notifier) {
    // Show settings sheet
  }
}
