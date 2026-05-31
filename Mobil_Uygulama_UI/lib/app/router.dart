import 'package:flutter/material.dart';

import '../features/courier/courier_screen.dart';
import '../features/customer/customer_screen.dart';
import '../features/home/home_screen.dart';
import '../features/result/result_screen.dart';
import '../features/scan/scan_screen.dart';
import 'motion.dart';

class AppRouter {
  AppRouter._();

  static Route<T> fadeSlide<T extends Object?>(
    BuildContext context,
    Widget page, {
    RouteSettings? settings,
  }) {
    final motion = MotionDurations.fromContext(context);
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: motion.page,
      reverseTransitionDuration: motion.page,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
        final m = MotionDurations.fromContext(ctx);
        if (m.reduceMotion || m.page.inMilliseconds <= 80) {
          return child;
        }
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  static void goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      fadeSlide(context, const HomeScreen(), settings: const RouteSettings(name: '/home')),
      (_) => false,
    );
  }

  static void openCourier(BuildContext context) {
    Navigator.of(context).push(
      fadeSlide(context, const CourierScreen(), settings: const RouteSettings(name: '/courier')),
    );
  }

  static void openCustomer(BuildContext context) {
    Navigator.of(context).push(
      fadeSlide(context, const CustomerScreen(), settings: const RouteSettings(name: '/customer')),
    );
  }

  static void openScan(BuildContext context) {
    Navigator.of(context).push(
      fadeSlide(context, const ScanScreen(), settings: const RouteSettings(name: '/scan')),
    );
  }

  static void openResult(BuildContext context) {
    Navigator.of(context).push(
      fadeSlide(context, const ResultScreen(), settings: const RouteSettings(name: '/result')),
    );
  }
}
