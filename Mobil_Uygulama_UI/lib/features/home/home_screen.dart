import 'package:flutter/material.dart';

import '../../app/constants.dart';
import '../../app/router.dart';
import '../../widgets/animated_role_card.dart';
import '../../widgets/app_brand_mark.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppBrandMark.compact(),
              const SizedBox(width: AppSpacing.s12),
              Text(
                'Kargo Sistemi',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isLight
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF8FAFC),
                    Color(0xFFEEF2FF),
                    Color(0xFFF1F5F9),
                  ],
                  stops: [0.0, 0.45, 1.0],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scheme.surface,
                    scheme.surfaceContainerLow,
                    scheme.surface,
                  ],
                ),
        ),
        child: SafeArea(
          child: MediaQuery.withClampedTextScaling(
            minScaleFactor: 0.85,
            maxScaleFactor: 1.25,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s16,
                    vertical: AppSpacing.s24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - AppSpacing.s48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Devam etmek için rolünüzü seçin',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s32),
                        AnimatedRoleCard(
                          index: 0,
                          title: 'Kurye Girişi',
                          icon: Icons.local_shipping_rounded,
                          onTap: () => AppRouter.openCourier(context),
                        ),
                        const SizedBox(height: AppSpacing.s16),
                        AnimatedRoleCard(
                          index: 1,
                          title: 'Müşteri Girişi',
                          icon: Icons.person_rounded,
                          onTap: () => AppRouter.openCustomer(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
