/// Generated records preview widget
///
/// Displays generated data in a user-friendly table format with copy functionality

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
  final Function(Map<String, dynamic>) onCopySingle;
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
    final endIndex = (startIndex + _recordsPerPage).clamp(0, widget.records.length);
    final currentRecords = widget.records.sublist(startIndex, endIndex);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with pagination and actions
            Row(
              children: [
                const Icon(LucideIcons.table),
                const SizedBox(width: 8),
                Text(
                  'Generated Records',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),

                // Copy all button
                IconButton.outlined(
                  onPressed: widget.onCopyAll,
                  icon: const Icon(LucideIcons.copy),
                  tooltip: 'Copy All Records (JSON)',
                ),
              ],
            ),

            if (totalPages > 1) ...[
              const SizedBox(height: 8),
              _buildPagination(totalPages),
            ],

            const SizedBox(height: 16),

            // Records table
            _buildRecordsTable(currentRecords),
          ],
        ),
      ),
    );
  }

  /// Build pagination controls
  Widget _buildPagination(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _currentPage > 0
              ? () => setState(() => _currentPage--)
              : null,
          icon: const Icon(LucideIcons.chevronLeft),
        ),
        Text(
          'Page ${_currentPage + 1} of $totalPages',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        IconButton(
          onPressed: _currentPage < totalPages - 1
              ? () => setState(() => _currentPage++)
              : null,
          icon: const Icon(LucideIcons.chevronRight),
        ),
      ],
    );
  }

  /// Build records table
  Widget _buildRecordsTable(List<Map<String, dynamic>> records) {
    final displayFields = _getDisplayFields(widget.templateType);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                ...displayFields.map((field) {
                  return Expanded(
                    child: Text(
                      field.toUpperCase(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(width: 40), // Space for action button
              ],
            ),
          ),

          // Data rows
          ...records.asMap().entries.map((entry) {
            final index = entry.key;
            final record = entry.value;
            final isLast = index == records.length - 1;

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: index.isEven
                    ? Colors.transparent
                    : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
                borderRadius: isLast
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  ...displayFields.map((field) {
                    final value = record[field]?.toString() ?? '-';
                    final displayValue = _formatFieldValue(field, value);

                    return Expanded(
                      child: SelectableText(
                        displayValue,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: _isMonospaceField(field) ? 'monospace' : null,
                        ),
                      ),
                    );
                  }).toList(),

                  // Copy single record button
                  IconButton(
                    onPressed: () => widget.onCopySingle(record),
                    icon: const Icon(LucideIcons.copy, size: 16),
                    tooltip: 'Copy Record (JSON)',
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// Get display fields based on template type
  List<String> _getDisplayFields(TemplateType templateType) {
    switch (templateType) {
      case TemplateType.individual:
        return ['pan', 'aadhaar', 'state', 'pin_code'];

      case TemplateType.company:
        return ['pan', 'gstin', 'cin', 'state'];

      case TemplateType.proprietorship:
        return ['pan', 'gstin', 'udyam', 'state'];

      case TemplateType.partnership:
        return ['pan', 'gstin', 'tan', 'state'];

      case TemplateType.trust:
        return ['pan', 'trust_type', 'gst_registered', 'state'];
    }
  }

  /// Format field value for display
  String _formatFieldValue(String field, String value) {
    switch (field) {
      case 'gst_registered':
        return value.toLowerCase() == 'true' ? 'Yes' : 'No';

      case 'trust_type':
        return value.replaceAll('_', ' ').split(' ').map((word) {
          return word.substring(0, 1).toUpperCase() + word.substring(1);
        }).join(' ');

      default:
        // Truncate long values
        if (value.length > 20) {
          return '${value.substring(0, 17)}...';
        }
        return value;
    }
  }

  /// Check if field should use monospace font
  bool _isMonospaceField(String field) {
    const monospaceFields = [
      'pan', 'gstin', 'aadhaar', 'cin', 'tan', 'ifsc', 'pin_code', 'udyam'
    ];
    return monospaceFields.contains(field);
  }
}