import 'package:flutter/material.dart';
import '../models/pdf_merger_state.dart';

class MergeStatisticsPanel extends StatelessWidget {
  final MergeStatistics statistics;

  const MergeStatisticsPanel({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics_outlined, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Merge Statistics',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Documents',
                  statistics.totalDocuments.toString(),
                  Icons.description,
                  theme,
                ),
                _buildStatItem(
                  'Pages',
                  statistics.totalPages.toString(),
                  Icons.pages,
                  theme,
                ),
                _buildStatItem(
                  'Size',
                  statistics.totalSizeText,
                  Icons.storage,
                  theme,
                ),
              ],
            ),

            if (statistics.totalPages > 0) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Est. Output',
                    statistics.outputSizeText,
                    Icons.file_download,
                    theme,
                  ),
                  _buildStatItem(
                    'Compression',
                    statistics.compressionText,
                    Icons.compress,
                    theme,
                  ),
                  _buildStatItem(
                    'Est. Time',
                    statistics.estimatedTimeText,
                    Icons.schedule,
                    theme,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, ThemeData theme) {
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