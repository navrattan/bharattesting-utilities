import 'package:flutter/material.dart';
import 'package:bharattesting_core/core.dart' as core;
import '../models/pdf_merger_state.dart' hide PdfPermissions, PdfMergeOptions;

class MergeControlsPanel extends StatelessWidget {
  final bool enableEncryption;
  final VoidCallback onToggleEncryption;
  final String password;
  final ValueChanged<String> onPasswordChanged;
  final core.PdfPermissions permissions;
  final ValueChanged<core.PdfPermissions> onPermissionsChanged;
  final core.PdfMergeOptions mergeOptions;
  final ValueChanged<core.PdfMergeOptions> onMergeOptionsChanged;
  final bool isProcessing;
  final VoidCallback onMerge;

  const MergeControlsPanel({
    super.key,
    required this.enableEncryption,
    required this.onToggleEncryption,
    required this.password,
    required this.onPasswordChanged,
    required this.permissions,
    required this.onPermissionsChanged,
    required this.mergeOptions,
    required this.onMergeOptionsChanged,
    required this.isProcessing,
    required this.onMerge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Merge Options', style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Generate Bookmarks'),
                  subtitle: const Text('Create index from original file names'),
                  value: mergeOptions.generateBookmarks,
                  onChanged: (val) => onMergeOptionsChanged(mergeOptions.copyWith(generateBookmarks: val)),
                ),
                SwitchListTile(
                  title: const Text('Preserve Metadata'),
                  subtitle: const Text('Keep author, creator and keywords'),
                  value: mergeOptions.preserveMetadata,
                  onChanged: (val) => onMergeOptionsChanged(mergeOptions.copyWith(preserveMetadata: val)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: isProcessing ? null : onMerge,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          icon: isProcessing 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.merge_type),
          label: Text(isProcessing ? 'Processing...' : 'Merge PDFs'),
        ),
      ],
    );
  }
}
