import 'package:flutter/material.dart';
import '../models/image_reducer_state.dart';

class BatchProcessingPanel extends StatelessWidget {
  final List<ProcessedImage> images;
  final Function(ProcessedImage) onImageSelected;
  final Function(ProcessedImage) onImageRemoved;
  final ProcessedImage? selectedImage;

  const BatchProcessingPanel({
    super.key,
    required this.images,
    required this.onImageSelected,
    required this.onImageRemoved,
    this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.photo_library, size: 20),
              const SizedBox(width: 8),
              Text(
                'Batch Processing',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${images.length} images',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Image list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: images.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final image = images[index];
              final isSelected = selectedImage == image;

              return _buildImageCard(context, image, isSelected, theme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(
    BuildContext context,
    ProcessedImage image,
    bool isSelected,
    ThemeData theme,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      color: isSelected ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: () => onImageSelected(image),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image thumbnail placeholder
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.image_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(width: 12),

              // Image info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      image.fileName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isSelected ? theme.colorScheme.onPrimaryContainer : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          image.originalFileSizeText,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.onPrimaryContainer.withOpacity(0.8)
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (image.isProcessed) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: isSelected
                                ? theme.colorScheme.onPrimaryContainer.withOpacity(0.8)
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            image.fileSizeText,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Status indicator
              _buildStatusIndicator(image, theme, isSelected),

              const SizedBox(width: 8),

              // Remove button
              IconButton(
                onPressed: () => onImageRemoved(image),
                icon: Icon(
                  Icons.close,
                  size: 18,
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                ),
                visualDensity: VisualDensity.compact,
                tooltip: 'Remove image',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(
    ProcessedImage image,
    ThemeData theme,
    bool isSelected,
  ) {
    switch (image.status) {
      case ProcessingStatus.pending:
        return Icon(
          Icons.schedule,
          size: 16,
          color: isSelected
              ? theme.colorScheme.onPrimaryContainer.withOpacity(0.7)
              : theme.colorScheme.onSurfaceVariant,
        );

      case ProcessingStatus.processing:
        return SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.primary,
            ),
          ),
        );

      case ProcessingStatus.completed:
        return Icon(
          Icons.check_circle,
          size: 16,
          color: Colors.green,
        );

      case ProcessingStatus.error:
        return Icon(
          Icons.error,
          size: 16,
          color: theme.colorScheme.error,
        );
    }
  }
}

class ProcessingStatsPanel extends StatelessWidget {
  final int totalImages;
  final int processedImages;
  final double totalSizeReduction;
  final bool isProcessing;
  final int progress;

  const ProcessingStatsPanel({
    super.key,
    required this.totalImages,
    required this.processedImages,
    required this.totalSizeReduction,
    required this.isProcessing,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Images',
                '$processedImages / $totalImages',
                Icons.image_outlined,
                theme,
              ),
              _buildStatItem(
                'Size Reduction',
                '${totalSizeReduction.toStringAsFixed(1)}%',
                Icons.compress,
                theme,
              ),
              _buildStatItem(
                'Status',
                isProcessing ? 'Processing...' : 'Ready',
                isProcessing ? Icons.sync : Icons.check,
                theme,
              ),
            ],
          ),

          if (isProcessing) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress / 100.0,
              backgroundColor: theme.colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$progress% Complete',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}