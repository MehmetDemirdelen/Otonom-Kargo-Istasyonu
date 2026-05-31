import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;
  static const double s48 = 48;
}

abstract final class AppRadius {
  static const double card = 20;
  static const double button = 16;
}

const Color kAppSeedColor = Color(0xFF2563EB);
const Color kSplashScreenBase = Color(0xFF1A2F4A);

abstract final class AppAssets {
  static const String brandLogo = 'assets/brand_logo.png';
}
