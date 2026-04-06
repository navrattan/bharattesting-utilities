import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

/// Widget for displaying camera preview with tap-to-focus functionality
class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget({
    super.key,
    required this.controller,
    this.onTap,
    this.aspectRatio,
  });

  final CameraController controller;
  final void Function(Offset position)? onTap;
  final double? aspectRatio;

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _focusAnimationController;
  late Animation<double> _focusAnimation;
  Offset? _focusPoint;
  bool _showFocusIndicator = false;

  @override
  void initState() {
    super.initState();
    _focusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _focusAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _focusAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _focusAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ClipRect(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate the proper size to maintain aspect ratio
          final size = _calculateCameraPreviewSize(constraints);

          return SizedBox(
            width: size.width,
            height: size.height,
            child: Stack(
              children: [
                // Camera preview
                GestureDetector(
                  onTapDown: (details) => _handleTap(details, size),
                  child: CameraPreview(
                    widget.controller,
                    child: Container(), // Empty container to make the entire area tappable
                  ),
                ),

                // Focus indicator
                if (_showFocusIndicator && _focusPoint != null)
                  Positioned(
                    left: _focusPoint!.dx - 30,
                    top: _focusPoint!.dy - 30,
                    child: AnimatedBuilder(
                      animation: _focusAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _focusAnimation.value,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Camera controls overlay (zoom, etc.)
                _buildCameraOverlay(context),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Calculate camera preview size maintaining aspect ratio
  Size _calculateCameraPreviewSize(BoxConstraints constraints) {
    final aspectRatio = widget.aspectRatio ??
      (kIsWeb ? 16 / 9 : widget.controller.value.aspectRatio);

    double width = constraints.maxWidth;
    double height = width / aspectRatio;

    // If calculated height exceeds available height, scale by height
    if (height > constraints.maxHeight) {
      height = constraints.maxHeight;
      width = height * aspectRatio;
    }

    return Size(width, height);
  }

  /// Handle tap on camera preview for focus
  void _handleTap(TapDownDetails details, Size previewSize) {
    if (!mounted) return;

    // Calculate relative position
    final dx = details.localPosition.dx;
    final dy = details.localPosition.dy;

    // Show focus indicator
    setState(() {
      _focusPoint = Offset(dx, dy);
      _showFocusIndicator = true;
    });

    // Start focus animation
    _focusAnimationController.reset();
    _focusAnimationController.forward();

    // Hide focus indicator after animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showFocusIndicator = false;
        });
      }
    });

    // Convert to normalized coordinates (0.0 - 1.0)
    final normalizedX = dx / previewSize.width;
    final normalizedY = dy / previewSize.height;

    // Set focus point on camera
    _setFocusPoint(Offset(normalizedX, normalizedY));

    // Call callback if provided
    widget.onTap?.call(details.localPosition);
  }

  /// Set focus point on camera controller
  Future<void> _setFocusPoint(Offset normalizedPoint) async {
    if (!widget.controller.value.isInitialized) return;

    try {
      // Set focus mode to auto
      await widget.controller.setFocusMode(FocusMode.auto);

      // Set focus point
      await widget.controller.setFocusPoint(normalizedPoint);

      // Set exposure point to same location
      await widget.controller.setExposurePoint(normalizedPoint);

    } catch (e) {
      debugPrint('Error setting focus point: $e');
    }
  }

  /// Build camera overlay with controls
  Widget _buildCameraOverlay(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          // Add subtle vignette effect
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.1),
            ],
            stops: const [0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Grid overlay (rule of thirds)
            if (_shouldShowGrid())
              _buildGridOverlay(context),

            // Level indicator
            if (!kIsWeb && (Platform.isIOS || Platform.isAndroid))
              _buildLevelIndicator(context),

            // Camera info overlay
            _buildCameraInfoOverlay(context),
          ],
        ),
      ),
    );
  }

  /// Build grid overlay for composition
  Widget _buildGridOverlay(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: GridPainter(
          color: Colors.white.withOpacity(0.3),
          strokeWidth: 1.0,
        ),
      ),
    );
  }

  /// Build level indicator for straight photos
  Widget _buildLevelIndicator(BuildContext context) {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 100,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Level line
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              // Level bubble (placeholder - would need actual device orientation)
              Positioned(
                left: 48, // Center position
                top: 2,
                child: Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build camera info overlay
  Widget _buildCameraInfoOverlay(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.controller.value.previewSize?.width.toInt()}×${widget.controller.value.previewSize?.height.toInt()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'ISO: Auto • 1/60s',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Check if grid should be shown (can be a setting)
  bool _shouldShowGrid() {
    // This could be configurable through settings
    return true;
  }
}

/// Custom painter for rule of thirds grid
class GridPainter extends CustomPainter {
  const GridPainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Vertical lines
    canvas.drawLine(
      Offset(size.width / 3, 0),
      Offset(size.width / 3, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 2 / 3, 0),
      Offset(size.width * 2 / 3, size.height),
      paint,
    );

    // Horizontal lines
    canvas.drawLine(
      Offset(0, size.height / 3),
      Offset(size.width, size.height / 3),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 2 / 3),
      Offset(size.width, size.height * 2 / 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Camera preview aspect ratio presets
class CameraAspectRatios {
  static const double standard = 4 / 3;  // 1.33
  static const double photo = 3 / 2;     // 1.5
  static const double widescreen = 16 / 9; // 1.78
  static const double square = 1 / 1;     // 1.0
  static const double ultraWide = 21 / 9; // 2.33
}

/// Camera preview size presets
enum CameraPreviewSize {
  small(320, 240),
  medium(640, 480),
  large(1280, 720),
  full(1920, 1080);

  const CameraPreviewSize(this.width, this.height);

  final int width;
  final int height;

  double get aspectRatio => width / height;

  Size get size => Size(width.toDouble(), height.toDouble());
}