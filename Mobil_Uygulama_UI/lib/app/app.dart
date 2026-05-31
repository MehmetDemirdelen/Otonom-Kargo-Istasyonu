import 'package:flutter/material.dart';

import 'theme.dart';
import '../features/splash/splash_screen.dart';

class KargoApp extends StatelessWidget {
  const KargoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kargo Sistemi',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
