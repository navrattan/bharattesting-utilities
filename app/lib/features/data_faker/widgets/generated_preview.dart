/// Preview widget for generated synthetic records
///
/// Provides a paginated table view of the generated data with copy controls

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../faker_state.dart';

/// Widget for previewing generated records
class GeneratedPreview extends StatefulWidget {
  const GeneratedPreview({
    required this.records,
    required this.templateType,
    required this.onCopySingle,
    required this.onCopyAll,
    super.key,
  });

  final List<Map<String, dynamic>> records;
  final TemplateType templateType;
  final void Function(Map<String, dynamic>) onCopySingle;
  final VoidCallback onCopyAll;

  @override
  State<GeneratedPreview> createState() => _GeneratedPreviewState();
}

class _GeneratedPreviewState extends State<GeneratedPreview> {
  int _currentPage = 0;
  static const int _recordsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    if (widget.records.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalPages = (widget.records.length / _recordsPerPage).ceil();
    final startIndex = _currentPage * _recordsPerPage;
    final endIndex = (startIndex + _recordsPerPage < widget.records.length)
        ? startIndex + _recordsPerPage
        : widget.records.length;
    final currentRecords = widget.records.sublist(startIndex, endIndex);

    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          _buildTable(context, currentRecords),
          if (totalPages > 1) _buildPagination(context, totalPages),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(LucideIcons.eye, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Data Preview',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: widget.onCopyAll,
            icon: const Icon(LucideIcons.copy, size: 14),
            label: const Text('Copy All'),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Map<String, dynamic>> records) {
    if (records.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final columns = records.first.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        ),
        columnSpacing: 24,
        columns: [
          ...columns.map((col) => DataColumn(
                label: Text(
                  col.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              )),
          const DataColumn(label: Text('')), // Actions column
        ],
        rows: records.map((record) {
          return DataRow(
            cells: [
              ...columns.map((col) => DataCell(
                    Text(
                      record[col]?.toString() ?? '-',
                      style: theme.textTheme.bodySmall,
                    ),
                  )),
              DataCell(
                IconButton(
                  icon: const Icon(LucideIcons.copy, size: 16),
                  onPressed: () => widget.onCopySingle(record),
                  tooltip: 'Copy record',
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPagination(BuildContext context, int totalPages) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(LucideIcons.chevronLeft, size: 18),
            onPressed: _currentPage > 0
                ? () => setState(() => _currentPage--)
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Page ${_currentPage + 1} of $totalPages',
              style: theme.textTheme.bodySmall,
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.chevronRight, size: 18),
            onPressed: _currentPage < totalPages - 1
                ? () => setState(() => _currentPage++)
                : null,
          ),
        ],
      ),
    );
  }
}
