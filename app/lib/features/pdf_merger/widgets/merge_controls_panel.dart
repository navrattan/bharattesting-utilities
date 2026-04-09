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
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Merge Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Encryption'),
              subtitle: const Text('Protect PDF with a password'),
              value: enableEncryption,
              onChanged: (_) => onToggleEncryption(),
            ),
            if (enableEncryption) ...[
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'User Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                onChanged: onPasswordChanged,
                obscureText: true,
              ),
            ],
            const Divider(height: 32),
            _buildMergeOption(
              context,
              'Generate Bookmarks',
              mergeOptions.generateBookmarks,
              (val) => onMergeOptionsChanged(mergeOptions.copyWith(generateBookmarks: val)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMergeOption(BuildContext context, String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}
