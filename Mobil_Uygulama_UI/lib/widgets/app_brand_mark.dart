import 'package:flutter/material.dart';

import '../app/constants.dart';

class AppBrandMark extends StatelessWidget {
  const AppBrandMark.compact({super.key, this.size}) : _maxWidth = null;

  const AppBrandMark.hero({super.key, required double maxWidth}) : _maxWidth = maxWidth, size = null;

  final double? size;

  final double? _maxWidth;

  static const _ring = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1),
      Color(0xFF3B82F6),
      Color(0xFF22D3EE),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    Widget image(double maxSide) {
      return Image.asset(
        AppAssets.brandLogo,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.inventory_2_rounded, size: maxSide * 0.55, color: scheme.primary);
        },
      );
    }

    final heroW = _maxWidth;
    if (heroW != null) {
      final r = heroW * 0.18;
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: heroW),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r),
            boxShadow: [
              BoxShadow(
                blurRadius: 40,
                spreadRadius: 2,
                color: const Color(0xFF3B82F6).withValues(alpha: 0.45),
              ),
              BoxShadow(
                blurRadius: 56,
                spreadRadius: -8,
                color: const Color(0xFF22D3EE).withValues(alpha: 0.35),
              ),
              BoxShadow(
                blurRadius: 24,
                offset: const Offset(0, 14),
                color: Colors.black.withValues(alpha: 0.45),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(r),
            child: SizedBox(
              width: heroW,
              child: AspectRatio(
                aspectRatio: 1,
                child: image(heroW),
              ),
            ),
          ),
        ),
      );
    }

    final s = size ?? 50;
    final outerR = s * 0.24;
    final stroke = 2.0;
    final innerR = outerR - stroke;

    return SizedBox(
      width: s + stroke * 2,
      height: s + stroke * 2,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(outerR),
          gradient: _ring,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 3),
              color: const Color(0xFF2563EB).withValues(alpha: isLight ? 0.18 : 0.35),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(stroke),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerR),
            child: ColoredBox(
              color: isLight ? Colors.white : const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image.asset(
                  AppAssets.brandLogo,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.inventory_2_rounded, size: s * 0.45, color: scheme.primary);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
