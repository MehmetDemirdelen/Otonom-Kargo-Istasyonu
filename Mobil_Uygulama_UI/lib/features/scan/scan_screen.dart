import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../app/constants.dart';
import '../../app/motion.dart';
import '../../app/router.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/scan_frame.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  bool _verifying = false;
  bool _handled = false;
  late final MobileScannerController _scannerController;
  late AnimationController _scanController;
  late Animation<double> _scanLine;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
    );
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _scanLine = CurvedAnimation(parent: _scanController, curve: Curves.linear);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final motion = MotionDurations.fromContext(context);
      if (motion.allowLoopAnimations) {
        _scanController.repeat();
      } else {
        _scanController.value = 0.5;
      }
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _onSuccess() async {
    final motion = MotionDurations.fromContext(context);
    setState(() => _verifying = true);
    try {
      await _scannerController.stop();
    } catch (_) {
      /* Önizleme başlamamış olabilir. */
    }
    await Future<void>.delayed(motion.verifyLoading);
    if (!mounted) return;
    setState(() => _verifying = false);
    await HapticFeedback.mediumImpact();
    if (!mounted) return;
    AppRouter.openResult(context);
  }

  void _onBarcode(BarcodeCapture capture) {
    if (_handled || _verifying) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final code = barcodes.first.displayValue ?? barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;
    _handled = true;
    _onSuccess();
  }

  Future<void> _toggleTorch() async {
    final state = _scannerController.value.torchState;
    if (state == TorchState.unavailable) return;
    await HapticFeedback.selectionClick();
    await _scannerController.toggleTorch();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final motion = MotionDurations.fromContext(context);
    final frameSize = MediaQuery.sizeOf(context).shortestSide * 0.72;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: MobileScanner(
              controller: _scannerController,
              onDetect: _onBarcode,
              errorBuilder: (context, error) {
                return ColoredBox(
                  color: const Color(0xFF0A0F14),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.s24),
                      child: Text(
                        'Kamera kullanılamıyor. İzinleri kontrol edip tekrar deneyin.\n'
                        '${error.errorDetails?.message ?? error.errorCode.name}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: MediaQuery.withClampedTextScaling(
              minScaleFactor: 0.85,
              maxScaleFactor: 1.25,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s8,
                          vertical: AppSpacing.s8,
                        ),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              child: const Text(
                                'İptal',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                            const Spacer(),
                            ListenableBuilder(
                              listenable: _scannerController,
                              builder: (context, _) {
                                final torch = _scannerController.value.torchState;
                                if (torch == TorchState.unavailable) {
                                  return const SizedBox.shrink();
                                }
                                return Semantics(
                                  label: 'Flaş',
                                  toggled: torch == TorchState.on || torch == TorchState.auto,
                                  child: IconButton(
                                    tooltip: 'Flaş',
                                    onPressed: _verifying ? null : _toggleTorch,
                                    icon: Icon(
                                      torch == TorchState.on || torch == TorchState.auto
                                          ? Icons.flash_on_rounded
                                          : Icons.flash_off_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                        child: Text(
                          'QR kodu çerçevenin içine hizalayın',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                shadows: const [
                                  Shadow(blurRadius: 8, color: Colors.black54),
                                ],
                              ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s24),
                      Expanded(
                        child: Center(
                          child: ScanFrame(
                            size: frameSize.clamp(200, 360),
                            scanLineAnimation: _scanLine,
                            showScanLine: motion.allowLoopAnimations,
                            cornerColor: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.s16),
                        child: Text(
                          'Okuma başarılı olunca işlem otomatik olarak devam eder.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white60,
                                shadows: const [
                                  Shadow(blurRadius: 6, color: Colors.black45),
                                ],
                              ),
                        ),
                      ),
                    ],
                  ),
                  if (_verifying)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Color(0x660A0F14),
                        child: LoadingOverlay(message: 'Doğrulanıyor…'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
