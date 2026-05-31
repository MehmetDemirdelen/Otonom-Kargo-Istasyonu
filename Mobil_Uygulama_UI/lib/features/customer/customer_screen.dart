import 'package:flutter/material.dart';

import '../../app/constants.dart';
import '../../app/router.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kargo Teslim Alma'),
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
                    'Dolaptan kargonuzu almak için QR kodu okutun.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  Semantics(
                    label: 'QR Kod Okut',
                    hint: 'Kamera ile QR kod tarama ekranını açar',
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
