import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/l10n.dart';
import '../providers/document_scanner_provider.dart';
import '../models/document_scanner_state.dart';
import '../widgets/upload_drop_zone.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/scan_controls_widget.dart';

class DocumentScannerScreen extends ConsumerWidget {
  const DocumentScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(documentScannerNotifierProvider);
    final notifier = ref.read(documentScannerNotifierProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          if (state.isProcessing || state.isCapturing)
            const LinearProgressIndicator(),
          
          Expanded(
            child: state.scannedPages.isEmpty
                ? _buildEmptyState(context, notifier)
                : _buildScannerInterface(context, state, notifier),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, DocumentScannerNotifier notifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: UploadDropZone(
          onImageUploaded: (bytes) => notifier.uploadImage(),
          // Note: In a real app, you'd pass the bytes directly to a method
          // that adds them as a new page. DocumentScannerNotifier.uploadImage()
          // internally uses FilePicker, but for drop zone we can use addDocument logic
          // if it existed. Since uploadImage is available, we use that for now.
        ),
      ),
    );
  }

  Widget _buildScannerInterface(
    BuildContext context,
    DocumentScannerState state,
    DocumentScannerNotifier notifier,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        if (isWide) {
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildPreview(state, notifier),
              ),
              const VerticalDivider(width: 1),
              SizedBox(
                width: 350,
                child: _buildControls(state, notifier),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: _buildPreview(state, notifier),
              ),
              const Divider(height: 1),
              _buildControls(state, notifier),
            ],
          );
        }
      },
    );
  }

  Widget _buildPreview(DocumentScannerState state, DocumentScannerNotifier notifier) {
    if (state.mode == ScannerMode.camera && state.cameraController != null) {
      return CameraPreviewWidget(
        controller: state.cameraController!,
        onTap: (offset) => notifier.setZoomLevel(1.0), // Simplified
      );
    } else {
      // Show list of scanned pages or the selected page
      if (state.scannedPages.isNotEmpty) {
        final displayPage = state.selectedPage ?? state.scannedPages.last;
        return Center(
          child: displayPage.processedImageData != null 
              ? Image.memory(displayPage.processedImageData!)
              : Image.memory(displayPage.originalImageData),
        );
      }
      return const Center(child: Text('No images captured'));
    }
  }

  Widget _buildControls(DocumentScannerState state, DocumentScannerNotifier notifier) {
    return ScanControlsWidget(
      isCapturing: state.isCapturing,
      isAutoCapture: state.isAutoCapture,
      canCapture: state.isCameraInitialized,
      enableFlash: state.enableFlash,
      zoomLevel: state.zoomLevel,
      mode: state.mode,
      onCapture: () => notifier.captureDocument(),
      onAutoCaptureToggle: () => notifier.toggleAutoCapture(),
      onFlashToggle: () => notifier.toggleFlash(),
      onSwitchMode: () => notifier.setScannerMode(
        state.mode == ScannerMode.camera ? ScannerMode.upload : ScannerMode.camera
      ),
      onZoomChanged: (zoom) => notifier.setZoomLevel(zoom),
    );
  }
}
