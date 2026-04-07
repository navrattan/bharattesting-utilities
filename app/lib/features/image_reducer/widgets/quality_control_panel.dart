import 'package:flutter/material.dart';
import '../models/image_reducer_state.dart';

class QualityControlPanel extends StatefulWidget {
  final int quality;
  final ValueChanged<int> onQualityChanged;
  final ConvertibleFormat targetFormat;
  final ValueChanged<ConvertibleFormat> onFormatChanged;
  final ConversionStrategy strategy;
  final ValueChanged<ConversionStrategy> onStrategyChanged;
  final bool isProcessing;
  final int estimatedSize;
  final int originalSize;

  const QualityControlPanel({
    super.key,
    required this.quality,
    required this.onQualityChanged,
    required this.targetFormat,
    required this.onFormatChanged,
    required this.strategy,
    required this.onStrategyChanged,
    required this.isProcessing,
    required this.estimatedSize,
    required this.originalSize,
  });

  @override
  State<QualityControlPanel> createState() => _QualityControlPanelState();
}

class _QualityControlPanelState extends State<QualityControlPanel>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isProcessing) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(QualityControlPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isProcessing && !oldWidget.isProcessing) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isProcessing && oldWidget.isProcessing) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      const Icon(Icons.tune, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Quality & Compression',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Quality Slider
                  _buildQualitySlider(theme),

                  const SizedBox(height: 20),

                  // Format Selection
                  _buildFormatSelector(theme),

                  const SizedBox(height: 20),

                  // Strategy Selection
                  _buildStrategySelector(theme),

                  const SizedBox(height: 20),

                  // Size Estimation
                  _buildSizeEstimation(theme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQualitySlider(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quality',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getQualityColor(widget.quality).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getQualityColor(widget.quality),
                  width: 1,
                ),
              ),
              child: Text(
                '${widget.quality}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _getQualityColor(widget.quality),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10,
              elevation: 3,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Slider(
            value: widget.quality.toDouble(),
            min: 10,
            max: 100,
            divisions: 18, // 10, 15, 20, ... 100
            label: '${widget.quality}%',
            onChanged: widget.isProcessing ? null : (value) {
              widget.onQualityChanged(value.round());
            },
            activeColor: _getQualityColor(widget.quality),
          ),
        ),

        // Quality indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQualityIndicator('Smaller', Icons.compress, theme, true),
            _buildQualityIndicator(_getQualityLabel(widget.quality),
                _getQualityIcon(widget.quality), theme, false),
            _buildQualityIndicator('Higher Quality', Icons.high_quality, theme, true),
          ],
        ),
      ],
    );
  }

  Widget _buildQualityIndicator(String label, IconData icon, ThemeData theme, bool muted) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: muted
              ? theme.colorScheme.onSurfaceVariant
              : _getQualityColor(widget.quality),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: muted
                ? theme.colorScheme.onSurfaceVariant
                : _getQualityColor(widget.quality),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildFormatSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Output Format',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 12),

        DropdownButtonFormField<ConvertibleFormat>(
          value: widget.targetFormat,
          onChanged: widget.isProcessing ? null : (format) {
            if (format != null) {
              widget.onFormatChanged(format);
            }
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: ConvertibleFormat.values.map((format) {
            return DropdownMenuItem(
              value: format,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getFormatColor(format),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          format.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          format.bestFor,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStrategySelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Optimization Strategy',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ConversionStrategy.values.map((strategy) {
            final isSelected = widget.strategy == strategy;

            return FilterChip(
              selected: isSelected,
              onSelected: widget.isProcessing ? null : (_) {
                widget.onStrategyChanged(strategy);
              },
              label: Text(
                strategy.displayName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              avatar: Icon(
                _getStrategyIcon(strategy),
                size: 14,
              ),
              tooltip: strategy.description,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSizeEstimation(ThemeData theme) {
    if (widget.originalSize == 0) return const SizedBox.shrink();

    final estimatedReduction = widget.originalSize > 0
        ? ((widget.originalSize - widget.estimatedSize) / widget.originalSize) * 100
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Original Size:',
                style: theme.textTheme.bodySmall,
              ),
              Text(
                _formatFileSize(widget.originalSize),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated Size:',
                style: theme.textTheme.bodySmall,
              ),
              Text(
                _formatFileSize(widget.estimatedSize),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reduction:',
                style: theme.textTheme.bodySmall,
              ),
              Text(
                '${estimatedReduction.toStringAsFixed(1)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: estimatedReduction > 0
                      ? Colors.green
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods

  Color _getQualityColor(int quality) {
    if (quality >= 80) return Colors.green;
    if (quality >= 60) return Colors.orange;
    if (quality >= 40) return Colors.deepOrange;
    return Colors.red;
  }

  String _getQualityLabel(int quality) {
    if (quality >= 90) return 'Excellent';
    if (quality >= 80) return 'Very Good';
    if (quality >= 70) return 'Good';
    if (quality >= 60) return 'Fair';
    if (quality >= 50) return 'Moderate';
    if (quality >= 30) return 'Low';
    return 'Very Low';
  }

  IconData _getQualityIcon(int quality) {
    if (quality >= 80) return Icons.star;
    if (quality >= 60) return Icons.star_half;
    return Icons.star_border;
  }

  Color _getFormatColor(ConvertibleFormat format) {
    switch (format) {
      case ConvertibleFormat.jpeg:
        return Colors.blue;
      case ConvertibleFormat.png:
        return Colors.green;
      case ConvertibleFormat.webp:
        return Colors.purple;
      case ConvertibleFormat.bmp:
        return Colors.orange;
      case ConvertibleFormat.gif:
        return Colors.pink;
      case ConvertibleFormat.tiff:
        return Colors.teal;
    }
  }

  IconData _getStrategyIcon(ConversionStrategy strategy) {
    switch (strategy) {
      case ConversionStrategy.preserveQuality:
        return Icons.high_quality;
      case ConversionStrategy.balanceQualitySize:
        return Icons.balance;
      case ConversionStrategy.minimizeSize:
        return Icons.compress;
      case ConversionStrategy.preserveAlpha:
        return Icons.opacity;
      case ConversionStrategy.stripMetadata:
        return Icons.privacy_tip;
      case ConversionStrategy.webOptimized:
        return Icons.language;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / 1024 / 1024).toStringAsFixed(2)}MB';
  }
}
