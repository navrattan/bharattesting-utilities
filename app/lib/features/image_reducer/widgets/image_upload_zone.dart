import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bharattesting_core/core.dart' hide ImageFormat;

class ImageUploadZone extends StatefulWidget {
  final Function(List<PlatformFile>) onImagesSelected;
  final VoidCallback onImagesPicked;

  const ImageUploadZone({
    super.key,
    required this.onImagesSelected,
    required this.onImagesPicked,
  });

  @override
  State<ImageUploadZone> createState() => _ImageUploadZoneState();
}

class _ImageUploadZoneState extends State<ImageUploadZone>
    with SingleTickerProviderStateMixin {
  bool _isDragOver = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 200,
          maxWidth: 600,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isDragOver
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: _isDragOver ? 2 : 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16),
          color: _isDragOver
              ? theme.colorScheme.primaryContainer.withOpacity(0.1)
              : theme.colorScheme.surfaceVariant.withOpacity(0.3),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onImagesPicked,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isDragOver ? Icons.file_download : Icons.cloud_upload_outlined,
                    size: 64,
                    color: _isDragOver
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isDragOver
                        ? 'Drop images here'
                        : 'Upload Images',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: _isDragOver
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Drag and drop images here or click to browse',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSupportedFormatChip('JPEG', theme),
                      _buildSupportedFormatChip('PNG', theme),
                      _buildSupportedFormatChip('WebP', theme),
                      _buildSupportedFormatChip('BMP', theme),
                      _buildSupportedFormatChip('GIF', theme),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: widget.onImagesPicked,
                    icon: const Icon(Icons.file_upload),
                    label: const Text('Choose Files'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupportedFormatChip(String format, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        format,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: 11,
        ),
      ),
    );
  }

  void _handleDragEnter() {
    if (!_isDragOver) {
      setState(() {
        _isDragOver = true;
      });
      _animationController.forward();
    }
  }

  void _handleDragLeave() {
    if (_isDragOver) {
      setState(() {
        _isDragOver = false;
      });
      _animationController.reverse();
    }
  }

  void _handleDragDrop(List<PlatformFile> files) {
    _handleDragLeave();
    widget.onImagesSelected(files);
  }
}