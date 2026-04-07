import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/document_scanner_state.dart';

/// Widget for configuring export options
class ExportOptionsWidget extends StatelessWidget {
  const ExportOptionsWidget({
    super.key,
    required this.exportFormat,
    required this.includeOcr,
    required this.exportFileName,
    required this.canExport,
    required this.isProcessing,
    required this.onExportFormatChanged,
    required this.onOcrToggled,
    required this.onFileNameChanged,
    required this.onExport,
    this.isCompact = false,
  });

  final ExportFormat exportFormat;
  final bool includeOcr;
  final String exportFileName;
  final bool canExport;
  final bool isProcessing;
  final void Function(ExportFormat format) onExportFormatChanged;
  final void Function(bool enabled) onOcrToggled;
  final void Function(String name) onFileNameChanged;
  final VoidCallback onExport;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactExport(context);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export Options',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Format selection
            _buildFormatSelection(context),
            const SizedBox(height: 16),

            // OCR option
            _buildOcrOption(context),
            const SizedBox(height: 16),

            // File name input
            _buildFileNameInput(context),
            const SizedBox(height: 20),

            // Export button
            _buildExportButton(context),
          ],
        ),
      ),
    );
  }

  /// Build compact export widget for mobile
  Widget _buildCompactExport(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick format selector
          Row(
            children: ExportFormat.values.map((format) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _FormatChip(
                    format: format,
                    isSelected: format == exportFormat,
                    onTap: () => onExportFormatChanged(format),
                    isCompact: true,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Export button
          SizedBox(
            width: double.infinity,
            child: _buildExportButton(context),
          ),
        ],
      ),
    );
  }

  /// Build format selection
  Widget _buildFormatSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Export Format',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ExportFormat.values.map((format) {
            return _FormatChip(
              format: format,
              isSelected: format == exportFormat,
              onTap: () => onExportFormatChanged(format),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Build OCR option toggle
  Widget _buildOcrOption(BuildContext context) {
    return Row(
      children: [
        Icon(
          LucideIcons.type,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Include OCR Text',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Make PDF searchable with extracted text',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: includeOcr,
          onChanged: onOcrToggled,
        ),
      ],
    );
  }

  /// Build file name input
  Widget _buildFileNameInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'File Name',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: exportFileName.isNotEmpty
            ? exportFileName
            : 'BharatTesting_Scan_${DateTime.now().millisecondsSinceEpoch}',
          decoration: InputDecoration(
            hintText: 'Enter file name',
            border: const OutlineInputBorder(),
            suffixText: '.${exportFormat.fileExtension}',
            prefixIcon: const Icon(LucideIcons.file),
          ),
          onChanged: onFileNameChanged,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  /// Build export button
  Widget _buildExportButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: canExport && !isProcessing ? onExport : null,
      icon: isProcessing
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Icon(_getExportIcon(exportFormat)),
      label: Text(
        isProcessing
          ? 'Exporting...'
          : 'Export as ${exportFormat.displayName}',
      ),
    );
  }

  /// Get icon for export format
  IconData _getExportIcon(ExportFormat format) {
    switch (format) {
      case ExportFormat.pdf:
        return Icons.picture_as_pdf;
      case ExportFormat.images:
        return Icons.image;
      case ExportFormat.zip:
        return LucideIcons.package;
    }
  }
}

/// Format selection chip
class _FormatChip extends StatelessWidget {
  const _FormatChip({
    required this.format,
    required this.isSelected,
    required this.onTap,
    this.isCompact = false,
  });

  final ExportFormat format;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 8 : 16,
            vertical: isCompact ? 6 : 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
            border: Border.all(
              color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: isCompact
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getFormatIcon(format),
                    size: 16,
                    color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getShortName(format),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getFormatIcon(format),
                    size: 20,
                    color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        format.displayName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      Text(
                        _getFormatDescription(format),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                            ? Colors.white.withOpacity(0.8)
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        ),
      ),
    );
  }

  IconData _getFormatIcon(ExportFormat format) {
    switch (format) {
      case ExportFormat.pdf:
        return Icons.picture_as_pdf;
      case ExportFormat.images:
        return Icons.image;
      case ExportFormat.zip:
        return LucideIcons.package;
    }
  }

  String _getShortName(ExportFormat format) {
    switch (format) {
      case ExportFormat.pdf:
        return 'PDF';
      case ExportFormat.images:
        return 'IMG';
      case ExportFormat.zip:
        return 'ZIP';
    }
  }

  String _getFormatDescription(ExportFormat format) {
    switch (format) {
      case ExportFormat.pdf:
        return 'Single document';
      case ExportFormat.images:
        return 'Separate files';
      case ExportFormat.zip:
        return 'Archive with images';
    }
  }
}

