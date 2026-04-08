import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/l10n.dart';
import '../../../shared/widgets/tool_scaffold.dart';
import '../models/document_scanner_state.dart';
import '../providers/document_scanner_provider.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/document_overlay_widget.dart';
import '../widgets/page_thumbnail_list.dart';
import '../widgets/scan_controls_widget.dart';
import '../widgets/upload_drop_zone.dart';

class DocumentScannerScreen extends ConsumerStatefulWidget {
  const DocumentScannerScreen({super.key});

  @override
  ConsumerState<DocumentScannerScreen> createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends ConsumerState<DocumentScannerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(documentScannerNotifierProvider.notifier).initializeCamera());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(documentScannerNotifierProvider);
    final notifier = ref.read(documentScannerNotifierProvider.notifier);

    return ToolScaffold(
      title: context.l10n.documentScannerTitle,
      body: Column(
        children: [
          // Main view area (Camera or Upload)
          Expanded(
            child: _buildMainView(state, notifier),
          ),

          // Bottom toolbar / thumbnail list
          if (state.scannedPages.isNotEmpty)
            _buildThumbnailStrip(state, notifier),
        ],
      ),
    );
  }

  Widget _buildMainView(DocumentScannerState state, DocumentScannerNotifier notifier) {
    if (state.mode == ScannerMode.upload) {
      return UploadDropZone(
        onImageUploaded: notifier.uploadImage,
      );
    }

    if (state.permissionStatus != CameraPermissionStatus.granted) {
      return _buildPermissionRequest(state, notifier);
    }

    if (!state.isCameraInitialized || state.cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreviewWidget(controller: state.cameraController!),
        if (state.detectedDocument != null)
          DocumentOverlayWidget(
            quadrilateral: state.detectedDocument!,
            isStable: state.isDocumentStable,
          ),
        _buildScannerControls(state, notifier),
      ],
    );
  }

  Widget _buildScannerControls(DocumentScannerState state, DocumentScannerNotifier notifier) {
    return Positioned(
      bottom: 24,
      left: 0,
      right: 0,
      child: ScanControlsWidget(
        isCapturing: state.isCapturing,
        isAutoCapture: state.isAutoCapture,
        onCapture: notifier.captureDocument,
        onAutoCaptureToggle: notifier.toggleAutoCapture,
        onFlashToggle: notifier.toggleFlash,
        enableFlash: state.enableFlash,
        onSwitchMode: () => notifier.changeScannerMode(ScannerMode.upload),
        canCapture: state.isCameraInitialized && !state.isCapturing,
        mode: state.mode,
        zoomLevel: state.zoomLevel,
        onZoomChanged: notifier.setZoomLevel,
      ),
    );
  }

  Widget _buildThumbnailStrip(DocumentScannerState state, DocumentScannerNotifier notifier) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: PageThumbnailList(
              pages: state.scannedPages,
              selectedPageId: state.selectedPage?.id,
              onPageSelected: (page) => notifier.selectPage(page?.id ?? "" ),
              onPageDeleted: notifier.deletePage,
              onPagesReordered: notifier.reorderPages,
            ),
          ),
          _buildExportButton(state, notifier),
        ],
      ),
    );
  }

  Widget _buildExportButton(DocumentScannerState state, DocumentScannerNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: state.scannedPages.isEmpty ? null : notifier.exportDocuments,
            child: const Text('Export'),
          ),
          const SizedBox(height: 8),
          Text(
            '${state.scannedPages.length} pages',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRequest(DocumentScannerState state, DocumentScannerNotifier notifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined, size: 64),
          const SizedBox(height: 16),
          const Text('Camera permission is required for scanning'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: notifier.initializeCamera,
            child: const Text('Grant Permission'),
          ),
          TextButton(
            onPressed: () => notifier.changeScannerMode(ScannerMode.upload),
            child: const Text('Use Upload Mode Instead'),
          ),
        ],
      ),
    );
  }
}
