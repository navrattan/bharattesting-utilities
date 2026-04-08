/// Bulk generation size slider widget
///
/// Provides a slider to select number of records to generate

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../faker_state.dart';

/// Slider for selecting bulk generation size
class BulkSlider extends StatelessWidget {
  const BulkSlider({
    required this.selectedSize,
    required this.onSizeChanged,
    super.key,
  });

  final BulkSize selectedSize;
  final ValueChanged<BulkSize> onSizeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Generation Size',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                selectedSize.displayName,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: BulkSize.values.indexOf(selectedSize).toDouble(),
          min: 0,
          max: (BulkSize.values.length - 1).toDouble(),
          divisions: BulkSize.values.length - 1,
          onChanged: (value) {
            onSizeChanged(BulkSize.values[value.toInt()]);
          },
        ),
        _buildPerformanceHint(context),
      ],
    );
  }

  /// Build performance hint based on selected size
  Widget _buildPerformanceHint(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getHintColor(theme);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(_getHintIcon(), size: 16, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getHintText(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get performance hint color based on bulk size
  Color _getHintColor(ThemeData theme) {
    if (selectedSize.count <= 100) return theme.colorScheme.primary;
    if (selectedSize.count <= 1000) return Colors.orange;
    return theme.colorScheme.error;
  }

  /// Get performance hint icon
  IconData _getHintIcon() {
    if (selectedSize.count <= 100) return LucideIcons.zap;
    if (selectedSize.count <= 1000) return LucideIcons.timer;
    return LucideIcons.alertTriangle;
  }

  /// Get performance hint text
  String _getHintText() {
    if (selectedSize.count <= 100) {
      return 'Instant generation on most devices.';
    }
    if (selectedSize.count <= 1000) {
      return 'May take 1-2 seconds to generate and process.';
    }
    return 'Large batch: Generation runs in background. UI may be busy.';
  }
}
