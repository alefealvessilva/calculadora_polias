import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Rotação contínua das polias. Anima só o CustomPaint (sem reconstruir widgets).
class _Spinner extends StatefulWidget {
  final bool animate;
  final CustomPainter Function(Animation<double> spin) painterBuilder;
  final double height;

  const _Spinner({
    required this.animate,
    required this.painterBuilder,
    required this.height,
  });

  @override
  State<_Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<_Spinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant _Spinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.animate && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(double.infinity, widget.height),
        painter: widget.painterBuilder(_controller),
      ),
    );
  }
}

final Paint _strokeBelt = Paint()
  ..color = AppTheme.accent
  ..style = PaintingStyle.stroke
  ..strokeWidth = 2;

final Paint _strokePulley = Paint()
  ..color = AppTheme.textMuted
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1.5;

final Paint _fillPulley = Paint()
  ..color = AppTheme.surface
  ..style = PaintingStyle.fill;

final Paint _fillHub = Paint()
  ..color = AppTheme.accent
  ..style = PaintingStyle.fill;

void _drawPulley(Canvas canvas, Offset c, double r, double rot) {
  canvas.drawCircle(c, r, _fillPulley);
  canvas.drawCircle(c, r, _strokePulley);
  for (int i = 0; i < 4; i++) {
    final a = rot + i * pi / 2;
    canvas.drawLine(c, c + Offset(r * cos(a), r * sin(a)), _strokePulley);
  }
  canvas.drawCircle(c, 4, _fillHub);
}

void _drawLabel(Canvas canvas, String text, double x, double y) {
  final tp = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  tp.paint(canvas, Offset(x - tp.width / 2, y));
}

// ---------------------------------------------------------------------------
// Diagrama da correia (distância entre centros, com arcos de contato)
// ---------------------------------------------------------------------------

class AnimatedPulleyDiagram extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return _Spinner(
      animate: animate && drivingDiameter > 0,
      height: 160,
      painterBuilder: (spin) => PulleyDiagramPainter(
        drivingDiameter: drivingDiameter,
        drivenDiameter: drivenDiameter,
        distance: distance,
        spin: spin,
      ),
    );
  }
}

class PulleyDiagramPainter extends CustomPainter {
  final double drivingDiameter;
  final double drivenDiameter;
  final double distance;
  final Animation<double> spin;

  PulleyDiagramPainter({
    required this.drivingDiameter,
    required this.drivenDiameter,
    required this.distance,
    required this.spin,
  }) : super(repaint: spin);

  @override
  void paint(Canvas canvas, Size size) {
    if (drivingDiameter <= 0 || drivenDiameter <= 0 || distance <= 0) return;

    final rotationAngle = spin.value * 2 * pi;
    final maxDiameter = max(drivingDiameter, drivenDiameter);
    final totalWidthNeeded =
        drivingDiameter / 2 + distance + drivenDiameter / 2;
    var scale = (size.width * 0.8) / totalWidthNeeded;
    if (scale > (size.height * 0.45) / maxDiameter) {
      scale = (size.height * 0.45) / maxDiameter;
    }

    final r1 = (drivingDiameter / 2) * scale;
    final r2 = (drivenDiameter / 2) * scale;
    final d = distance * scale;

    final c1 = Offset(size.width / 2 - d / 2, size.height / 2);
    final c2 = Offset(size.width / 2 + d / 2, size.height / 2);

    final ratio = (r1 - r2) / d;
    if (ratio.abs() <= 1.0) {
      final phi = asin(ratio);
      final p1Top = Offset(c1.dx - r1 * sin(phi), c1.dy - r1 * cos(phi));
      final p2Top = Offset(c2.dx - r2 * sin(phi), c2.dy - r2 * cos(phi));
      final p1Bottom = Offset(c1.dx + r1 * sin(phi), c1.dy + r1 * cos(phi));
      final p2Bottom = Offset(c2.dx + r2 * sin(phi), c2.dy + r2 * cos(phi));

      final rect1 = Rect.fromCircle(center: c1, radius: r1);
      final rect2 = Rect.fromCircle(center: c2, radius: r2);

      final startAngle1 = pi / 2 + phi;
      var sweepAngle1 = pi + 2 * (pi / 2 - phi);
      final startAngle2 = -pi / 2 + phi;
      var sweepAngle2 = pi - 2 * (pi / 2 - phi);
      if (r1 < r2) {
        sweepAngle1 = pi - 2 * (pi / 2 + phi);
        sweepAngle2 = pi + 2 * (pi / 2 + phi);
      }

      canvas.drawLine(p1Top, p2Top, _strokeBelt);
      canvas.drawLine(p1Bottom, p2Bottom, _strokeBelt);
      canvas.drawArc(rect1, startAngle1, sweepAngle1, false, _strokeBelt);
      canvas.drawArc(rect2, startAngle2, sweepAngle2, false, _strokeBelt);
    }

    _drawPulley(canvas, c1, r1, rotationAngle);
    _drawPulley(canvas, c2, r2, rotationAngle * (drivingDiameter / drivenDiameter));
  }

  @override
  bool shouldRepaint(covariant PulleyDiagramPainter old) =>
      old.drivingDiameter != drivingDiameter ||
      old.drivenDiameter != drivenDiameter ||
      old.distance != distance;
}

// ---------------------------------------------------------------------------
// Diagrama da transmissão (motor / movida)
// ---------------------------------------------------------------------------

class PulleySystemDiagram extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return _Spinner(
      animate: animate && n1 > 0,
      height: 180,
      painterBuilder: (spin) => _SystemPainter(
        spin: spin,
        d1: d1 > 0 ? d1 : 50,
        d2: d2 > 0 ? d2 : 50,
        n1: n1 > 0 ? n1 : 1,
        n2: n2 > 0 ? n2 : 1,
      ),
    );
  }
}

class _SystemPainter extends CustomPainter {
  final Animation<double> spin;
  final double d1, d2, n1, n2;

  _SystemPainter({
    required this.spin,
    required this.d1,
    required this.d2,
    required this.n1,
    required this.n2,
  }) : super(repaint: spin);

  @override
  void paint(Canvas canvas, Size size) {
    final rotationAngle = spin.value * 2 * pi;
    final maxD = max(d1, d2);
    final maxR = min(size.height * 0.35, size.width * 0.22);
    final minR = maxR * 0.3;
    final p1 = max(minR, maxR * (d1 / maxD));
    final p2 = max(minR, maxR * (d2 / maxD));

    final c1 = Offset(size.width * 0.25, size.height * 0.42);
    final c2 = Offset(size.width * 0.75, size.height * 0.42);

    final dist = (c2 - c1).distance;
    final a = asin((p1 - p2) / dist);
    final t = pi / 2 + a;

    Offset pt(Offset c, double r, double th) =>
        c + Offset(r * cos(th), -r * sin(th));
    canvas.drawLine(pt(c1, p1, t), pt(c2, p2, t), _strokeBelt);
    canvas.drawLine(pt(c1, p1, -t), pt(c2, p2, -t), _strokeBelt);

    _drawPulley(canvas, c1, p1, rotationAngle);
    _drawPulley(canvas, c2, p2, rotationAngle * (n2 / n1));

    _drawLabel(canvas, 'Motor', c1.dx, size.height - 22);
    _drawLabel(canvas, 'Movida', c2.dx, size.height - 22);
  }

  @override
  bool shouldRepaint(covariant _SystemPainter old) =>
      old.d1 != d1 || old.d2 != d2 || old.n1 != n1 || old.n2 != n2;
}
