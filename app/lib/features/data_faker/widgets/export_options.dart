/// Export options widget for configuring and executing exports
///
/// Provides controls for export format, options, and execution

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../faker_state.dart';

/// Widget for export options and controls
class ExportOptions extends StatelessWidget {
  const ExportOptions({
    required this.selectedFormat,
    required this.includeMetadata,
    required this.prettifyOutput,
    required this.isExporting,
    required this.exportSummary,
    required this.canExport,
    required this.onFormatChanged,
    required this.onMetadataChanged,
    required this.onPrettifyChanged,
    required this.onExport,
    super.key,
  });

  final ExportFormat selectedFormat;
  final bool includeMetadata;
  final bool prettifyOutput;
  final bool isExporting;
  final String exportSummary;
  final bool canExport;
  final ValueChanged<ExportFormat> onFormatChanged;
  final ValueChanged<bool> onMetadataChanged;
  final ValueChanged<bool> onPrettifyChanged;
  final VoidCallback onExport;

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
                const Icon(LucideIcons.download),
                const SizedBox(width: 8),
                Text(
                  'Export Options',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Format selector
            _buildFormatSelector(context),

            const SizedBox(height: 16),

            // Export options
            _buildExportOptions(context),

            const SizedBox(height: 16),

            // Export button and status
            _buildExportControls(context),
          ],
        ),
      ),
    );
  }

  /// Build format selector
  Widget _buildFormatSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Export Format',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<ExportFormat>(
          segments: ExportFormat.values.map((format) {
            return ButtonSegment<ExportFormat>(
              value: format,
              label: Text(format.displayName),
              icon: Icon(_getFormatIcon(format)),
            );
          }).toList(),
          selected: {selectedFormat},
          onSelectionChanged: (Set<ExportFormat> selection) {
            if (selection.isNotEmpty) {
              onFormatChanged(selection.first);
            }
          },
        ),
        const SizedBox(height: 8),
        Text(
          selectedFormat.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  /// Build export options
  Widget _buildExportOptions(BuildContext context) {
    return Column(
      children: [
        // Metadata option (for JSON/CSV)
        if (selectedFormat != ExportFormat.xlsx)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Include Metadata'),
            subtitle: Text(selectedFormat == ExportFormat.csv
                ? 'Add generation info as header comments'
                : 'Include export metadata and statistics'),
            value: includeMetadata,
            onChanged: onMetadataChanged,
            secondary: const Icon(LucideIcons.info),
          ),

        // Prettify option (for JSON)
        if (selectedFormat == ExportFormat.json)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Prettify Output'),
            subtitle: const Text('Format JSON with proper indentation'),
            value: prettifyOutput,
            onChanged: onPrettifyChanged,
            secondary: const Icon(LucideIcons.alignLeft),
          ),
      ],
    );
  }

  /// Build export controls
  Widget _buildExportControls(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Export button
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: canExport ? onExport : null,
            icon: isExporting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(_getFormatIcon(selectedFormat)),
            label: Text(
              isExporting
                  ? 'Exporting to ${selectedFormat.displayName}...'
                  : 'Export as ${selectedFormat.displayName}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),

        // Export status
        if (exportSummary.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.checkCircle,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    exportSummary,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Format info
        const SizedBox(height: 12),
        _buildFormatInfo(context),
      ],
    );
  }

  /// Build format-specific info
  Widget _buildFormatInfo(BuildContext context) {
    String info;
    IconData icon;
    Color color;

    switch (selectedFormat) {
      case ExportFormat.csv:
        info = 'CSV files can be opened in Excel, Google Sheets, or any text editor';
        icon = LucideIcons.table;
        color = Colors.green;
        break;

      case ExportFormat.json:
        info = 'JSON files are ideal for developers and API integrations';
        icon = LucideIcons.braces;
        color = Colors.blue;
        break;

      case ExportFormat.xlsx:
        info = 'Excel files include data sheet and optional metadata sheet';
        icon = LucideIcons.fileSpreadsheet;
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              info,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get icon for export format
  IconData _getFormatIcon(ExportFormat format) {
    switch (format) {
      case ExportFormat.csv:
        return LucideIcons.table;
      case ExportFormat.json:
        return LucideIcons.braces;
      case ExportFormat.xlsx:
        return LucideIcons.fileSpreadsheet;
    }
  }
}