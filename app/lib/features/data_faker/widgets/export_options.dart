/// Export options widget for configuring and executing exports
///
/// Provides controls for export format, options, and execution

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../faker_state.dart';

/// Widget for export options and controls
class ExportOptions extends StatelessWidget {
  const ExportOptions({
    required this.isExporting,
    required this.onExport,
    super.key,
  });

  final bool isExporting;
  final ValueChanged<ExportFormat> onExport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Export Format',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildFormatCard(
              context,
              'JSON',
              'Best for developers',
              LucideIcons.braces,
              ExportFormat.json,
            ),
            const SizedBox(width: 12),
            _buildFormatCard(
              context,
              'CSV',
              'Best for Excel',
              LucideIcons.table,
              ExportFormat.csv,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isExporting ? null : () => onExport(ExportFormat.json),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: theme.colorScheme.secondaryContainer,
              foregroundColor: theme.colorScheme.onSecondaryContainer,
            ),
            icon: isExporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(LucideIcons.download),
            label: Text(
              isExporting ? 'Exporting...' : 'Export Results',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormatCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    ExportFormat format,
  ) {
    final theme = Theme.of(context);
    const isSelected = false; // Internal state would go here in a real app

    return Expanded(
      child: InkWell(
        onTap: () => onExport(format),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? theme.colorScheme.onPrimaryContainer : null,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
