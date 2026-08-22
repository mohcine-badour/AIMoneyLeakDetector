import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';

/// 76×76 branded mark used on Welcome and About.
class AppBrandIcon extends StatelessWidget {
  const AppBrandIcon({this.size = 76, super.key});

  final double size;

  static const _sparkle = Color(0xFFAFA9EC);

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final radius = (size * 0.24).roundToDouble();
    final iconSize = size * 0.5;

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(width: 0.5, color: tokens.borderStrong),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: dark
                ? const [Color(0xFF1F1F1F), Color(0xFF141414)]
                : const [Color(0xFFFFFFFF), Color(0xFFF0EEE7)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x99000000),
              offset: Offset(0, size * 0.105),
              blurRadius: size * 0.42,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            children: [
              if (dark)
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: size / 2,
                    width: size,
                    child: const ColoredBox(color: Color(0x0FFFFFFF)),
                  ),
                ),
              Center(
                child: CustomPaint(
                  size: Size.square(iconSize),
                  painter: _ChartSparklePainter(
                    lineColor: tokens.textPrimary,
                    sparkleColor: _sparkle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartSparklePainter extends CustomPainter {
  const _ChartSparklePainter({
    required this.lineColor,
    required this.sparkleColor,
  });

  final Color lineColor;
  final Color sparkleColor;

  static const _ys = [0.0, 5.0, 3.0, 6.0];

  @override
  void paint(Canvas canvas, Size size) {
    final points = <Offset>[];
    for (var i = 0; i < _ys.length; i++) {
      final x = size.width * (0.08 + 0.84 * i / (_ys.length - 1));
      final y = size.height * (0.82 - (_ys[i] / 9) * 0.64);
      points.add(Offset(x, y));
    }

    final stroke = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      line.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(line, stroke);

    final fill = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    for (final point in points) {
      canvas.drawCircle(point, 1.4, fill);
    }

    final sparkleAt = Offset(size.width * 0.82, size.height * 0.18);
    _drawSparkle(canvas, sparkleAt, size.width * 0.14);
  }

  void _drawSparkle(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = sparkleColor
      ..style = PaintingStyle.fill;
    final inner = radius * 0.22;
    final path = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..lineTo(center.dx + inner, center.dy - inner)
      ..lineTo(center.dx + radius, center.dy)
      ..lineTo(center.dx + inner, center.dy + inner)
      ..lineTo(center.dx, center.dy + radius)
      ..lineTo(center.dx - inner, center.dy + inner)
      ..lineTo(center.dx - radius, center.dy)
      ..lineTo(center.dx - inner, center.dy - inner)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ChartSparklePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.sparkleColor != sparkleColor;
  }
}
