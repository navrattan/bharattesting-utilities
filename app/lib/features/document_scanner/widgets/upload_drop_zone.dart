import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Widget for uploading images via drag-and-drop or file picker
class UploadDropZone extends StatefulWidget {
  const UploadDropZone({
    super.key,
    required this.onImageUploaded,
    this.allowMultiple = false,
    this.maxFileSize = 10 * 1024 * 1024, // 10MB
    this.allowedExtensions = const ['jpg', 'jpeg', 'png', 'tiff', 'bmp'],
  });

  final void Function(Uint8List imageBytes) onImageUploaded;
  final bool allowMultiple;
  final int maxFileSize;
  final List<String> allowedExtensions;

  @override
  State<UploadDropZone> createState() => _UploadDropZoneState();
}

class _UploadDropZoneState extends State<UploadDropZone>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _isDragOver = false;
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
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
    if (kIsWeb) {
      return _buildWebDropZone(context);
    } else {
      return _buildMobileUploadZone(context);
    }
  }

  /// Build web drop zone with drag-and-drop support
  Widget _buildWebDropZone(BuildContext context) {
    return GestureDetector(
      onTap: _pickFile,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: _isUploading
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing image...'),
                  ],
                ),
              )
            : _buildUploadContent(context),
      ),
    );
  }

  /// Build mobile upload zone (file picker only)
  Widget _buildMobileUploadZone(BuildContext context) {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: _isUploading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing image...'),
                ],
              ),
            )
          : _buildUploadContent(context),
      ),
    );
  }

  /// Build upload content UI
  Widget _buildUploadContent(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _isDragOver
          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
          : Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: _isDragOver
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline,
          width: _isDragOver ? 3 : 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Upload icon
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _isDragOver
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Theme.of(context).colorScheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isDragOver ? LucideIcons.download : LucideIcons.upload,
              size: 64,
              color: _isDragOver
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          // Main text
          Text(
            _isDragOver
              ? 'Drop your image here'
              : kIsWeb
                ? 'Drag and drop an image here'
                : 'Tap to select an image',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: _isDragOver
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Secondary text
          Text(
            kIsWeb ? 'or click to browse files' : 'Choose from your device',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Supported formats
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Supported: ${widget.allowedExtensions.map((e) => e.toUpperCase()).join(', ')}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // File size limit
          Text(
            'Max size: ${_formatFileSize(widget.maxFileSize)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),

          // Browse button for web
          if (kIsWeb) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _pickFile,
              icon: const Icon(LucideIcons.folderOpen),
              label: const Text('Browse Files'),
            ),
          ],

          // Error message
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.alertCircle,
                    size: 20,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      _errorMessage!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Pick file using file picker
  Future<void> _pickFile() async {
    try {
      setState(() {
        _isUploading = true;
        _errorMessage = null;
      });

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.allowedExtensions,
        allowMultiple: widget.allowMultiple,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (!_isValidFile(file.name, file.size)) {
          return;
        }

        final bytes = file.bytes;
        if (bytes != null) {
          widget.onImageUploaded(bytes);
        } else {
          _showError('Could not read file data');
        }
      }

    } catch (e) {
      _showError('Failed to pick file: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  /// Validate file name and size
  bool _isValidFile(String fileName, int? fileSize) {
    // Check extension
    final extension = fileName.split('.').last.toLowerCase();
    if (!widget.allowedExtensions.contains(extension)) {
      _showError(
        'Unsupported file type: $extension\n'
        'Supported: ${widget.allowedExtensions.join(', ')}',
      );
      return false;
    }

    // Check size
    if (fileSize != null && fileSize > widget.maxFileSize) {
      _showError(
        'File too large: ${_formatFileSize(fileSize)}\n'
        'Maximum: ${_formatFileSize(widget.maxFileSize)}',
      );
      return false;
    }

    return true;
  }

  /// Show error message
  void _showError(String message) {
    setState(() {
      _errorMessage = message;
      _isUploading = false;
    });

    // Auto-clear error after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _errorMessage = null);
      }
    });
  }

  /// Format file size for display
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Compact upload button for mobile
class CompactUploadButton extends StatefulWidget {
  const CompactUploadButton({
    super.key,
    required this.onImageUploaded,
    this.allowedExtensions = const ['jpg', 'jpeg', 'png', 'tiff', 'bmp'],
    this.maxFileSize = 10 * 1024 * 1024,
  });

  final void Function(Uint8List imageBytes) onImageUploaded;
  final List<String> allowedExtensions;
  final int maxFileSize;

  @override
  State<CompactUploadButton> createState() => _CompactUploadButtonState();
}

class _CompactUploadButtonState extends State<CompactUploadButton> {
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: _isUploading ? null : _pickFile,
      icon: _isUploading
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : const Icon(LucideIcons.upload),
      label: Text(_isUploading ? 'Uploading...' : 'Upload Image'),
    );
  }

  Future<void> _pickFile() async {
    try {
      setState(() => _isUploading = true);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Validate file size
        if (file.size > widget.maxFileSize) {
          _showSnackBar(
            'File too large. Maximum size: ${_formatFileSize(widget.maxFileSize)}',
            isError: true,
          );
          return;
        }

        final bytes = file.bytes;
        if (bytes != null) {
          widget.onImageUploaded(bytes);
          _showSnackBar('Image uploaded successfully');
        }
      }

    } catch (e) {
      _showSnackBar('Failed to upload: $e', isError: true);
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Multiple file upload widget
class MultipleFileUploadWidget extends StatefulWidget {
  const MultipleFileUploadWidget({
    super.key,
    required this.onImagesUploaded,
    this.maxFiles = 10,
    this.maxFileSize = 10 * 1024 * 1024,
    this.allowedExtensions = const ['jpg', 'jpeg', 'png', 'tiff', 'bmp'],
  });

  final void Function(List<Uint8List> imageBytes) onImagesUploaded;
  final int maxFiles;
  final int maxFileSize;
  final List<String> allowedExtensions;

  @override
  State<MultipleFileUploadWidget> createState() => _MultipleFileUploadWidgetState();
}

class _MultipleFileUploadWidgetState extends State<MultipleFileUploadWidget> {
  final List<Uint8List> _uploadedFiles = [];
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Upload area
        GestureDetector(
          onTap: _pickFiles,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.upload,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Upload Multiple Images',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Select up to ${widget.maxFiles} files',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),

        // File list
        if (_uploadedFiles.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              itemCount: _uploadedFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.memory(
                        _uploadedFiles[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text('Image ${index + 1}'),
                  subtitle: Text(_formatFileSize(_uploadedFiles[index].length)),
                  trailing: IconButton(
                    icon: const Icon(LucideIcons.x),
                    onPressed: () => _removeFile(index),
                  ),
                );
              },
            ),
          ),
        ],

        // Process button
        if (_uploadedFiles.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isUploading ? null : _processFiles,
              icon: _isUploading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(LucideIcons.play),
              label: Text(
                _isUploading
                  ? 'Processing...'
                  : 'Process ${_uploadedFiles.length} Images',
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickFiles() async {
    try {
      setState(() => _isUploading = true);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.allowedExtensions,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final validFiles = <Uint8List>[];

        for (final file in result.files) {
          if (file.bytes != null &&
              file.size <= widget.maxFileSize &&
              _uploadedFiles.length + validFiles.length < widget.maxFiles) {
            validFiles.add(file.bytes!);
          }
        }

        setState(() {
          _uploadedFiles.addAll(validFiles);
        });
      }
    } catch (e) {
      _showError('Failed to pick files: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _removeFile(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
    });
  }

  Future<void> _processFiles() async {
    setState(() => _isUploading = true);

    try {
      widget.onImagesUploaded(_uploadedFiles);
      setState(() => _uploadedFiles.clear());
    } catch (e) {
      _showError('Failed to process files: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
