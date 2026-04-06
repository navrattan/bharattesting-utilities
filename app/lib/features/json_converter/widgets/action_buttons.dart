import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final bool canCopy;
  final bool canClear;
  final bool autoRepairEnabled;
  final bool prettifyEnabled;
  final VoidCallback onCopy;
  final VoidCallback onPaste;
  final VoidCallback onClear;
  final VoidCallback onToggleAutoRepair;
  final VoidCallback onTogglePrettify;
  final VoidCallback onProcess;

  const ActionButtons({
    super.key,
    required this.canCopy,
    required this.canClear,
    required this.autoRepairEnabled,
    required this.prettifyEnabled,
    required this.onCopy,
    required this.onPaste,
    required this.onClear,
    required this.onToggleAutoRepair,
    required this.onTogglePrettify,
    required this.onProcess,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Primary actions row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToggleButton(
              context,
              icon: Icons.build_circle_outlined,
              label: 'Auto-repair',
              isActive: autoRepairEnabled,
              onPressed: onToggleAutoRepair,
              tooltip: 'Automatically fix common JSON issues',
            ),
            const SizedBox(width: 8),
            _buildToggleButton(
              context,
              icon: Icons.format_indent_increase,
              label: 'Prettify',
              isActive: prettifyEnabled,
              onPressed: onTogglePrettify,
              tooltip: 'Format output with indentation',
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Secondary actions row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onPaste,
              icon: const Icon(Icons.content_paste),
              tooltip: 'Paste from clipboard',
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceVariant,
                foregroundColor: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: canCopy ? onCopy : null,
              icon: const Icon(Icons.copy),
              tooltip: 'Copy output to clipboard',
              style: IconButton.styleFrom(
                backgroundColor: canCopy
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceVariant,
                foregroundColor: canCopy
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: canClear ? onClear : null,
              icon: const Icon(Icons.clear),
              tooltip: 'Clear all',
              style: IconButton.styleFrom(
                backgroundColor: canClear
                    ? theme.colorScheme.errorContainer
                    : theme.colorScheme.surfaceVariant,
                foregroundColor: canClear
                    ? theme.colorScheme.onErrorContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Process button
        FilledButton.icon(
          onPressed: onProcess,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Process'),
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            minimumSize: const Size(120, 40),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    final theme = Theme.of(context);

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isActive
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isActive
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}