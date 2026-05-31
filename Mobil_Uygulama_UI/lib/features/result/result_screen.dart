import 'package:flutter/material.dart';

import '../../app/constants.dart';
import '../../app/motion.dart';
import '../../app/router.dart';
import '../../widgets/success_animation.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _textOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 1, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final m = MotionDurations.fromContext(context);
      _controller.duration = m.reduceMotion ? const Duration(milliseconds: 50) : const Duration(milliseconds: 400);
      _controller.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: MediaQuery.withClampedTextScaling(
          minScaleFactor: 0.85,
          maxScaleFactor: 1.25,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                SuccessAnimation(animation: _controller),
                const SizedBox(height: AppSpacing.s32),
                FadeTransition(
                  opacity: _textOpacity,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Kargo Teslim Edildi',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Semantics(
                  label: 'Ana Sayfaya Dön',
                  button: true,
                  child: Center(
                    child: FilledButton(
                      onPressed: () => AppRouter.goHome(context),
                      child: const Text('Ana Sayfaya Dön'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
