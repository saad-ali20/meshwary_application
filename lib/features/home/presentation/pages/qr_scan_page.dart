import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/scooter_model.dart';

/// Screen 5: مسح QR لفتح السكوتر
/// Step 5 in the user journey:
/// - Real camera viewfinder using mobile_scanner
/// - Animated neon green laser scanner line & corner frame
/// - Bottom controls: "إضاءة الكاميرا" & "إدخال رقم السكوتر"
/// - When scanned or code entered -> Navigates to Step 6: التحقق قبل الفتح
class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key, required this.scooter});
  final ScooterModel? scooter;

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _laserCtrl;
  bool _isProcessing = false;

  final MobileScannerController _scannerCtrl = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void initState() {
    super.initState();
    _laserCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _laserCtrl.dispose();
    _scannerCtrl.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null) return;
    _onScanSuccess(barcode.rawValue);
  }

  void _onScanSuccess([String? scannedCode]) {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    _scannerCtrl.stop();

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        context.pushReplacement(
          AppRoutes.unlockVerification,
          extra: widget.scooter,
        );
      }
    });
  }

  void _showManualEntrySheet() {
    final textCtrl = TextEditingController(
      text: widget.scooter?.code ?? 'SC-1024',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D1E22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'إدخال رقم السكوتر يدوياً',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'اكتب الرمز المطبوع أسفل رمز QR على السكوتر',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: Color(0xFF9CB9B2),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textCtrl,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 2,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF071417),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF1E3A40)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                hintText: 'SC-XXXX',
                hintStyle: const TextStyle(color: Color(0xFF3A5E66)),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _onScanSuccess(textCtrl.text.trim());
              },
              child: const Text(
                'تأكيد الرقم',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF071214),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.sizeOf(context).width;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final frameSize = (sw * 0.68).clamp(240.0, 310.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Real Camera View ───────────────────────────────────────────────
          MobileScanner(
            controller: _scannerCtrl,
            onDetect: _onDetect,
            errorBuilder: (context, error) => Container(
              color: const Color(0xFF081417),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.primary,
                      size: 56,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'تعذّر فتح الكاميرا\n${error.errorDetails?.message ?? ""}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Dark Vignette Overlay ──────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(200),
                  Colors.black.withAlpha(60),
                  Colors.black.withAlpha(200),
                ],
              ),
            ),
          ),

          // ── Center Viewfinder Frame & Animated Laser ───────────────────────
          Center(
            child: SizedBox(
              width: frameSize,
              height: frameSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Corner Reticle Painter
                  CustomPaint(
                    size: Size(frameSize, frameSize),
                    painter: _ScannerFramePainter(
                      color: _isProcessing ? Colors.white : AppColors.primary,
                    ),
                  ),

                  // Laser scan line
                  AnimatedBuilder(
                    animation: _laserCtrl,
                    builder: (_, _) {
                      final laserY =
                          (frameSize - 20) * _laserCtrl.value + 10;
                      return Positioned(
                        top: laserY,
                        left: 14,
                        right: 14,
                        child: Container(
                          height: 2.5,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.primary,
                                Colors.white,
                                AppColors.primary,
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(180),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  if (_isProcessing)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Top Bar ────────────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.paddingOf(context).top + 10,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _RoundIconButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: () => context.pop(),
                ),
                const Text(
                  'مسح QR لفتح السكوتر',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
          ),

          // ── Instruction Subtitle ───────────────────────────────────────────
          Positioned(
            bottom: bottom + 120,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text(
                  _isProcessing
                      ? 'تم التعرف على رمز QR بنجاح ...'
                      : 'قم بمسح رمز QR الموجود على السكوتر',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color:
                        _isProcessing ? AppColors.primary : Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom Tool Buttons ────────────────────────────────────────────
          Positioned(
            bottom: bottom + 24,
            left: 24,
            right: 24,
            child: Row(
              children: [
                // Button 1: إضاءة الكاميرا
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: _scannerCtrl,
                    builder: (_, state, _) {
                      final flashOn =
                          state.torchState == TorchState.on;
                      return _ScannerToolButton(
                        icon: flashOn
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        label: 'إضاءة الكاميرا',
                        isActive: flashOn,
                        onTap: () => _scannerCtrl.toggleTorch(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Button 2: إدخال رقم السكوتر
                Expanded(
                  child: _ScannerToolButton(
                    icon: Icons.keyboard_rounded,
                    label: 'إدخال رقم السكوتر',
                    isActive: false,
                    onTap: _showManualEntrySheet,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerToolButton extends StatelessWidget {
  const _ScannerToolButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1E22).withAlpha(220),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? AppColors.primary : const Color(0xFF1E3A40),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.primary : Colors.white,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isActive ? AppColors.primary : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScannerFramePainter extends CustomPainter {
  const _ScannerFramePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const corner = 32.0;

    // Top Left
    canvas.drawLine(const Offset(0, 0), const Offset(corner, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, corner), paint);

    // Top Right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - corner, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, corner), paint);

    // Bottom Left
    canvas.drawLine(Offset(0, size.height), Offset(corner, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - corner), paint);

    // Bottom Right
    canvas.drawLine(
        Offset(size.width, size.height),
        Offset(size.width - corner, size.height),
        paint);
    canvas.drawLine(
        Offset(size.width, size.height),
        Offset(size.width, size.height - corner),
        paint);
  }

  @override
  bool shouldRepaint(covariant _ScannerFramePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF0E2226).withAlpha(220),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E3A40)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
