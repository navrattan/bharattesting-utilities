import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/document_scanner_state.dart';

class ScanControlsWidget extends StatelessWidget {
  final bool isCapturing;
  final bool isAutoCapture;
  final bool canCapture;
  final bool enableFlash;
  final double zoomLevel;
  final ScannerMode mode;
  final VoidCallback onCapture;
  final VoidCallback onAutoCaptureToggle;
  final VoidCallback onFlashToggle;
  final VoidCallback onSwitchMode;
  final ValueChanged<double> onZoomChanged;

  const ScanControlsWidget({
    super.key,
    required this.isCapturing,
    required this.isAutoCapture,
    required this.canCapture,
    required this.enableFlash,
    required this.zoomLevel,
    required this.mode,
    required this.onCapture,
    required this.onAutoCaptureToggle,
    required this.onFlashToggle,
    required this.onSwitchMode,
    required this.onZoomChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Zoom slider
          if (mode == ScannerMode.camera)
            _buildZoomControl(theme),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Flash toggle
              _buildIconButton(
                icon: enableFlash ? LucideIcons.zap : LucideIcons.zapOff,
                onPressed: onFlashToggle,
                isSelected: enableFlash,
                theme: theme,
              ),

              // Capture button
              _buildCaptureButton(theme),

              // Auto-capture toggle
              _buildIconButton(
                icon: LucideIcons.focus,
                onPressed: onAutoCaptureToggle,
                isSelected: isAutoCapture,
                theme: theme,
                badge: isAutoCapture ? 'AUTO' : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZoomControl(ThemeData theme) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.remove, size: 16, color: Colors.white),
          Expanded(
            child: Slider(
              value: zoomLevel,
              min: 1.0,
              max: 5.0,
              onChanged: onZoomChanged,
              activeColor: theme.colorScheme.primary,
              inactiveColor: Colors.white30,
            ),
          ),
          const Icon(Icons.add, size: 16, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isSelected,
    required ThemeData theme,
    String? badge,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isSelected 
                ? theme.colorScheme.primary 
                : Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
            color: isSelected ? theme.colorScheme.onPrimary : Colors.white,
          ),
        ),
        if (badge != null)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCaptureButton(ThemeData theme) {
    return InkWell(
      onTap: isCapturing || !canCapture ? null : onCapture,
      child: Container(
        width: 72,
        height: 72,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isCapturing ? Colors.grey : Colors.white,
            shape: BoxShape.circle,
          ),
          child: isCapturing
              ? const Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
