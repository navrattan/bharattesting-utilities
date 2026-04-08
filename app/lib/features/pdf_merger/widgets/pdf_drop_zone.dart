import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class PdfDropZone extends StatefulWidget {
  final Function(List<PlatformFile>) onFilesAdded;
  final bool isLoading;
  final int maxFiles;

  const PdfDropZone({
    super.key,
    required this.onFilesAdded,
    this.isLoading = false,
    this.maxFiles = 20,
  });

  @override
  State<PdfDropZone> createState() => _PdfDropZoneState();
}

class _PdfDropZoneState extends State<PdfDropZone>
    with TickerProviderStateMixin {
  bool _isDragOver = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isDragOver ? 1.02 : _pulseAnimation.value,
          child: DragTarget<List<PlatformFile>>(
            onWillAccept: (data) {
              if (widget.isLoading) return false;
              setState(() => _isDragOver = true);
              return true;
            },
            onLeave: (data) => setState(() => _isDragOver = false),
            onAccept: (files) {
              setState(() => _isDragOver = false);
              widget.onFilesAdded(files);
            },
            builder: (context, candidateData, rejectedData) {
              return GestureDetector(
                onTap: widget.isLoading ? null : _pickFiles,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(theme),
                    border: Border.all(
                      color: _getBorderColor(theme),
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: widget.isLoading
                      ? _buildLoadingState(theme)
                      : _buildIdleState(theme),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Processing PDF files...',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Please wait while we analyze your documents',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildIdleState(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _isDragOver ? Icons.file_download : Icons.picture_as_pdf_outlined,
          size: 48,
          color: _getIconColor(theme),
        ),
        const SizedBox(height: 16),
        Text(
          _isDragOver ? 'Drop PDF files here' : 'Drop PDF files or click to browse',
          style: theme.textTheme.titleMedium?.copyWith(
            color: _getTextColor(theme),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Supports multiple PDF files (max ${widget.maxFiles})',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Click to browse',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    if (_isDragOver) {
      return theme.colorScheme.primaryContainer.withOpacity(0.3);
    }
    return theme.colorScheme.surfaceVariant.withOpacity(0.3);
  }

  Color _getBorderColor(ThemeData theme) {
    if (_isDragOver) {
      return theme.colorScheme.primary;
    }
    return theme.colorScheme.outline.withOpacity(0.5);
  }

  Color _getIconColor(ThemeData theme) {
    if (_isDragOver) {
      return theme.colorScheme.primary;
    }
    return theme.colorScheme.onSurfaceVariant;
  }

  Color _getTextColor(ThemeData theme) {
    if (_isDragOver) {
      return theme.colorScheme.primary;
    }
    return theme.colorScheme.onSurface;
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final validFiles = result.files
            .where((file) => file.bytes != null)
            .take(widget.maxFiles)
            .toList();

        if (validFiles.isNotEmpty) {
          widget.onFilesAdded(validFiles);

          if (result.files.length > widget.maxFiles) {
            _showMaxFilesWarning();
          }
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to select files: $e');
    }
  }

  void _showMaxFilesWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_outlined, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Only the first ${widget.maxFiles} files were selected'),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}