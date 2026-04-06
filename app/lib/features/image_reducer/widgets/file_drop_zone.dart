import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class FileDropZone extends StatefulWidget {
  final Function(List<PlatformFile>) onFilesSelected;
  final bool isLoading;
  final List<String> allowedExtensions;
  final int maxFiles;
  final String title;
  final String subtitle;

  const FileDropZone({
    super.key,
    required this.onFilesSelected,
    this.isLoading = false,
    this.allowedExtensions = const ['jpg', 'jpeg', 'png', 'webp', 'bmp', 'gif', 'tiff'],
    this.maxFiles = 50,
    this.title = 'Drop images here or click to select',
    this.subtitle = 'Supports JPEG, PNG, WebP, BMP, GIF, TIFF (max 50 files)',
  });

  @override
  State<FileDropZone> createState() => _FileDropZoneState();
}

class _FileDropZoneState extends State<FileDropZone>
    with TickerProviderStateMixin {
  bool _isDragOver = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _hoverAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _hoverAnimation.value,
          child: _buildDropZone(theme),
        );
      },
    );
  }

  Widget _buildDropZone(ThemeData theme) {
    return DragTarget<List<PlatformFile>>(
      onWillAccept: (data) {
        if (widget.isLoading) return false;
        setState(() {
          _isDragOver = true;
        });
        _hoverController.forward();
        return true;
      },
      onLeave: (data) {
        setState(() {
          _isDragOver = false;
        });
        _hoverController.reverse();
      },
      onAccept: (files) {
        setState(() {
          _isDragOver = false;
        });
        _hoverController.reverse();
        _handleFiles(files);
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: widget.isLoading ? null : _pickFiles,
          child: MouseRegion(
            onEnter: (_) => _hoverController.forward(),
            onExit: (_) => _hoverController.reverse(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 200,
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
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Processing files...',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Please wait while we process your images',
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
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isDragOver ? 1.2 : _pulseAnimation.value,
              child: Icon(
                _isDragOver ? Icons.file_download : Icons.cloud_upload_outlined,
                size: 48,
                color: _getIconColor(theme),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          _isDragOver ? 'Drop files to upload' : widget.title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: _getTextColor(theme),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          widget.subtitle,
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
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.allowedExtensions,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final validFiles = result.files.take(widget.maxFiles).toList();
        _handleFiles(validFiles);

        if (result.files.length > widget.maxFiles) {
          _showMaxFilesWarning();
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to select files: $e');
    }
  }

  void _handleFiles(List<PlatformFile> files) {
    if (files.isEmpty) return;

    // Filter valid image files
    final validFiles = files.where((file) {
      if (file.extension == null) return false;
      return widget.allowedExtensions.contains(file.extension!.toLowerCase());
    }).toList();

    if (validFiles.isEmpty) {
      _showErrorSnackBar('No valid image files found');
      return;
    }

    if (validFiles.length != files.length) {
      _showPartialSuccessSnackBar(validFiles.length, files.length);
    }

    widget.onFilesSelected(validFiles);
  }

  void _showMaxFilesWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.warning_outlined,
              color: Colors.orange,
              size: 20,
            ),
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

  void _showPartialSuccessSnackBar(int validCount, int totalCount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text('$validCount of $totalCount files were valid images'),
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
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}