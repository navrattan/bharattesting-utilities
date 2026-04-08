import 'package:flutter/material.dart';
import '../models/pdf_merger_state.dart';

class MergeControlsPanel extends StatelessWidget {
  final bool enableEncryption;
  final VoidCallback onToggleEncryption;
  final String password;
  final ValueChanged<String> onPasswordChanged;
  final PdfPermissions permissions;
  final ValueChanged<PdfPermissions> onPermissionsChanged;
  final PdfMergeOptions mergeOptions;
  final ValueChanged<PdfMergeOptions> onMergeOptionsChanged;

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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Merge Settings',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Encryption section
        _buildEncryptionSection(theme),
        const SizedBox(height: 16),

        // Merge options
        _buildMergeOptionsSection(theme),
      ],
    );
  }

  Widget _buildEncryptionSection(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Security',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: enableEncryption,
                  onChanged: (_) => onToggleEncryption(),
                ),
              ],
            ),

            if (enableEncryption) ...[
              const SizedBox(height: 16),

              // Password field
              TextFormField(
                initialValue: password,
                onChanged: onPasswordChanged,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  helperText: 'Minimum 8 characters',
                ),
              ),

              const SizedBox(height: 16),

              // Permissions
              Text(
                'Permissions',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              _buildPermissionTile('Allow Printing', permissions.allowPrinting, (value) {
                onPermissionsChanged(permissions.copyWith(allowPrinting: value));
              }),
              _buildPermissionTile('Allow Copy', permissions.allowCopy, (value) {
                onPermissionsChanged(permissions.copyWith(allowCopy: value));
              }),
              _buildPermissionTile('Allow Modification', permissions.allowModification, (value) {
                onPermissionsChanged(permissions.copyWith(allowModification: value));
              }),
              _buildPermissionTile('Allow Annotations', permissions.allowAnnotations, (value) {
                onPermissionsChanged(permissions.copyWith(allowAnnotations: value));
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMergeOptionsSection(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.merge, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Merge Options',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SwitchListTile(
              title: const Text('Generate Bookmarks'),
              subtitle: const Text('Create bookmarks from file names'),
              value: mergeOptions.generateBookmarks,
              onChanged: (value) {
                onMergeOptionsChanged(mergeOptions.copyWith(generateBookmarks: value));
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),

            SwitchListTile(
              title: const Text('Preserve Metadata'),
              subtitle: const Text('Keep original PDF metadata'),
              value: mergeOptions.preserveMetadata,
              onChanged: (value) {
                onMergeOptionsChanged(mergeOptions.copyWith(preserveMetadata: value));
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),

            SwitchListTile(
              title: const Text('Optimize for Size'),
              subtitle: const Text('Reduce file size (may affect quality)'),
              value: mergeOptions.optimizeForSize,
              onChanged: (value) {
                onMergeOptionsChanged(mergeOptions.copyWith(optimizeForSize: value));
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 13)),
      value: value,
      onChanged: onChanged,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}
