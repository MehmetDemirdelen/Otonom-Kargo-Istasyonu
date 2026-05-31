import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/constants.dart';
import '../app/motion.dart';

class AnimatedRoleCard extends StatefulWidget {
  const AnimatedRoleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.index,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final int index;

  @override
  State<AnimatedRoleCard> createState() => _AnimatedRoleCardState();
}

class _AnimatedRoleCardState extends State<AnimatedRoleCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _entryController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    final motion = MotionDurations(reduceMotion: false, accessibleNavigation: false);
    _entryController = AnimationController(
      vsync: this,
      duration: motion.component,
    );
    _fade = CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.06),
      end: Offset.zero,
    ).animate(_fade);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final m = MotionDurations.fromContext(context);
      if (m.reduceMotion) {
        _entryController.value = 1;
        return;
      }
      Future<void>.delayed(m.staggerDelay * widget.index, () {
        if (mounted) _entryController.forward();
      });
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final motion = MotionDurations.fromContext(context);
    final scale = _pressed ? 0.98 : 1.0;
    final isLight = theme.brightness == Brightness.light;

    final cardColor = isLight ? Colors.white : scheme.surfaceContainerHighest;
    final borderColor = scheme.outlineVariant.withValues(alpha: isLight ? 0.35 : 0.5);

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Semantics(
          button: true,
          label: widget.title,
          hint: 'Rol seçmek için çift dokunun',
          child: AnimatedScale(
            scale: scale,
            duration: motion.micro,
            curve: Curves.easeOut,
            child: Material(
              color: cardColor,
              elevation: _pressed ? 4 : (isLight ? 2 : 1),
              shadowColor: Colors.black.withValues(alpha: isLight ? 0.08 : 0.35),
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: borderColor),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  onHighlightChanged: _setPressed,
                  onTapDown: (_) {
                    _setPressed(true);
                    HapticFeedback.lightImpact();
                  },
                  onTapCancel: () => _setPressed(false),
                  onTap: () {
                    _setPressed(false);
                    widget.onTap();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s20,
                      vertical: AppSpacing.s24,
                    ),
                    child: Row(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: scheme.primary.withValues(alpha: isLight ? 0.12 : 0.22),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(widget.icon, size: 28, color: scheme.primary),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s16),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
