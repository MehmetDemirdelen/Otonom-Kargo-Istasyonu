import 'dart:ui';

import 'package:flutter/material.dart';

import '../app/constants.dart';
import '../app/motion.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final motion = MotionDurations.fromContext(context);

    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: motion.reduceMotion ? 2 : 8,
          sigmaY: motion.reduceMotion ? 2 : 8,
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(AppSpacing.s24),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
