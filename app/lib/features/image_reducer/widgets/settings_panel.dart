import 'package:flutter/material.dart';
import '../models/image_reducer_state.dart';

class SettingsPanel extends StatelessWidget {
  final bool enableFormatConversion;
  final VoidCallback onToggleFormatConversion;
  final ConvertibleFormat targetFormat;
  final ValueChanged<ConvertibleFormat> onFormatChanged;
  final ConversionStrategy strategy;
  final ValueChanged<ConversionStrategy> onStrategyChanged;

  const SettingsPanel({
    super.key,
    required this.enableFormatConversion,
    required this.onToggleFormatConversion,
    required this.targetFormat,
    required this.onFormatChanged,
    required this.strategy,
    required this.onStrategyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Text(
                  'Advanced Settings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Settings content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Format conversion settings
                _buildFormatConversionSection(theme),

                const SizedBox(height: 24),

                // Advanced compression settings
                _buildCompressionSection(theme),

                const SizedBox(height: 24),

                // Performance settings
                _buildPerformanceSection(theme),

                const SizedBox(height: 24),

                // Export settings
                _buildExportSection(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatConversionSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.transform, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Format Conversion',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: enableFormatConversion,
                  onChanged: (_) => onToggleFormatConversion(),
                ),
              ],
            ),

            if (enableFormatConversion) ...[
              const SizedBox(height: 16),

              // Target format selection
              Text(
                'Target Format',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              ...ConvertibleFormat.values.map((format) {
                return RadioListTile<ConvertibleFormat>(
                  value: format,
                  groupValue: targetFormat,
                  onChanged: (value) {
                    if (value != null) {
                      onFormatChanged(value);
                    }
                  },
                  title: Text(format.displayName),
                  subtitle: Text(
                    format.bestFor,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  dense: true,
                );
              }),

              const SizedBox(height: 16),

              // Strategy selection
              Text(
                'Conversion Strategy',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              DropdownButtonFormField<ConversionStrategy>(
                value: strategy,
                onChanged: (value) {
                  if (value != null) {
                    onStrategyChanged(value);
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: ConversionStrategy.values.map((strategy) {
                  return DropdownMenuItem(
                    value: strategy,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(strategy.displayName),
                        Text(
                          strategy.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
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

  Widget _buildCompressionSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.compress, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Compression',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Progressive encoding
            SwitchListTile(
              title: const Text('Progressive Encoding'),
              subtitle: const Text('Better for web loading (JPEG)'),
              value: true,
              onChanged: (value) {
                // Handle progressive encoding toggle
              },
              dense: true,
            ),

            // Optimize for size
            SwitchListTile(
              title: const Text('Optimize for Size'),
              subtitle: const Text('Aggressive size optimization'),
              value: false,
              onChanged: (value) {
                // Handle optimize for size toggle
              },
              dense: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.speed, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Performance',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Batch concurrency
            Text(
              'Batch Processing Concurrency',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            Slider(
              value: 4,
              min: 1,
              max: 8,
              divisions: 7,
              label: '4 threads',
              onChanged: (value) {
                // Handle concurrency change
              },
            ),

            const SizedBox(height: 8),
            Text(
              'Higher values process multiple images simultaneously but use more memory',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.download, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Export Options',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Auto-download processed images
            SwitchListTile(
              title: const Text('Auto-download'),
              subtitle: const Text('Download images immediately after processing'),
              value: false,
              onChanged: (value) {
                // Handle auto-download toggle
              },
              dense: true,
            ),

            // Include original in batch
            SwitchListTile(
              title: const Text('Include Originals in ZIP'),
              subtitle: const Text('Add original files to batch download'),
              value: false,
              onChanged: (value) {
                // Handle include originals toggle
              },
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}
