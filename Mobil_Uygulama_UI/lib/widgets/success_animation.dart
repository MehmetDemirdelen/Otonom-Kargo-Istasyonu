import 'package:flutter/material.dart';

import '../app/motion.dart';

class SuccessAnimation extends StatelessWidget {
  const SuccessAnimation({
    super.key,
    required this.animation,
  });

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final motion = MotionDurations.fromContext(context);
    final curved = CurvedAnimation(
      parent: animation,
      curve: motion.reduceMotion ? Curves.linear : Curves.elasticOut,
    );

    return Center(
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.2, end: 1.0).animate(curved),
        child: FadeTransition(
          opacity: animation,
          child: CustomPaint(
            painter: _CheckPainter(),
            size: const Size(120, 120),
          ),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 4;

    final circlePaint = Paint()..color = const Color(0xFF2E7D32);
    canvas.drawCircle(center, radius, circlePaint);

    final checkPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = radius * 0.14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final p1 = Offset(center.dx - radius * 0.38, center.dy + radius * 0.02);
    final p2 = Offset(center.dx - radius * 0.08, center.dy + radius * 0.32);
    final p3 = Offset(center.dx + radius * 0.42, center.dy - radius * 0.28);
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy);
    canvas.drawPath(path, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
