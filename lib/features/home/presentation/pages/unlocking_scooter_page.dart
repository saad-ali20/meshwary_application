import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/scooter_model.dart';

/// Screen 7: جاري فتح السكوتر
/// Step 7 in the user journey:
/// - Top bar: Back button, "جاري فتح السكوتر"
/// - Animated circular dial with segmented neon green glow & center lock
/// - Live progress text: "جاري إرسال أمر الفتح إلى السكوتر ..."
/// - Automatically proceeds to Step 8: تم فتح السكوتر
class UnlockingScooterPage extends StatefulWidget {
  const UnlockingScooterPage({super.key, required this.scooter});
  final ScooterModel? scooter;

  @override
  State<UnlockingScooterPage> createState() => _UnlockingScooterPageState();
}

class _UnlockingScooterPageState extends State<UnlockingScooterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinCtrl;
  Timer? _completeTimer;

  @override
  void initState() {
    super.initState();
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _completeTimer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted) {
        context.pushReplacement(
          AppRoutes.rideStarted,
          extra: widget.scooter,
        );
      }
    });
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    _completeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071214),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _RoundIconButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: () => context.pop(),
                  ),
                  const Text(
                    'جاري فتح السكوتر',
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

            const Spacer(),

            // ── Animated Unlocking Circular Dial ─────────────────────────────
            AnimatedBuilder(
              animation: _spinCtrl,
              builder: (_, _) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(50),
                            blurRadius: 40,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),

                    // Rotating segmented ring painter
                    Transform.rotate(
                      angle: _spinCtrl.value * 2 * math.pi,
                      child: CustomPaint(
                        size: const Size(200, 200),
                        painter: _SegmentedDialPainter(),
                      ),
                    ),

                    // Center Lock Container
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0D2226),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: AppColors.primary,
                        size: 42,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 48),

            // ── Status Title & Subtitle ──────────────────────────────────────
            const Text(
              'جاري فتح السكوتر',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'جاري إرسال أمر الفتح إلى السكوتر ...',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Color(0xFF4A7A84),
              ),
            ),

            const Spacer(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SegmentedDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final basePaint = Paint()
      ..color = const Color(0xFF142C32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;

    canvas.drawCircle(center, radius, basePaint);

    final sweepPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          AppColors.primary.withAlpha(90),
          AppColors.primary,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      1.5 * math.pi,
      false,
      sweepPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
          color: const Color(0xFF0E2226),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E3A40)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
