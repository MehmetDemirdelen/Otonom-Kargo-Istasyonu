import 'package:flutter/material.dart';

import '../app/constants.dart';

class ScanFrame extends StatelessWidget {
  const ScanFrame({
    super.key,
    required this.size,
    required this.scanLineAnimation,
    required this.showScanLine,
    this.cornerColor,
  });

  final double size;
  final Animation<double> scanLineAnimation;
  final bool showScanLine;
  final Color? cornerColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = cornerColor ?? scheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _CornerPainter(color: accent),
          ),
          if (showScanLine)
            AnimatedBuilder(
              animation: scanLineAnimation,
              builder: (context, child) {
                final y = scanLineAnimation.value * (size - 4);
                return Positioned(
                  left: 8,
                  right: 8,
                  top: y,
                  child: child!,
                );
              },
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0),
                      accent,
                      accent.withValues(alpha: 0),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      spreadRadius: 1,
                      color: accent.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  _CornerPainter({required this.color});

  final Color color;
  static const _len = 28.0;
  static const _stroke = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = _stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void corner(Offset o, bool top, bool left) {
      final dx = left ? _len : -_len;
      final dy = top ? _len : -_len;
      if (top && left) {
        canvas.drawLine(o, o + Offset(dx, 0), paint);
        canvas.drawLine(o, o + Offset(0, dy), paint);
      } else if (top && !left) {
        canvas.drawLine(o, o + Offset(dx, 0), paint);
        canvas.drawLine(o, o + Offset(0, dy), paint);
      } else if (!top && left) {
        canvas.drawLine(o, o + Offset(dx, 0), paint);
        canvas.drawLine(o, o + Offset(0, dy), paint);
      } else {
        canvas.drawLine(o, o + Offset(dx, 0), paint);
        canvas.drawLine(o, o + Offset(0, dy), paint);
      }
    }

    corner(Offset.zero, true, true);
    corner(Offset(size.width, 0), true, false);
    corner(Offset(0, size.height), false, true);
    corner(Offset(size.width, size.height), false, false);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(_stroke / 2, _stroke / 2, size.width - _stroke, size.height - _stroke),
      const Radius.circular(AppRadius.button),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) => oldDelegate.color != color;
}
