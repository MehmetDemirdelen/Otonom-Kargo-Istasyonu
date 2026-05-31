import 'package:flutter/material.dart';

import '../../app/constants.dart';
import '../../app/router.dart';

/// Kurye: dolap QR kodunu gerçek kamerayla okutur (uygulama içi QR üretimi yok).
class CourierScreen extends StatefulWidget {
  const CourierScreen({super.key});

  @override
  State<CourierScreen> createState() => _CourierScreenState();
}

class _CourierScreenState extends State<CourierScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AppRouter.openScan(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kurye Paneli'),
        leading: Semantics(
          label: 'Geri',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
      ),
      body: SafeArea(
        child: MediaQuery.withClampedTextScaling(
          minScaleFactor: 0.85,
          maxScaleFactor: 1.25,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 80,
                    color: scheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Text(
                    'Kargoyu dolaba yerleştirmek için dolap üzerindeki QR kodu okutun.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  Semantics(
                    label: 'QR Kod Okut',
                    button: true,
                    child: FilledButton.icon(
                      onPressed: () => AppRouter.openScan(context),
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                      label: const Text('QR Kod Okut'),
                    ),
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
