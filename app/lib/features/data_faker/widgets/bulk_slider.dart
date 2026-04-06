/// Bulk size slider for controlling generation count
///
/// Provides intuitive control for selecting how many records to generate

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../faker_state.dart';

/// Widget for selecting bulk generation size
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.layers),
                const SizedBox(width: 8),
                Text(
                  'Bulk Size',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    selectedSize.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              ),
              child: Slider(
                value: BulkSize.values.indexOf(selectedSize).toDouble(),
                min: 0,
                max: (BulkSize.values.length - 1).toDouble(),
                divisions: BulkSize.values.length - 1,
                onChanged: (value) {
                  final newSize = BulkSize.values[value.round()];
                  onSizeChanged(newSize);
                },
              ),
            ),

            // Size options row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: BulkSize.values.map((size) {
                  final isSelected = size == selectedSize;

                  return GestureDetector(
                    onTap: () => onSizeChanged(size),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        size.count.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // Performance hint
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getPerformanceColor(context, selectedSize).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getPerformanceColor(context, selectedSize).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getPerformanceIcon(selectedSize),
                    size: 16,
                    color: _getPerformanceColor(context, selectedSize),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getPerformanceHint(selectedSize),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getPerformanceColor(context, selectedSize),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get performance hint color based on bulk size
  Color _getPerformanceColor(BuildContext context, BulkSize size) {
    switch (size) {
      case BulkSize.single:
      case BulkSize.small:
        return Theme.of(context).colorScheme.primary;
      case BulkSize.medium:
        return Colors.orange;
      case BulkSize.large:
      case BulkSize.xl:
        return Theme.of(context).colorScheme.error;
    }
  }

  /// Get performance hint icon
  IconData _getPerformanceIcon(BulkSize size) {
    switch (size) {
      case BulkSize.single:
      case BulkSize.small:
        return LucideIcons.zap;
      case BulkSize.medium:
        return LucideIcons.clock;
      case BulkSize.large:
      case BulkSize.xl:
        return LucideIcons.timer;
    }
  }

  /// Get performance hint text
  String _getPerformanceHint(BulkSize size) {
    switch (size) {
      case BulkSize.single:
        return 'Instant generation for testing individual records';
      case BulkSize.small:
        return 'Fast generation (~100ms) for small datasets';
      case BulkSize.medium:
        return 'Moderate generation (~1s) for medium datasets';
      case BulkSize.large:
        return 'Slower generation (~3s) for large datasets';
      case BulkSize.xl:
        return 'Bulk generation (~10s) for maximum datasets';
    }
  }
}