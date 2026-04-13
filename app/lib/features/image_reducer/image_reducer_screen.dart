import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bharattesting_core/core.dart';
import '../../l10n/l10n.dart';
import 'models/image_reducer_state.dart';
import 'providers/image_reducer_provider.dart';
import 'widgets/image_upload_zone.dart';
import 'widgets/quality_control_panel.dart';
import 'widgets/image_preview_panel.dart';
import 'widgets/batch_processing_panel.dart';
import 'widgets/settings_panel.dart';
import 'widgets/processing_stats_panel.dart';

class ImageReducerScreen extends ConsumerStatefulWidget {
  const ImageReducerScreen({super.key});

  @override
  ConsumerState<ImageReducerScreen> createState() => _ImageReducerScreenState();
}

class _ImageReducerScreenState extends ConsumerState<ImageReducerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(imageReducerProvider);
    final notifier = ref.read(imageReducerProvider.notifier);
    final theme = Theme.of(context);

    return Column(
      children: [
        // Processing stats bar
        if (state.hasImages) ...[
          ProcessingStatsPanel(
            totalImages: state.images.length,
            processedImages: state.images.where((img) => img.isProcessed).length,
            totalSizeReduction: state.totalSizeReduction,
            isProcessing: state.isProcessing,
            progress: state.processingProgress,
          ),
          const SizedBox(height: 8),
        ],

        // Main content
        Expanded(
          child: !state.hasImages
              ? _buildEmptyState(context, notifier)
              : _buildImageProcessingInterface(context, state, notifier),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, ImageReducer notifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageUploadZone(
              onImagesSelected: notifier.addImages,
              onImagesPicked: () => notifier.pickImages(allowMultiple: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageProcessingInterface(
    BuildContext context,
    ImageReducerState state,
    ImageReducer notifier,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1200;
        final isMedium = constraints.maxWidth > 800;

        if (isWide) {
          return Row(
            children: [
              SizedBox(
                width: 300,
                child: _buildControlsPanel(context, state, notifier),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 2,
                child: _buildPreviewPanel(context, state, notifier),
              ),
              const VerticalDivider(width: 1),
              SizedBox(
                width: 320,
                child: state.showBatchMode
                    ? BatchProcessingPanel(
                        images: state.images,
                        onImageSelected: notifier.selectImage,
                        onImageRemoved: notifier.removeImage,
                        selectedImage: state.selectedImage,
                      )
                    : const Center(child: Text('Image Info')),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.tune), text: 'Controls'),
                  Tab(icon: Icon(Icons.preview), text: 'Preview'),
                  Tab(icon: Icon(Icons.list), text: 'Batch'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildControlsPanel(context, state, notifier),
                    _buildPreviewPanel(context, state, notifier),
                    BatchProcessingPanel(
                      images: state.images,
                      onImageSelected: notifier.selectImage,
                      onImageRemoved: notifier.removeImage,
                      selectedImage: state.selectedImage,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildControlsPanel(
    BuildContext context,
    ImageReducerState state,
    ImageReducer notifier,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QualityControlPanel(
            quality: state.quality,
            onQualityChanged: notifier.updateQuality,
            targetFormat: state.targetFormat,
            onFormatChanged: notifier.updateTargetFormat,
            strategy: state.strategy,
            onStrategyChanged: notifier.updateStrategy,
            isProcessing: state.isProcessing,
            estimatedSize: state.estimatedTotalSize,
            originalSize: state.totalOriginalSize,
          ),
          const SizedBox(height: 24),
          _buildActionButtons(context, state, notifier),
        ],
      ),
    );
  }

  Widget _buildPreviewPanel(
    BuildContext context,
    ImageReducerState state,
    ImageReducer notifier,
  ) {
    if (state.currentImage == null) {
      return const Center(child: Text('Select an image to preview'));
    }

    return ImagePreviewPanel(
      image: state.currentImage!,
      showComparison: state.currentImage!.isProcessed,
      onDownload: () => notifier.downloadImages(),
      onCopyToClipboard: () => notifier.copyToClipboard(state.currentImage!),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    ImageReducerState state,
    ImageReducer notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: state.canProcess ? notifier.processImages : null,
          icon: state.isProcessing
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.compress),
          label: Text(state.isProcessing ? 'Processing...' : 'Process'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: state.hasImages ? notifier.downloadImages : null,
          icon: const Icon(Icons.download),
          label: const Text('Download'),
        ),
      ],
    );
  }
}
