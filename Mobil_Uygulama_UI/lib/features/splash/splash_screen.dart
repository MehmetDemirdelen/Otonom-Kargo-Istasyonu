import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/constants.dart';
import '../../app/motion.dart';
import '../../app/router.dart';
import '../../widgets/app_brand_mark.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _breatheController;
  late AnimationController _auroraController;
  Timer? _dotsTimer;
  int _dotTick = 0;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 780),
    );

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _auroraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final motion = MotionDurations.fromContext(context);
      if (motion.reduceMotion) {
        _entranceController.value = 1;
      } else {
        _entranceController.forward();
        _breatheController.repeat(reverse: true);
        _auroraController.repeat();
      }

      final total = motion.splashTotal;
      _navTimer = Timer(total, _goHome);
      if (!motion.reduceMotion) {
        _dotsTimer = Timer.periodic(const Duration(milliseconds: 400), (_) {
          if (mounted) setState(() => _dotTick++);
        });
      }
    });
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      AppRouter.fadeSlide(context, const HomeScreen(), settings: const RouteSettings(name: '/home')),
    );
  }

  @override
  void dispose() {
    _dotsTimer?.cancel();
    _navTimer?.cancel();
    _entranceController.dispose();
    _breatheController.dispose();
    _auroraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = MotionDurations.fromContext(context);
    final dots = motion.reduceMotion ? '' : '.' * (1 + _dotTick % 3);

    return Scaffold(
      backgroundColor: kSplashScreenBase,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ListenableBuilder(
            listenable: _auroraController,
            builder: (context, _) {
              return _SplashBackdrop(phase: motion.reduceMotion ? 0.0 : _auroraController.value);
            },
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxLogo = math.min(268.0, constraints.maxWidth * 0.68);
                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: MediaQuery.withClampedTextScaling(
                    minScaleFactor: 0.85,
                    maxScaleFactor: 1.25,
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s24,
                            vertical: AppSpacing.s16,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _SplashBrandHero(
                                entrance: _entranceController,
                                breathe: _breatheController,
                                reduceMotion: motion.reduceMotion,
                                maxLogoWidth: maxLogo,
                              ),
                              const SizedBox(height: AppSpacing.s28),
                              FadeTransition(
                                opacity: CurvedAnimation(
                                  parent: _entranceController,
                                  curve: const Interval(0.25, 1, curve: Curves.easeOut),
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (bounds) {
                                      return const LinearGradient(
                                        colors: [
                                          Color(0xFFFFFFFF),
                                          Color(0xFFBAE6FD),
                                          Color(0xFFE0E7FF),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds);
                                    },
                                    child: Text(
                                      'Kargo Sistemi',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            letterSpacing: 0.4,
                                            shadows: const [
                                              Shadow(
                                                blurRadius: 20,
                                                color: Color(0x66000000),
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.s20),
                              FadeTransition(
                                opacity: CurvedAnimation(
                                  parent: _entranceController,
                                  curve: const Interval(0.4, 1, curve: Curves.easeOut),
                                ),
                                child: Center(
                                  child: _SplashLoadingBar(indeterminate: !motion.reduceMotion),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.s48),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Hazırlanıyor$dots',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: const Color(0xFFCBD5F5),
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashBackdrop extends StatelessWidget {
  const _SplashBackdrop({required this.phase});

  final double phase;

  @override
  Widget build(BuildContext context) {
    final t = phase * 2 * math.pi;

    final ax = 0.2 * math.sin(t * 0.65);
    final ay = -0.42 + 0.12 * math.cos(t * 0.45);
    final bx = -0.35 + 0.15 * math.cos(t * 0.55);
    final by = 0.55 + 0.1 * math.sin(t * 0.7);

    final pulse = 0.85 + 0.15 * (0.5 + 0.5 * math.sin(t * 1.1));

    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A2F4A),
                Color(0xFF1E3A5C),
                Color(0xFF234A6E),
                Color(0xFF183550),
              ],
              stops: [0.0, 0.35, 0.65, 1.0],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(ax, ay),
              radius: 0.95 * pulse,
              colors: [
                const Color(0xFF3B82F6).withValues(alpha: 0.38),
                const Color(0xFF6366F1).withValues(alpha: 0.15),
                Colors.transparent,
              ],
              stops: const [0.0, 0.42, 1.0],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(bx, by),
              radius: 0.75,
              colors: [
                const Color(0xFF22D3EE).withValues(alpha: 0.22),
                Colors.transparent,
              ],
              stops: const [0.0, 0.65],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.05,
              colors: [
                Colors.transparent,
                const Color(0xFF0F2840).withValues(alpha: 0.55),
              ],
              stops: const [0.45, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

class _SplashBrandHero extends StatelessWidget {
  const _SplashBrandHero({
    required this.entrance,
    required this.breathe,
    required this.reduceMotion,
    required this.maxLogoWidth,
  });

  final Animation<double> entrance;
  final Animation<double> breathe;
  final bool reduceMotion;
  final double maxLogoWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([entrance, breathe]),
      builder: (context, child) {
        final fade = Curves.easeOutCubic.transform(entrance.value);
        final pop = Curves.easeOutCubic.transform(entrance.value);
        final breathY = reduceMotion
            ? 0.0
            : 4.0 * math.sin(breathe.value * 2 * math.pi);
        final scale = reduceMotion ? 1.0 : (0.9 + 0.1 * pop);

        return Opacity(
          opacity: fade,
          child: Transform.translate(
            offset: Offset(0, breathY),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.center,
              child: child,
            ),
          ),
        );
      },
      child: Align(
        alignment: Alignment.center,
        child: Semantics(
          label: 'Kargo Sistemi logosu',
          image: true,
          child: AppBrandMark.hero(maxWidth: maxLogoWidth),
        ),
      ),
    );
  }
}

class _SplashLoadingBar extends StatelessWidget {
  const _SplashLoadingBar({required this.indeterminate});

  final bool indeterminate;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: 200,
        height: 5,
        child: indeterminate
            ? const LinearProgressIndicator(
                minHeight: 5,
                backgroundColor: Color(0x33FFFFFF),
                color: Color(0xFF67E8F9),
              )
            : const LinearProgressIndicator(
                value: 1,
                minHeight: 5,
                backgroundColor: Color(0x33FFFFFF),
                color: Color(0xFF67E8F9),
              ),
      ),
    );
  }
}
