import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../core/theme/app_theme.dart';

class AnimatedPulleyDiagram extends StatefulWidget {
  final double drivingDiameter;
  final double drivenDiameter;
  final double distance;
  final bool animate;

  const AnimatedPulleyDiagram({
    super.key,
    required this.drivingDiameter,
    required this.drivenDiameter,
    required this.distance,
    this.animate = false,
  });

  @override
  State<AnimatedPulleyDiagram> createState() => _AnimatedPulleyDiagramState();
}

class _AnimatedPulleyDiagramState extends State<AnimatedPulleyDiagram>
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
    if (widget.animate && widget.drivingDiameter > 0) {
      _ticker.start();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedPulleyDiagram oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && widget.drivingDiameter > 0) {
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
      size: const Size(double.infinity, 180),
      painter: PulleyDiagramPainter(
        drivingDiameter: widget.drivingDiameter,
        drivenDiameter: widget.drivenDiameter,
        distance: widget.distance,
        rotationAngle: _currentAngle,
      ),
    );
  }
}

class PulleyDiagramPainter extends CustomPainter {
  final double drivingDiameter;
  final double drivenDiameter;
  final double distance;
  final double rotationAngle;

  PulleyDiagramPainter({
    required this.drivingDiameter,
    required this.drivenDiameter,
    required this.distance,
    this.rotationAngle = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (drivingDiameter == 0 || drivenDiameter == 0 || distance == 0) return;

    final paintPulleyFile = Paint()
      ..color = AppTheme.primarySoft
      ..style = PaintingStyle.fill;

    final paintBorder = Paint()
      ..color = AppTheme.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final paintBelt = Paint()
      ..color = AppTheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final paintCenter = Paint()
      ..color = AppTheme.textPrimary
      ..style = PaintingStyle.fill;

    double maxDiameter = max(drivingDiameter, drivenDiameter);
    double totalWidthNeeded = drivingDiameter / 2 + distance + drivenDiameter / 2;
    double scale = (size.width * 0.8) / totalWidthNeeded;
    
    if (scale > (size.height * 0.45) / maxDiameter) {
       scale = (size.height * 0.45) / maxDiameter;
    }

    double r1 = (drivingDiameter / 2) * scale;
    double r2 = (drivenDiameter / 2) * scale;
    double d = distance * scale;

    Offset c1 = Offset(size.width / 2 - d / 2, size.height / 2);
    Offset c2 = Offset(size.width / 2 + d / 2, size.height / 2);

    double ratio = (r1 - r2) / d;
    bool canDrawBelt = ratio.abs() <= 1.0;

    if (canDrawBelt) {
      double phi = asin(ratio);

      // Tangentes
      Offset p1Top = Offset(c1.dx - r1 * sin(phi), c1.dy - r1 * cos(phi));
      Offset p2Top = Offset(c2.dx - r2 * sin(phi), c2.dy - r2 * cos(phi));
      Offset p1Bottom = Offset(c1.dx + r1 * sin(phi), c1.dy + r1 * cos(phi));
      Offset p2Bottom = Offset(c2.dx + r2 * sin(phi), c2.dy + r2 * cos(phi));

      // Arcos da correia
      Rect rect1 = Rect.fromCircle(center: c1, radius: r1);
      Rect rect2 = Rect.fromCircle(center: c2, radius: r2);
      
      double startAngle1 = pi / 2 + phi;
      double sweepAngle1 = pi + 2 * (pi / 2 - phi);
      double startAngle2 = -pi / 2 + phi;
      double sweepAngle2 = pi - 2 * (pi / 2 - phi);

      if (r1 < r2) {
        sweepAngle1 = pi - 2 * (pi / 2 + phi);
        sweepAngle2 = pi + 2 * (pi / 2 + phi);
      }

      canvas.drawLine(p1Top, p2Top, paintBelt);
      canvas.drawLine(p1Bottom, p2Bottom, paintBelt);
      canvas.drawArc(rect1, startAngle1, sweepAngle1, false, paintBelt);
      canvas.drawArc(rect2, startAngle2, sweepAngle2, false, paintBelt);
    }

    // Polias
    _drawSpokePulley(canvas, c1, r1, rotationAngle, paintPulleyFile, paintBorder, paintCenter);
    
    double ratioRPM = drivingDiameter > 0 ? (drivingDiameter / drivenDiameter) : 1.0;
    double rot2 = rotationAngle * ratioRPM;
    _drawSpokePulley(canvas, c2, r2, rot2, paintPulleyFile, paintBorder, paintCenter);
  }

  void _drawSpokePulley(Canvas canvas, Offset center, double radius, double rot, Paint fill, Paint outline, Paint axis) {
    canvas.drawCircle(center, radius, fill);
    canvas.drawCircle(center, radius, outline);
    canvas.drawCircle(center, 4, axis);

    for (int i = 0; i < 4; i++) {
      double angle = rot + (i * pi / 2);
      Offset edge = center + Offset(radius * cos(angle), radius * sin(angle));
      canvas.drawLine(center, edge, outline);
    }
  }

  @override
  bool shouldRepaint(covariant PulleyDiagramPainter oldDelegate) {
    return oldDelegate.drivingDiameter != drivingDiameter ||
           oldDelegate.drivenDiameter != drivenDiameter ||
           oldDelegate.distance != distance ||
           oldDelegate.rotationAngle != rotationAngle;
  }
}
