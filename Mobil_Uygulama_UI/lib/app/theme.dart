import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

ThemeData buildLightTheme() {
  var scheme = ColorScheme.fromSeed(
    seedColor: kAppSeedColor,
    brightness: Brightness.light,
  );
  scheme = scheme.copyWith(
    surface: const Color(0xFFF8FAFC),
    surfaceContainerLow: const Color(0xFFF1F5F9),
    surfaceContainer: const Color(0xFFE2E8F0),
    surfaceContainerHigh: const Color(0xFFCBD5E1),
    surfaceContainerHighest: Colors.white,
    onSurfaceVariant: const Color(0xFF64748B),
  );
  return _baseTheme(scheme, Brightness.light);
}

ThemeData buildDarkTheme() {
  var scheme = ColorScheme.fromSeed(
    seedColor: kAppSeedColor,
    brightness: Brightness.dark,
  );
  scheme = scheme.copyWith(
    surface: const Color(0xFF0F172A),
    surfaceContainerLow: const Color(0xFF1E293B),
    surfaceContainer: const Color(0xFF334155),
    surfaceContainerHigh: const Color(0xFF475569),
    surfaceContainerHighest: const Color(0xFF334155),
    onSurfaceVariant: const Color(0xFF94A3B8),
  );
  return _baseTheme(scheme, Brightness.dark);
}

ThemeData _baseTheme(ColorScheme scheme, Brightness brightness) {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    brightness: brightness,
    splashFactory: InkSparkle.splashFactory,
  );

  TextTheme textTheme;
  try {
    textTheme = GoogleFonts.notoSansTextTheme(base.textTheme);
  } catch (_) {
    textTheme = base.textTheme;
  }

  final appBarBg = brightness == Brightness.light ? Colors.white : scheme.surface;

  return base.copyWith(
    textTheme: textTheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      backgroundColor: appBarBg,
      foregroundColor: scheme.onSurface,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: brightness == Brightness.light ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
    ),
  );
}
