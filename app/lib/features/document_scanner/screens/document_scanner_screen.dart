import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../shared/widgets/tool_scaffold.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../shared/widgets/btqa_footer.dart';
import '../../../l10n/l10n.dart';
import '../models/document_scanner_state.dart';
import '../providers/document_scanner_provider.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/document_overlay_widget.dart';
import '../widgets/scan_controls_widget.dart';
import '../widgets/page_thumbnail_list.dart';
import '../widgets/filter_selector_widget.dart';
import '../widgets/export_options_widget.dart';
import '../widgets/upload_drop_zone.dart';

class DocumentScannerScreen extends ConsumerStatefulWidget {
  const DocumentScannerScreen({super.key});

  @override
  ConsumerState<DocumentScannerScreen> createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends ConsumerState<DocumentScannerScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize camera when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(documentScannerNotifierProvider.notifier).initializeCamera();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = ref.read(documentScannerNotifierProvider).cameraController;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      ref.read(documentScannerNotifierProvider.notifier).initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(documentScannerNotifierProvider);
    final l10n = context.l10n;

    return ToolScaffold(
      title: l10n.documentScannerTitle,
      subtitle: l10n.documentScannerSubtitle,
      icon: LucideIcons.scan,
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context, state, l10n),
        tablet: _buildTabletLayout(context, state, l10n),
        desktop: _buildDesktopLayout(context, state, l10n),
      ),
    );
  }

  /// Mobile Layout - Stack-based with bottom controls
  Widget _buildMobileLayout(BuildContext context, DocumentScannerState state, AppLocalizations l10n) {
    return Column(
      children: [
        // Main content area
        Expanded(
          child: Stack(
            children: [
              // Camera/Upload area
              _buildCameraArea(context, state, l10n),

              // Document overlay
              if (state.mode == ScannerMode.camera && state.detectedDocument != null)
                DocumentOverlayWidget(
                  quadrilateral: state.detectedDocument!,
                  isStable: state.isDocumentStable,
                ),

              // Top controls
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: _buildTopControls(context, state, l10n),
              ),

              // Processing indicator
              if (state.isProcessing || state.isCapturing)
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Bottom controls
        _buildBottomControls(context, state, l10n),

        // Page thumbnails
        if (state.scannedPages.isNotEmpty)
          SizedBox(
            height: 120,
            child: PageThumbnailList(
              pages: state.scannedPages,
              selectedPageId: state.selectedPage?.id,
              onPageSelected: (pageId) =>
                ref.read(documentScannerNotifierProvider.notifier).selectPage(pageId),
              onPageDeleted: (pageId) =>
                ref.read(documentScannerNotifierProvider.notifier).deletePage(pageId),
            ),
          ),

        // Footer
        const BTQAFooter(),
      ],
    );
  }

  /// Tablet Layout - Side-by-side with controls panel
  Widget _buildTabletLayout(BuildContext context, DocumentScannerState state, AppLocalizations l10n) {
    return Row(
      children: [
        // Main camera/preview area
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    _buildCameraArea(context, state, l10n),

                    if (state.mode == ScannerMode.camera && state.detectedDocument != null)
                      DocumentOverlayWidget(
                        quadrilateral: state.detectedDocument!,
                        isStable: state.isDocumentStable,
                      ),

                    if (state.isProcessing || state.isCapturing)
                      const Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.black54),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                  ],
                ),
              ),
              const BTQAFooter(),
            ],
          ),
        ),

        // Right panel - controls and thumbnails
        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              left: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              // Mode selector
              _buildModeSelector(context, state, l10n),

              const Divider(height: 1),

              // Camera controls
              if (state.mode == ScannerMode.camera)
                _buildCameraControls(context, state, l10n),

              // Filter selector
              FilterSelectorWidget(
                selectedFilter: state.selectedFilter,
                onFilterChanged: (filter) =>
                  ref.read(documentScannerNotifierProvider.notifier).changeFilter(filter),
              ),

              const Divider(height: 1),

              // Page thumbnails
              if (state.scannedPages.isNotEmpty)
                Expanded(
                  child: PageThumbnailList(
                    pages: state.scannedPages,
                    selectedPageId: state.selectedPage?.id,
                    onPageSelected: (pageId) =>
                      ref.read(documentScannerNotifierProvider.notifier).selectPage(pageId),
                    onPageDeleted: (pageId) =>
                      ref.read(documentScannerNotifierProvider.notifier).deletePage(pageId),
                    isVertical: true,
                  ),
                ),

              const Divider(height: 1),

              // Export options
              ExportOptionsWidget(
                exportFormat: state.exportFormat,
                includeOcr: state.includeOcr,
                exportFileName: state.exportFileName,
                canExport: state.scannedPages.isNotEmpty,
                isProcessing: state.isProcessing,
                onExportFormatChanged: (format) =>
                  ref.read(documentScannerNotifierProvider.notifier).changeExportFormat(format),
                onOcrToggled: (enabled) =>
                  ref.read(documentScannerNotifierProvider.notifier).toggleOcr(),
                onFileNameChanged: (name) =>
                  ref.read(documentScannerNotifierProvider.notifier).setExportFileName(name),
                onExport: () =>
                  ref.read(documentScannerNotifierProvider.notifier).exportDocuments(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Desktop Layout - Multi-panel with advanced features
  Widget _buildDesktopLayout(BuildContext context, DocumentScannerState state, AppLocalizations l10n) {
    return Row(
      children: [
        // Left panel - mode and settings
        Container(
          width: 280,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              _buildModeSelector(context, state, l10n),
              const Divider(height: 1),

              if (state.mode == ScannerMode.camera) ...[
                _buildCameraControls(context, state, l10n),
                const Divider(height: 1),
              ],

              FilterSelectorWidget(
                selectedFilter: state.selectedFilter,
                onFilterChanged: (filter) =>
                  ref.read(documentScannerNotifierProvider.notifier).changeFilter(filter),
              ),

              const Spacer(),

              ExportOptionsWidget(
                exportFormat: state.exportFormat,
                includeOcr: state.includeOcr,
                exportFileName: state.exportFileName,
                canExport: state.scannedPages.isNotEmpty,
                isProcessing: state.isProcessing,
                onExportFormatChanged: (format) =>
                  ref.read(documentScannerNotifierProvider.notifier).changeExportFormat(format),
                onOcrToggled: (enabled) =>
                  ref.read(documentScannerNotifierProvider.notifier).toggleOcr(),
                onFileNameChanged: (name) =>
                  ref.read(documentScannerNotifierProvider.notifier).setExportFileName(name),
                onExport: () =>
                  ref.read(documentScannerNotifierProvider.notifier).exportDocuments(),
              ),
            ],
          ),
        ),

        // Center - main camera/preview
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    _buildCameraArea(context, state, l10n),

                    if (state.mode == ScannerMode.camera && state.detectedDocument != null)
                      DocumentOverlayWidget(
                        quadrilateral: state.detectedDocument!,
                        isStable: state.isDocumentStable,
                      ),

                    if (state.isProcessing || state.isCapturing)
                      const Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.black54),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                  ],
                ),
              ),
              const BTQAFooter(),
            ],
          ),
        ),

        // Right panel - pages and preview
        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              left: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              // Page preview
              if (state.selectedPage != null)
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  child: _buildPagePreview(context, state.selectedPage!, l10n),
                ),

              const Divider(height: 1),

              // Page list
              if (state.scannedPages.isNotEmpty)
                Expanded(
                  child: PageThumbnailList(
                    pages: state.scannedPages,
                    selectedPageId: state.selectedPage?.id,
                    onPageSelected: (pageId) =>
                      ref.read(documentScannerNotifierProvider.notifier).selectPage(pageId),
                    onPageDeleted: (pageId) =>
                      ref.read(documentScannerNotifierProvider.notifier).deletePage(pageId),
                    isVertical: true,
                    showDetails: true,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build camera area based on current mode
  Widget _buildCameraArea(BuildContext context, DocumentScannerState state, AppLocalizations l10n) {
    switch (state.mode) {
      case ScannerMode.camera:
        return _buildCameraPreview(context, state, l10n);
      case ScannerMode.upload:
        return UploadDropZone(
          onImageUploaded: (bytes) =>
            ref.read(documentScannerNotifierProvider.notifier).uploadImage(bytes),
        );
      case ScannerMode.batch:
        return _buildBatchInterface(context, state, l10n);
    }
  }

  /// Build camera preview
  Widget _buildCameraPreview(BuildContext context, DocumentScannerState state, AppLocalizations l10n) {
    if (!state.permissionStatus.isGranted) {
      return _buildPermissionPlaceholder(context, state, l10n);
    }

    if (!state.isCameraInitialized || state.cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return CameraPreviewWidget(
      controller: state.cameraController!,
      onTap: (position) {
        // Handle tap-to-focus
      },
    );
  }

  /// Build permission placeholder
  Widget _buildPermissionPlaceholder(BuildContext context, DocumentScannerState state, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.camera,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.cameraPermissionRequired,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.cameraPermissionDescription,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () async {
              await ref.read(documentScannerNotifierProvider.notifier).initializeCamera();
            },
            icon: const Icon(LucideIcons.settings),
            label: Text(l10n.openSettings),
          ),
        ],
      ),
    );
  }

  /// Build batch interface
  Widget _buildBatchInterface(BuildContext context, DocumentScannerState state, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.layers,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.batchScanningMode,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.batchScanningDescription,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              // Switch to camera mode
              ref.read(documentScannerNotifierProvider.notifier).changeScannerMode(ScannerMode.camera);
            },
            icon: const Icon(LucideIcons.camera),
            label: Text(l10n.startScanning),
          ),
        ],
      ),
    );
  }

  /// Build top controls (mobile)
  Widget _buildTopControls(BuildContext context, DocumentScannerState state, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Mode selector
        Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: DropdownButton<ScannerMode>(
            value: state.mode,
            dropdownColor: Colors.black87,
            underline: const SizedBox.shrink(),
            style: const TextStyle(color: Colors.white),
            items: ScannerMode.values.map((mode) {
              return DropdownMenuItem(
                value: mode,
                child: Text(mode.displayName),
              );
            }).toList(),
            onChanged: (mode) {
              if (mode != null) {
                ref.read(documentScannerNotifierProvider.notifier).changeScannerMode(mode);
              }
            },
          ),
        ),

        // Settings button
        Container(
          decoration: const BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              _showSettingsBottomSheet(context, state, l10n);
            },
            icon: const Icon(LucideIcons.settings, color: Colors.white),
          ),
        ),
      ],
    );
  }

  /// Build bottom controls (mobile)
  Widget _buildBottomControls(BuildContext context, DocumentScannerState state, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: ScanControlsWidget(
        mode: state.mode,
        isCapturing: state.isCapturing,
        enableFlash: state.enableFlash,
        isAutoCapture: state.isAutoCapture,
        zoomLevel: state.zoomLevel,
        canCapture: state.mode == ScannerMode.camera && state.isCameraInitialized,
        onCapture: () =>
          ref.read(documentScannerNotifierProvider.notifier).captureDocument(),
        onFlashToggle: () =>
          ref.read(documentScannerNotifierProvider.notifier).toggleFlash(),
        onAutoCaptureToggle: () =>
          ref.read(documentScannerNotifierProvider.notifier).toggleAutoCapture(),
        onZoomChanged: (zoom) =>
          ref.read(documentScannerNotifierProvider.notifier).setZoomLevel(zoom),
      ),
    );
  }

  /// Build mode selector
  Widget _buildModeSelector(BuildContext context, DocumentScannerState state, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.scannerMode,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<ScannerMode>(
            selected: {state.mode},
            segments: ScannerMode.values.map((mode) {
              return ButtonSegment(
                value: mode,
                label: Text(mode.displayName),
                icon: Icon(_getModeIcon(mode)),
              );
            }).toList(),
            onSelectionChanged: (modes) {
              final mode = modes.first;
              ref.read(documentScannerNotifierProvider.notifier).changeScannerMode(mode);
            },
          ),
        ],
      ),
    );
  }

  /// Build camera controls
  Widget _buildCameraControls(BuildContext context, DocumentScannerState state, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.cameraSettings,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Flash toggle
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.flashlight),
            subtitle: Text(l10n.flashlightDescription),
            value: state.enableFlash,
            onChanged: (_) =>
              ref.read(documentScannerNotifierProvider.notifier).toggleFlash(),
          ),

          // Auto-capture toggle
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.autoCapture),
            subtitle: Text(l10n.autoCaptureDescription),
            value: state.isAutoCapture,
            onChanged: (_) =>
              ref.read(documentScannerNotifierProvider.notifier).toggleAutoCapture(),
          ),

          // Zoom slider
          if (state.isCameraInitialized) ...[
            const SizedBox(height: 8),
            Text(l10n.zoom),
            Slider(
              value: state.zoomLevel,
              min: 1.0,
              max: 8.0,
              divisions: 14,
              label: '${state.zoomLevel.toStringAsFixed(1)}x',
              onChanged: (zoom) =>
                ref.read(documentScannerNotifierProvider.notifier).setZoomLevel(zoom),
            ),
          ],
        ],
      ),
    );
  }

  /// Build page preview
  Widget _buildPagePreview(BuildContext context, ScannedPage page, AppLocalizations l10n) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[100],
              ),
              child: page.thumbnailData != null
                ? Image.memory(
                    page.thumbnailData!,
                    fit: BoxFit.contain,
                  )
                : const Center(
                    child: Icon(LucideIcons.image, size: 48),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  page.displayName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${page.bestImageDimensions.$1} × ${page.bestImageDimensions.$2} • ${page.fileSizeText}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (page.hasOcrText)
                  Text(
                    l10n.ocrTextDetected,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Show settings bottom sheet (mobile)
  void _showSettingsBottomSheet(BuildContext context, DocumentScannerState state, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Content
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        l10n.scannerSettings,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),

                      // Camera controls
                      if (state.mode == ScannerMode.camera)
                        _buildCameraControls(context, state, l10n),

                      // Filter selector
                      FilterSelectorWidget(
                        selectedFilter: state.selectedFilter,
                        onFilterChanged: (filter) =>
                          ref.read(documentScannerNotifierProvider.notifier).changeFilter(filter),
                      ),

                      const SizedBox(height: 16),

                      // Export options
                      ExportOptionsWidget(
                        exportFormat: state.exportFormat,
                        includeOcr: state.includeOcr,
                        exportFileName: state.exportFileName,
                        canExport: state.scannedPages.isNotEmpty,
                        isProcessing: state.isProcessing,
                        onExportFormatChanged: (format) =>
                          ref.read(documentScannerNotifierProvider.notifier).changeExportFormat(format),
                        onOcrToggled: (enabled) =>
                          ref.read(documentScannerNotifierProvider.notifier).toggleOcr(),
                        onFileNameChanged: (name) =>
                          ref.read(documentScannerNotifierProvider.notifier).setExportFileName(name),
                        onExport: () =>
                          ref.read(documentScannerNotifierProvider.notifier).exportDocuments(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Get icon for scanner mode
  IconData _getModeIcon(ScannerMode mode) {
    switch (mode) {
      case ScannerMode.camera:
        return LucideIcons.camera;
      case ScannerMode.upload:
        return LucideIcons.upload;
      case ScannerMode.batch:
        return LucideIcons.layers;
    }
  }
}

/// Extension methods for provider access
extension DocumentScannerStateExtensions on DocumentScannerState {
  bool get canCapture =>
    mode == ScannerMode.camera &&
    isCameraInitialized &&
    !isCapturing &&
    !isProcessing;
}
