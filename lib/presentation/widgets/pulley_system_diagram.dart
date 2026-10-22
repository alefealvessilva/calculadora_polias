import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:calculadora_polias/core/theme/app_theme.dart';

class PulleySystemDiagram extends StatefulWidget {
  final double n1;
  final double d1;
  final double n2;
  final double d2;
  final bool animate;

  const PulleySystemDiagram({
    super.key,
    required this.n1,
    required this.d1,
    required this.n2,
    required this.d2,
    this.animate = false,
  });

  @override
  State<PulleySystemDiagram> createState() => _PulleySystemDiagramState();
}

class _PulleySystemDiagramState extends State<PulleySystemDiagram>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _currentAngle = 0.0;
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      final delta = (elapsed - _lastElapsed).inMilliseconds;
      _lastElapsed = elapsed;
      setState(() {
        _currentAngle += (delta / 2000.0) * 2 * pi;
      });
    });
    if (widget.animate && widget.n1 > 0) {
      _ticker.start();
    }
  }

  @override
  void didUpdateWidget(covariant PulleySystemDiagram oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && widget.n1 > 0) {
      if (!_ticker.isActive) {
        _lastElapsed = Duration.zero;
        _ticker.start();
      }
    } else {
      _ticker.stop();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 170),
      painter: _PulleyPainter(
        rotationAngle: _currentAngle,
        d1: widget.d1 > 0 ? widget.d1 : 50,
        d2: widget.d2 > 0 ? widget.d2 : 50,
        n1: widget.n1 > 0 ? widget.n1 : 1,
        n2: widget.n2 > 0 ? widget.n2 : 1,
      ),
    );
  }
}

class _PulleyPainter extends CustomPainter {
  final double rotationAngle;
  final double d1;
  final double d2;
  final double n1;
  final double n2;

  _PulleyPainter({
    required this.rotationAngle,
    required this.d1,
    required this.d2,
    required this.n1,
    required this.n2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double maxD = max(d1, d2);
    double maxVisualRadius = min(size.height * 0.35, size.width * 0.22);
    double minVisualRadius = maxVisualRadius * 0.3;

    double ratio1 = maxD > 0 ? d1 / maxD : 1;
    double ratio2 = maxD > 0 ? d2 / maxD : 1;

    double p1Radius = max(minVisualRadius, maxVisualRadius * ratio1);
    double p2Radius = max(minVisualRadius, maxVisualRadius * ratio2);

    Offset center1 = Offset(size.width * 0.25, size.height * 0.45);
    Offset center2 = Offset(size.width * 0.75, size.height * 0.45);

    final Paint beltPaint = Paint()
      ..color = AppTheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final Paint pulleyOutline = Paint()
      ..color = AppTheme.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint pulleyFillPaint = Paint()
      ..color = AppTheme.primarySoft
      ..style = PaintingStyle.fill;

    final Paint axisPaint = Paint()
      ..color = AppTheme.textPrimary
      ..style = PaintingStyle.fill;

    double dist = (center2 - center1).distance;
    double angleBelt = asin((p1Radius - p2Radius) / dist);
    double theta1 = pi / 2 + angleBelt;

    Offset top1 = center1 + Offset(p1Radius * cos(theta1), -p1Radius * sin(theta1));
    Offset top2 = center2 + Offset(p2Radius * cos(theta1), -p2Radius * sin(theta1));
    Offset bot1 = center1 + Offset(p1Radius * cos(-theta1), -p1Radius * sin(-theta1));
    Offset bot2 = center2 + Offset(p2Radius * cos(-theta1), -p2Radius * sin(-theta1));

    canvas.drawLine(top1, top2, beltPaint);
    canvas.drawLine(bot1, bot2, beltPaint);

    _drawPulley(canvas, center1, p1Radius, rotationAngle, pulleyFillPaint, pulleyOutline, axisPaint);

    double ratioRPM = n1 > 0 ? (n2 / n1) : 1.0;
    double rot2 = rotationAngle * ratioRPM;
    _drawPulley(canvas, center2, p2Radius, rot2, pulleyFillPaint, pulleyOutline, axisPaint);

    _drawLabel(canvas, "Motor", center1.dx, size.height - 25);
    _drawLabel(canvas, "Movida", center2.dx, size.height - 25);
  }

  void _drawPulley(Canvas canvas, Offset center, double radius, double rot, Paint fill, Paint outline, Paint axis) {
    canvas.drawCircle(center, radius, fill);
    canvas.drawCircle(center, radius, outline);
    canvas.drawCircle(center, 5, axis);

    for (int i = 0; i < 4; i++) {
      double angle = rot + (i * pi / 2);
      Offset edge = center + Offset(radius * cos(angle), radius * sin(angle));
      canvas.drawLine(center, edge, outline);
    }
  }

  void _drawLabel(Canvas canvas, String text, double x, double y) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y));
  }

  @override
  bool shouldRepaint(covariant _PulleyPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle || oldDelegate.d1 != d1 || oldDelegate.d2 != d2;
  }
}
