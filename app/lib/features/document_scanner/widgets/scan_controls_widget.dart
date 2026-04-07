import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/document_scanner_state.dart';

/// Widget containing camera controls for document scanning
class ScanControlsWidget extends StatelessWidget {
  const ScanControlsWidget({
    super.key,
    required this.mode,
    required this.isCapturing,
    required this.enableFlash,
    required this.isAutoCapture,
    required this.zoomLevel,
    required this.canCapture,
    required this.onCapture,
    required this.onFlashToggle,
    required this.onAutoCaptureToggle,
    required this.onZoomChanged,
  });

  final ScannerMode mode;
  final bool isCapturing;
  final bool enableFlash;
  final bool isAutoCapture;
  final double zoomLevel;
  final bool canCapture;
  final VoidCallback onCapture;
  final VoidCallback onFlashToggle;
  final VoidCallback onAutoCaptureToggle;
  final void Function(double zoom) onZoomChanged;

  @override
  Widget build(BuildContext context) {
    if (mode != ScannerMode.camera) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Flash toggle
        _buildControlButton(
          context,
          icon: enableFlash ? LucideIcons.flashlight : LucideIcons.flashlightOff,
          label: 'Flash',
          isActive: enableFlash,
          onPressed: onFlashToggle,
        ),

        // Auto-capture toggle
        _buildControlButton(
          context,
          icon: isAutoCapture ? LucideIcons.target : LucideIcons.circle,
          label: 'Auto',
          isActive: isAutoCapture,
          onPressed: onAutoCaptureToggle,
        ),

        // Capture button
        _buildCaptureButton(context),

        // Zoom control
        _buildZoomControl(context),

        // Gallery/settings
        _buildControlButton(
          context,
          icon: LucideIcons.image,
          label: 'Gallery',
          onPressed: () {
            // Could open gallery or show more options
          },
        ),
      ],
    );
  }

  /// Build main capture button
  Widget _buildCaptureButton(BuildContext context) {
    return GestureDetector(
      onTap: canCapture && !isCapturing ? onCapture : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: canCapture
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isCapturing
          ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          : Icon(
              LucideIcons.camera,
              size: 32,
              color: canCapture ? Colors.white : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
      ),
    );
  }

  /// Build control button
  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isActive = false,
    VoidCallback? onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: 24,
              color: isActive
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  /// Build zoom control
  Widget _buildZoomControl(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => _showZoomSlider(context),
            icon: Icon(
              LucideIcons.zoomIn,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${zoomLevel.toStringAsFixed(1)}x',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  /// Show zoom slider overlay
  void _showZoomSlider(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.zoomOut,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Expanded(
                  child: Slider(
                    value: zoomLevel,
                    min: 1.0,
                    max: 8.0,
                    divisions: 14,
                    label: '${zoomLevel.toStringAsFixed(1)}x',
                    onChanged: onZoomChanged,
                  ),
                ),
                Icon(
                  LucideIcons.zoomIn,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ZoomPresetButton(
                  label: '1x',
                  zoom: 1.0,
                  currentZoom: zoomLevel,
                  onPressed: () => onZoomChanged(1.0),
                ),
                _ZoomPresetButton(
                  label: '2x',
                  zoom: 2.0,
                  currentZoom: zoomLevel,
                  onPressed: () => onZoomChanged(2.0),
                ),
                _ZoomPresetButton(
                  label: '4x',
                  zoom: 4.0,
                  currentZoom: zoomLevel,
                  onPressed: () => onZoomChanged(4.0),
                ),
                _ZoomPresetButton(
                  label: '8x',
                  zoom: 8.0,
                  currentZoom: zoomLevel,
                  onPressed: () => onZoomChanged(8.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Zoom preset button widget
class _ZoomPresetButton extends StatelessWidget {
  const _ZoomPresetButton({
    required this.label,
    required this.zoom,
    required this.currentZoom,
    required this.onPressed,
  });

  final String label;
  final double zoom;
  final double currentZoom;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isActive = (currentZoom - zoom).abs() < 0.1;

    return SizedBox(
      width: 60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isActive
            ? Theme.of(context).colorScheme.primary
            : null,
          foregroundColor: isActive
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface,
          side: BorderSide(
            color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(label),
      ),
    );
  }
}

/// Advanced camera controls for desktop/tablet
class AdvancedCameraControls extends StatelessWidget {
  const AdvancedCameraControls({
    super.key,
    required this.enableFlash,
    required this.isAutoCapture,
    required this.autoCaptureDuration,
    required this.zoomLevel,
    required this.onFlashToggle,
    required this.onAutoCaptureToggle,
    required this.onAutoCaptureDurationChanged,
    required this.onZoomChanged,
  });

  final bool enableFlash;
  final bool isAutoCapture;
  final double autoCaptureDuration;
  final double zoomLevel;
  final VoidCallback onFlashToggle;
  final VoidCallback onAutoCaptureToggle;
  final void Function(double duration) onAutoCaptureDurationChanged;
  final void Function(double zoom) onZoomChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Camera Controls',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Flash control
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('Flash'),
              subtitle: const Text('Enable camera flash'),
              value: enableFlash,
              onChanged: (_) => onFlashToggle(),
              secondary: Icon(
                enableFlash ? LucideIcons.flashlight : LucideIcons.flashlightOff,
              ),
            ),

            // Auto-capture control
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('Auto Capture'),
              subtitle: const Text('Automatically capture when document is stable'),
              value: isAutoCapture,
              onChanged: (_) => onAutoCaptureToggle(),
              secondary: Icon(
                isAutoCapture ? LucideIcons.target : LucideIcons.circle,
              ),
            ),

            // Auto-capture duration
            if (isAutoCapture) ...[
              const SizedBox(height: 8),
              Text(
                'Capture Delay: ${autoCaptureDuration.toStringAsFixed(1)}s',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Slider(
                value: autoCaptureDuration,
                min: 0.5,
                max: 5.0,
                divisions: 9,
                label: '${autoCaptureDuration.toStringAsFixed(1)}s',
                onChanged: onAutoCaptureDurationChanged,
              ),
            ],

            const SizedBox(height: 8),

            // Zoom control
            Text(
              'Zoom: ${zoomLevel.toStringAsFixed(1)}x',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Slider(
              value: zoomLevel,
              min: 1.0,
              max: 8.0,
              divisions: 14,
              label: '${zoomLevel.toStringAsFixed(1)}x',
              onChanged: onZoomChanged,
            ),

            // Zoom presets
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [1.0, 2.0, 4.0, 8.0].map((zoom) {
                final isActive = (zoomLevel - zoom).abs() < 0.1;
                return ChoiceChip(
                  label: Text('${zoom.toStringAsFixed(0)}x'),
                  selected: isActive,
                  onSelected: (_) => onZoomChanged(zoom),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Capture statistics widget
class CaptureStatsWidget extends StatelessWidget {
  const CaptureStatsWidget({
    super.key,
    required this.totalCaptured,
    required this.sessionDuration,
    required this.averageCaptureTime,
    required this.lastCaptureQuality,
  });

  final int totalCaptured;
  final Duration sessionDuration;
  final Duration averageCaptureTime;
  final double lastCaptureQuality;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session Stats',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            _buildStatRow(
              context,
              icon: LucideIcons.image,
              label: 'Pages Captured',
              value: totalCaptured.toString(),
            ),

            _buildStatRow(
              context,
              icon: LucideIcons.clock,
              label: 'Session Time',
              value: _formatDuration(sessionDuration),
            ),

            _buildStatRow(
              context,
              icon: LucideIcons.zap,
              label: 'Avg. Capture Time',
              value: _formatDuration(averageCaptureTime),
            ),

            _buildStatRow(
              context,
              icon: LucideIcons.star,
              label: 'Last Quality',
              value: '${(lastCaptureQuality * 100).toStringAsFixed(0)}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