/// Advanced export options
class AdvancedExportOptions extends StatelessWidget {
  const AdvancedExportOptions({
    super.key,
    required this.exportFormat,
    required this.includeOcr,
    required this.compressImages,
    required this.imageQuality,
    required this.onOcrToggled,
    required this.onCompressionToggled,
    required this.onQualityChanged,
  });

  final ExportFormat exportFormat;
  final bool includeOcr;
  final bool compressImages;
  final int imageQuality;
  final void Function(bool enabled) onOcrToggled;
  final void Function(bool enabled) onCompressionToggled;
  final void Function(int quality) onQualityChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Options',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // OCR toggle
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('Include OCR Text'),
              subtitle: const Text('Make PDF searchable with extracted text'),
              value: includeOcr,
              onChanged: onOcrToggled,
              secondary: const Icon(LucideIcons.type),
            ),

            // Image compression
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('Compress Images'),
              subtitle: const Text('Reduce file size with quality adjustment'),
              value: compressImages,
              onChanged: onCompressionToggled,
              secondary: const Icon(LucideIcons.shrink),
            ),

            // Quality slider (if compression enabled)
            if (compressImages) ...[
              const SizedBox(height: 8),
              Text(
                'Image Quality: $imageQuality%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Slider(
                value: imageQuality.toDouble(),
                min: 10,
                max: 100,
                divisions: 9,
                label: '$imageQuality%',
                onChanged: (value) => onQualityChanged(value.toInt()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Smaller size',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Better quality',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],

            // Format-specific options
            if (exportFormat == ExportFormat.pdf) ...[
              const SizedBox(height: 16),
              _buildPdfOptions(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPdfOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PDF Options',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Password protection toggle
        SwitchListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('Password Protection'),
          subtitle: const Text('Encrypt PDF with password'),
          value: false, // This would come from state
          onChanged: (enabled) {
            // Would trigger password dialog
          },
          secondary: const Icon(LucideIcons.lock),
        ),

        // Page orientation
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('Page Orientation'),
          subtitle: const Text('Auto-detect from content'),
          trailing: DropdownButton<String>(
            value: 'auto',
            items: const [
              DropdownMenuItem(value: 'auto', child: Text('Auto')),
              DropdownMenuItem(value: 'portrait', child: Text('Portrait')),
              DropdownMenuItem(value: 'landscape', child: Text('Landscape')),
            ],
            onChanged: (value) {
              // Handle orientation change
            },
          ),
          leading: const Icon(Icons.rotate_right),
        ),
      ],
    );
  }
}

/// Export progress dialog
class ExportProgressDialog extends StatelessWidget {
  const ExportProgressDialog({
    super.key,
    required this.progress,
    required this.currentStep,
    required this.totalSteps,
    required this.onCancel,
  });

  final double progress;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Exporting Document...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 8),
          Text(
            'Step $currentStep of $totalSteps',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

/// Export success dialog
class ExportSuccessDialog extends StatelessWidget {
  const ExportSuccessDialog({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.onShare,
    required this.onSaveToDevice,
    required this.onClose,
  });

  final String fileName;
  final String fileSize;
  final VoidCallback onShare;
  final VoidCallback onSaveToDevice;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        LucideIcons.checkCircle,
        color: Theme.of(context).colorScheme.secondary,
        size: 48,
      ),
      title: const Text('Export Successful'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your document has been exported successfully.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.file),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fileName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(LucideIcons.hardDrive, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      fileSize,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: onShare,
          icon: const Icon(LucideIcons.share),
          label: const Text('Share'),
        ),
        TextButton.icon(
          onPressed: onSaveToDevice,
          icon: const Icon(LucideIcons.download),
          label: const Text('Save'),
        ),
        FilledButton(
          onPressed: onClose,
          child: const Text('Done'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}
