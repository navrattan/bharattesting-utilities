import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bharattesting_core/core.dart';
import '../../shared/widgets/tool_scaffold.dart';
import '../../l10n/l10n.dart';
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

    return ToolScaffold(
      key: _scaffoldKey,
      title: 'Image Size Reducer',
      subtitle: 'Compress, resize, and optimize images',
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          tooltip: 'Advanced Settings',
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => _showHelpDialog(context),
          tooltip: 'Help',
        ),
      ],
      body: Column(
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

          // Error messages
          if (state.hasErrors) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: theme.colorScheme.onErrorContainer,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Processing Errors',
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () {
                          // Clear errors
                          ref.read(imageReducerProvider.notifier);
                        },
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...state.processingErrors.map(
                    (error) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• $error',
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Main content
          Expanded(
            child: !state.hasImages
                ? _buildEmptyState(context, notifier)
                : _buildImageProcessingInterface(context, state, notifier),
          ),
        ],
      ),
      endDrawer: _buildSettingsDrawer(context, state, notifier),
    );
  }

  Widget _buildEmptyState(BuildContext context, ImageReducerNotifier notifier) {
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
            const SizedBox(height: 32),
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageProcessingInterface(
    BuildContext context,
    ImageReducerState state,
    ImageReducerNotifier notifier,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1200;
        final isMedium = constraints.maxWidth > 800;

        if (isWide) {
          // Desktop layout: 3-panel
          return Row(
            children: [
              // Left: Controls
              SizedBox(
                width: 300,
                child: _buildControlsPanel(context, state, notifier),
              ),
              const VerticalDivider(width: 1),
              // Center: Preview
              Expanded(
                flex: 2,
                child: _buildPreviewPanel(context, state, notifier),
              ),
              const VerticalDivider(width: 1),
              // Right: Batch or Settings
              SizedBox(
                width: 320,
                child: state.showBatchMode
                    ? BatchProcessingPanel(
                        images: state.images,
                        onImageSelected: notifier.selectImage,
                        onImageRemoved: notifier.removeImage,
                        selectedImage: state.selectedImage,
                      )
                    : _buildImageInfo(context, state),
              ),
            ],
          );
        } else if (isMedium) {
          // Tablet layout: 2-panel
          return Row(
            children: [
              SizedBox(
                width: 280,
                child: _buildControlsPanel(context, state, notifier),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildPreviewPanel(context, state, notifier),
                    ),
                    if (state.showBatchMode) ...[
                      const Divider(height: 1),
                      Expanded(
                        child: BatchProcessingPanel(
                          images: state.images,
                          onImageSelected: notifier.selectImage,
                          onImageRemoved: notifier.removeImage,
                          selectedImage: state.selectedImage,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        } else {
          // Mobile layout: Tabs
          return Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  const Tab(icon: Icon(Icons.tune), text: 'Controls'),
                  const Tab(icon: Icon(Icons.preview), text: 'Preview'),
                  if (state.showBatchMode)
                    const Tab(icon: Icon(Icons.list), text: 'Batch')
                  else
                    const Tab(icon: Icon(Icons.info), text: 'Info'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildControlsPanel(context, state, notifier),
                    _buildPreviewPanel(context, state, notifier),
                    state.showBatchMode
                        ? BatchProcessingPanel(
                            images: state.images,
                            onImageSelected: notifier.selectImage,
                            onImageRemoved: notifier.removeImage,
                            selectedImage: state.selectedImage,
                          )
                        : _buildImageInfo(context, state),
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
    ImageReducerNotifier notifier,
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

          // Resize options
          _buildResizeSection(context, state, notifier),

          const SizedBox(height: 24),

          // Privacy options
          _buildPrivacySection(context, state, notifier),

          const SizedBox(height: 24),

          // Action buttons
          _buildActionButtons(context, state, notifier),
        ],
      ),
    );
  }

  Widget _buildPreviewPanel(
    BuildContext context,
    ImageReducerState state,
    ImageReducerNotifier notifier,
  ) {
    if (state.currentImage == null) {
      return const Center(
        child: Text('Select an image to preview'),
      );
    }

    return ImagePreviewPanel(
      image: state.currentImage!,
      showComparison: state.currentImage!.isProcessed,
      onDownload: () => notifier.downloadImages(),
      onCopyToClipboard: () => notifier.copyToClipboard(state.currentImage!),
    );
  }

  Widget _buildResizeSection(
    BuildContext context,
    ImageReducerState state,
    ImageReducerNotifier notifier,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.photo_size_select_large, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Resize Options',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Switch(
                  value: state.enableResize,
                  onChanged: (_) => notifier.toggleResize(),
                ),
              ],
            ),

            if (state.enableResize) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<ResizePreset>(
                value: state.selectedPreset,
                onChanged: (preset) {
                  if (preset != null) {
                    notifier.updateResizePreset(preset);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Size Preset',
                  border: OutlineInputBorder(),
                ),
                items: ResizePreset.values.map((preset) {
                  return DropdownMenuItem(
                    value: preset,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(preset.displayName),
                        Text(
                          preset.dimensions,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(
    BuildContext context,
    ImageReducerState state,
    ImageReducerNotifier notifier,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.privacy_tip_outlined, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Privacy & Metadata',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Switch(
                  value: state.stripMetadata,
                  onChanged: (_) => notifier.toggleMetadataStripping(),
                ),
              ],
            ),

            if (state.stripMetadata) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<PrivacyLevel>(
                value: state.privacyLevel,
                onChanged: (level) {
                  if (level != null) {
                    notifier.updatePrivacyLevel(level);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Privacy Level',
                  border: OutlineInputBorder(),
                ),
                items: PrivacyLevel.values.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(level.displayName),
                        Text(
                          level.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    ImageReducerState state,
    ImageReducerNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: state.canProcess ? notifier.processImages : null,
          icon: state.isProcessing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.compress),
          label: Text(
            state.isProcessing
                ? 'Processing...'
                : state.showBatchMode
                    ? 'Process All Images'
                    : 'Process Image',
          ),
        ),

        const SizedBox(height: 12),

        OutlinedButton.icon(
          onPressed: state.hasImages ? notifier.downloadImages : null,
          icon: const Icon(Icons.download),
          label: Text(
            state.showBatchMode ? 'Download ZIP' : 'Download Image',
          ),
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => notifier.pickImages(allowMultiple: true),
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Add More'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: state.hasImages ? notifier.clearImages : null,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear All'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageInfo(BuildContext context, ImageReducerState state) {
    if (state.currentImage == null) {
      return const Center(child: Text('No image selected'));
    }

    final image = state.currentImage!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Image Information',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),

          _buildInfoRow('File Name', image.fileName),
          _buildInfoRow('Original Size', image.originalFileSizeText),
          if (image.isProcessed) _buildInfoRow('Reduced Size', image.fileSizeText),
          _buildInfoRow('Format', image.formatDisplayName),
          if (image.metadata != null) ...[
            _buildInfoRow('Dimensions', image.metadata!.dimensions),
            _buildInfoRow('Megapixels', image.metadata!.megapixelsText),
            _buildInfoRow('Aspect Ratio', image.metadata!.aspectRatioText),
          ],
          if (image.isProcessed) ...[
            const SizedBox(height: 16),
            Text(
              'Processing Results',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Size Reduction', image.sizeReductionText),
            _buildInfoRow('Quality Score', '${image.qualityScore.toStringAsFixed(1)}/100'),
            _buildInfoRow('Quality Grade', image.qualityGrade),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildQuickActionChip(
              'Thumbnail',
              Icons.photo_size_select_small,
              () {
                // Set thumbnail preset
              },
            ),
            _buildQuickActionChip(
              'Social Media',
              Icons.share,
              () {
                // Set social media preset
              },
            ),
            _buildQuickActionChip(
              'Web Optimized',
              Icons.language,
              () {
                // Set web optimized preset
              },
            ),
            _buildQuickActionChip(
              'High Quality',
              Icons.high_quality,
              () {
                // Set high quality preset
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionChip(String label, IconData icon, VoidCallback onPressed) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onPressed,
    );
  }

  Widget _buildSettingsDrawer(
    BuildContext context,
    ImageReducerState state,
    ImageReducerNotifier notifier,
  ) {
    return Drawer(
      child: SettingsPanel(
        enableFormatConversion: state.enableFormatConversion,
        onToggleFormatConversion: notifier.toggleFormatConversion,
        targetFormat: state.targetFormat,
        onFormatChanged: notifier.updateTargetFormat,
        strategy: state.strategy,
        onStrategyChanged: notifier.updateStrategy,
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Image Size Reducer'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Advanced compression with quality control'),
              Text('• Smart resizing with aspect ratio preservation'),
              Text('• Format conversion (JPEG, PNG, WebP, BMP, GIF)'),
              Text('• Privacy-focused metadata stripping'),
              Text('• Batch processing up to 50 images'),
              Text('• Real-time preview and size estimation'),
              Text('• ZIP export for batch downloads'),
              SizedBox(height: 16),
              Text(
                'Privacy Levels:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Minimal: Remove GPS and personal data'),
              Text('• Moderate: Remove sensitive metadata'),
              Text('• Aggressive: Remove all metadata except color'),
              Text('• Complete: Remove all metadata'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}