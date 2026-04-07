import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:bharattesting_core/src/document_scanner/edge_detector.dart';

/// Widget that overlays the camera preview with document detection feedback
class DocumentOverlayWidget extends StatefulWidget {
  const DocumentOverlayWidget({
    super.key,
    required this.quadrilateral,
    required this.isStable,
    this.stabilityScore = 0.0,
    this.showCornerHandles = false,
    this.onCornerMoved,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final DocumentQuadrilateral quadrilateral;
  final bool isStable;
  final double stabilityScore;
  final bool showCornerHandles;
  final void Function(int cornerIndex, Offset newPosition)? onCornerMoved;
  final Duration animationDuration;

  @override
  State<DocumentOverlayWidget> createState() => _DocumentOverlayWidgetState();
}

class _DocumentOverlayWidgetState extends State<DocumentOverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _stabilityController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _stabilityAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _stabilityController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _stabilityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _stabilityController,
      curve: Curves.easeInOut,
    ));

    // Start pulse animation if not stable
    if (!widget.isStable) {
      _pulseController.repeat(reverse: true);
    }

    // Animate stability
    _stabilityController.forward();
  }

  @override
  void didUpdateWidget(DocumentOverlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update pulse animation based on stability
    if (widget.isStable && !oldWidget.isStable) {
      _pulseController.stop();
      _pulseController.reset();
    } else if (!widget.isStable && oldWidget.isStable) {
      _pulseController.repeat(reverse: true);
    }

    // Restart stability animation if quadrilateral changed significantly
    if (_quadrilateralChanged(oldWidget.quadrilateral, widget.quadrilateral)) {
      _stabilityController.reset();
      _stabilityController.forward();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _stabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _stabilityController]),
        builder: (context, child) {
          return CustomPaint(
            painter: DocumentOverlayPainter(
              quadrilateral: widget.quadrilateral,
              isStable: widget.isStable,
              stabilityScore: widget.stabilityScore,
              showCornerHandles: widget.showCornerHandles,
              pulseScale: _pulseAnimation.value,
              stabilityOpacity: _stabilityAnimation.value,
            ),
            child: widget.showCornerHandles
              ? _buildCornerHandles()
              : null,
          );
        },
      ),
    );
  }

  /// Build draggable corner handles for manual crop adjustment
  Widget _buildCornerHandles() {
    return Stack(
      children: widget.quadrilateral.corners.asMap().entries.map((entry) {
        final index = entry.key;
        final corner = entry.value;

        return Positioned(
          left: corner.x - 20,
          top: corner.y - 20,
          child: GestureDetector(
            onPanUpdate: (details) {
              final newPosition = Offset(
                corner.x + details.delta.dx,
                corner.y + details.delta.dy,
              );
              widget.onCornerMoved?.call(index, newPosition);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.drag_handle,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Check if quadrilateral changed significantly
  bool _quadrilateralChanged(DocumentQuadrilateral old, DocumentQuadrilateral current) {
    const threshold = 10.0; // pixels

    for (int i = 0; i < old.corners.length && i < current.corners.length; i++) {
      final distance = math.sqrt(
        math.pow(old.corners[i].x - current.corners[i].x, 2) +
        math.pow(old.corners[i].y - current.corners[i].y, 2),
      );

      if (distance > threshold) {
        return true;
      }
    }

    return false;
  }
}

/// Custom painter for document detection overlay
class DocumentOverlayPainter extends CustomPainter {
  const DocumentOverlayPainter({
    required this.quadrilateral,
    required this.isStable,
    required this.stabilityScore,
    required this.showCornerHandles,
    required this.pulseScale,
    required this.stabilityOpacity,
  });

  final DocumentQuadrilateral quadrilateral;
  final bool isStable;
  final double stabilityScore;
  final bool showCornerHandles;
  final double pulseScale;
  final double stabilityOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    // Create semi-transparent overlay
    _paintOverlay(canvas, size);

    // Paint document outline
    _paintDocumentOutline(canvas, size);

    // Paint corner indicators
    _paintCornerIndicators(canvas, size);

    // Paint stability indicator
    _paintStabilityIndicator(canvas, size);

    // Paint capture hint
    _paintCaptureHint(canvas, size);
  }

  /// Paint semi-transparent overlay around document
  void _paintOverlay(Canvas canvas, Size size) {
    if (quadrilateral.corners.length != 4) return;

    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.5 * stabilityOpacity)
      ..style = PaintingStyle.fill;

    var path = Path();

    // Create path for entire canvas
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create path for document quadrilateral
    final docPath = Path();
    final corners = quadrilateral.corners;

    docPath.moveTo(corners[0].x, corners[0].y);
    for (int i = 1; i < corners.length; i++) {
      docPath.lineTo(corners[i].x, corners[i].y);
    }
    docPath.close();

    // Subtract document area from overlay
    path = Path.combine(PathOperation.difference, path, docPath);

    canvas.drawPath(path, overlayPaint);
  }

  /// Paint document outline
  void _paintDocumentOutline(Canvas canvas, Size size) {
    if (quadrilateral.corners.length != 4) return;

    final outlinePaint = Paint()
      ..color = isStable ? Colors.green : Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0 * pulseScale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Add glow effect for stable detection
    if (isStable) {
      final glowPaint = Paint()
        ..color = Colors.green.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.0 * pulseScale
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3);

      _drawQuadrilateral(canvas, glowPaint);
    }

    _drawQuadrilateral(canvas, outlinePaint);

    // Draw scan lines effect
    if (isStable) {
      _paintScanLines(canvas, size);
    }
  }

  /// Paint corner indicators
  void _paintCornerIndicators(Canvas canvas, Size size) {
    if (quadrilateral.corners.length != 4 || showCornerHandles) return;

    final cornerPaint = Paint()
      ..color = isStable ? Colors.green : Colors.orange
      ..style = PaintingStyle.fill;

    final cornerRadius = 6.0 * pulseScale;

    for (final corner in quadrilateral.corners) {
      canvas.drawCircle(
        Offset(corner.x, corner.y),
        cornerRadius,
        cornerPaint,
      );

      // Add white center
      final centerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(corner.x, corner.y),
        cornerRadius * 0.4,
        centerPaint,
      );
    }
  }

  /// Paint stability indicator
  void _paintStabilityIndicator(Canvas canvas, Size size) {
    if (!isStable || stabilityScore <= 0) return;

    final center = _getQuadrilateralCenter();
    if (center == null) return;

    // Progress ring
    final ringPaint = Paint()
      ..color = Colors.green.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final ringRect = Rect.fromCircle(center: center, radius: 30);
    final sweepAngle = 2 * math.pi * math.min(stabilityScore, 1.0);

    canvas.drawArc(ringRect, -math.pi / 2, sweepAngle, false, ringPaint);

    // Checkmark icon when fully stable
    if (stabilityScore >= 0.95) {
      _paintCheckmark(canvas, center);
    }
  }

  /// Paint capture hint
  void _paintCaptureHint(Canvas canvas, Size size) {
    if (!isStable || stabilityScore < 0.8) return;

    final center = _getQuadrilateralCenter();
    if (center == null) return;

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Tap to capture',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.7),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy + 50,
    );

    textPainter.paint(canvas, textOffset);
  }

  /// Paint scan lines effect for stable detection
  void _paintScanLines(Canvas canvas, Size size) {
    final scanPaint = Paint()
      ..color = Colors.green.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = _getQuadrilateralCenter();
    if (center == null) return;

    // Horizontal scan lines
    for (int i = -2; i <= 2; i++) {
      final y = center.dy + (i * 10);
      canvas.drawLine(
        Offset(center.dx - 40, y),
        Offset(center.dx + 40, y),
        scanPaint,
      );
    }

    // Vertical scan lines
    for (int i = -2; i <= 2; i++) {
      final x = center.dx + (i * 10);
      canvas.drawLine(
        Offset(x, center.dy - 40),
        Offset(x, center.dy + 40),
        scanPaint,
      );
    }
  }

  /// Paint checkmark icon
  void _paintCheckmark(Canvas canvas, Offset center) {
    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(center.dx - 8, center.dy);
    path.lineTo(center.dx - 2, center.dy + 6);
    path.lineTo(center.dx + 8, center.dy - 6);

    canvas.drawPath(path, checkPaint);
  }

  /// Draw quadrilateral shape
  void _drawQuadrilateral(Canvas canvas, Paint paint) {
    if (quadrilateral.corners.length != 4) return;

    final path = Path();
    final corners = quadrilateral.corners;

    path.moveTo(corners[0].x, corners[0].y);
    for (int i = 1; i < corners.length; i++) {
      path.lineTo(corners[i].x, corners[i].y);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  /// Get center point of quadrilateral
  Offset? _getQuadrilateralCenter() {
    if (quadrilateral.corners.length != 4) return null;

    double sumX = 0;
    double sumY = 0;

    for (final corner in quadrilateral.corners) {
      sumX += corner.x;
      sumY += corner.y;
    }

    return Offset(
      sumX / quadrilateral.corners.length,
      sumY / quadrilateral.corners.length,
    );
  }

  @override
  bool shouldRepaint(DocumentOverlayPainter oldDelegate) {
    return oldDelegate.quadrilateral != quadrilateral ||
      oldDelegate.isStable != isStable ||
      oldDelegate.stabilityScore != stabilityScore ||
      oldDelegate.showCornerHandles != showCornerHandles ||
      oldDelegate.pulseScale != pulseScale ||
      oldDelegate.stabilityOpacity != stabilityOpacity;
  }
}

/// Predefined corner positions for manual crop adjustment
class CornerPositions {
  static const List<Offset> defaultA4Portrait = [
    Offset(100, 150), // Top-left
    Offset(300, 140), // Top-right
    Offset(320, 500), // Bottom-right
    Offset(80, 510),  // Bottom-left
  ];

  static const List<Offset> defaultA4Landscape = [
    Offset(50, 100),  // Top-left
    Offset(550, 90),  // Top-right
    Offset(570, 350), // Bottom-right
    Offset(30, 360),  // Bottom-left
  ];

  static const List<Offset> defaultSquare = [
    Offset(100, 100), // Top-left
    Offset(400, 100), // Top-right
    Offset(400, 400), // Bottom-right
    Offset(100, 400), // Bottom-left
  ];
}

/// Document detection confidence thresholds
class DetectionThresholds {
  static const double minConfidence = 0.3;
  static const double goodConfidence = 0.7;
  static const double excellentConfidence = 0.9;

  static const double minStability = 0.5;
  static const double goodStability = 0.8;
  static const double excellentStability = 0.95;

  static const double minArea = 10000; // pixels
  static const double maxSkew = 30.0;  // degrees
}

/// Colors for different detection states
class DetectionColors {
  static const Color searching = Colors.orange;
  static const Color found = Colors.blue;
  static const Color good = Colors.green;
  static const Color excellent = Color(0xFF00C853);
  static const Color error = Colors.red;

  static Color getColorForConfidence(double confidence) {
    if (confidence < DetectionThresholds.minConfidence) return searching;
    if (confidence < DetectionThresholds.goodConfidence) return found;
    if (confidence < DetectionThresholds.excellentConfidence) return good;
    return excellent;
  }

  static Color getColorForStability(double stability) {
    if (stability < DetectionThresholds.minStability) return searching;
    if (stability < DetectionThresholds.goodStability) return found;
    if (stability < DetectionThresholds.excellentStability) return good;
    return excellent;
  }
}
