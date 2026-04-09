import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:bharattesting_core/core.dart' as core;
import '../models/document_scanner_state.dart';

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

  final core.DocumentQuadrilateral quadrilateral;
  final bool isStable;
  final double stabilityScore;
  final bool showCornerHandles;
  final Function(int cornerIndex, Offset newPosition)? onCornerMoved;
  final Duration animationDuration;

  @override
  State<DocumentOverlayWidget> createState() => _DocumentOverlayWidgetState();
}

class _DocumentOverlayWidgetState extends State<DocumentOverlayWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DocumentOverlayPainter(
        quadrilateral: widget.quadrilateral,
        isStable: widget.isStable,
        color: widget.isStable ? Colors.green : Colors.blue,
      ),
      child: Container(),
    );
  }
}

class DocumentOverlayPainter extends CustomPainter {
  final core.DocumentQuadrilateral quadrilateral;
  final bool isStable;
  final Color color;

  DocumentOverlayPainter({
    required this.quadrilateral,
    required this.isStable,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path()
      ..moveTo(quadrilateral.topLeft.x, quadrilateral.topLeft.y)
      ..lineTo(quadrilateral.topRight.x, quadrilateral.topRight.y)
      ..lineTo(quadrilateral.bottomRight.x, quadrilateral.bottomRight.y)
      ..lineTo(quadrilateral.bottomLeft.x, quadrilateral.bottomLeft.y)
      ..close();

    canvas.drawPath(path, paint);
    
    final fillPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(DocumentOverlayPainter oldDelegate) => true;
}
