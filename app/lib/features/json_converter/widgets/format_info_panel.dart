import 'package:flutter/material.dart';
import 'package:bharattesting_core/src/json_converter/json_converter.dart';

class FormatInfoPanel extends StatelessWidget {
  final String detectedFormat;
  final String confidence;
  final List<RepairRule> appliedRepairs;
  final bool hasWarnings;
  final int warningCount;

  const FormatInfoPanel({
    super.key,
    required this.detectedFormat,
    required this.confidence,
    required this.appliedRepairs,
    this.hasWarnings = false,
    this.warningCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Detection info
            Row(
              children: [
                _buildFormatChip(context, detectedFormat),
                const SizedBox(width: 8),
                _buildConfidenceChip(context, confidence),
                if (appliedRepairs.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  _buildRepairChip(context, appliedRepairs.length),
                ],
                if (hasWarnings) ...[
                  const SizedBox(width: 8),
                  _buildWarningChip(context, warningCount),
                ],
              ],
            ),

            // Applied repairs details
            if (appliedRepairs.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Applied Repairs:',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: appliedRepairs.map((repair) {
                  return _buildRepairDetailChip(context, repair);
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFormatChip(BuildContext context, String format) {
    final theme = Theme.of(context);
    final isUnknown = format == 'Unknown';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isUnknown
            ? theme.colorScheme.surfaceVariant
            : theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUnknown ? Icons.help_outline : Icons.code,
            size: 14,
            color: isUnknown
                ? theme.colorScheme.onSurfaceVariant
                : theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            format,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isUnknown
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceChip(BuildContext context, String confidence) {
    final theme = Theme.of(context);

    Color getConfidenceColor() {
      switch (confidence) {
        case 'High confidence':
          return theme.colorScheme.tertiary;
        case 'Medium confidence':
          return Colors.orange;
        case 'Low confidence':
          return Colors.amber;
        default:
          return theme.colorScheme.surfaceVariant;
      }
    }

    Color getConfidenceOnColor() {
      switch (confidence) {
        case 'High confidence':
          return theme.colorScheme.onTertiary;
        case 'Medium confidence':
          return Colors.white;
        case 'Low confidence':
          return Colors.black87;
        default:
          return theme.colorScheme.onSurfaceVariant;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: getConfidenceColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: getConfidenceColor().withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        confidence,
        style: theme.textTheme.bodySmall?.copyWith(
          color: getConfidenceOnColor(),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRepairChip(BuildContext context, int repairCount) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.secondary.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.build_circle_outlined,
            size: 12,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 4),
          Text(
            '$repairCount repair${repairCount == 1 ? '' : 's'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningChip(BuildContext context, int count) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            size: 12,
            color: Colors.orange.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            '$count warning${count == 1 ? '' : 's'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.orange.shade700,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepairDetailChip(BuildContext context, RepairRule repair) {
    final theme = Theme.of(context);

    String getRepairDisplayName(RepairRule rule) {
      switch (rule) {
        case RepairRule.trailingCommas:
          return 'Trailing commas';
        case RepairRule.singleQuotes:
          return 'Single quotes';
        case RepairRule.unquotedKeys:
          return 'Unquoted keys';
        case RepairRule.jsComments:
          return 'JS comments';
        case RepairRule.pythonLiterals:
          return 'Python literals';
        case RepairRule.trailingText:
          return 'Trailing text';
      }
    }

    IconData getRepairIcon(RepairRule rule) {
      switch (rule) {
        case RepairRule.trailingCommas:
          return Icons.remove_circle_outline;
        case RepairRule.singleQuotes:
          return Icons.format_quote;
        case RepairRule.unquotedKeys:
          return Icons.code;
        case RepairRule.jsComments:
          return Icons.comment;
        case RepairRule.pythonLiterals:
          return Icons.translate;
        case RepairRule.trailingText:
          return Icons.content_cut;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            getRepairIcon(repair),
            size: 10,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            getRepairDisplayName(repair),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
