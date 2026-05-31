import 'package:flutter/material.dart';

class MotionDurations {
  const MotionDurations({
    required this.reduceMotion,
    required this.accessibleNavigation,
  });

  final bool reduceMotion;
  final bool accessibleNavigation;

  factory MotionDurations.fromContext(BuildContext context) {
    final mq = MediaQuery.of(context);
    return MotionDurations(
      reduceMotion: mq.disableAnimations,
      accessibleNavigation: mq.accessibleNavigation,
    );
  }

  Duration get micro =>
      reduceMotion ? const Duration(milliseconds: 30) : const Duration(milliseconds: 175);

  Duration get component =>
      reduceMotion ? const Duration(milliseconds: 50) : const Duration(milliseconds: 250);

  Duration get page =>
      reduceMotion ? const Duration(milliseconds: 80) : const Duration(milliseconds: 350);

  Duration get splashTotal {
    final base = reduceMotion ? 50 : 1200;
    final scaled = accessibleNavigation ? (base * 2).clamp(200, 4000) : base;
    return Duration(milliseconds: scaled);
  }

  Duration get courierLoading {
    final ms = reduceMotion ? 50 : 900;
    final scaled = accessibleNavigation ? (ms * 3 ~/ 2) : ms;
    return Duration(milliseconds: scaled.clamp(50, 2000));
  }

  Duration get verifyLoading {
    final ms = reduceMotion ? 50 : 800;
    final scaled = accessibleNavigation ? (ms * 3 ~/ 2) : ms;
    return Duration(milliseconds: scaled.clamp(50, 2000));
  }

  Duration get staggerDelay =>
      reduceMotion ? Duration.zero : const Duration(milliseconds: 150);

  bool get allowLoopAnimations => !reduceMotion;
}
