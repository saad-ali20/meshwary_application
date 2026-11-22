import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/scooter_model.dart';
import '../widgets/scooter_hero_view.dart';

/// Screen 8: تم فتح السكوتر
/// Step 8 in the user journey:
/// - Top bar: Back button, "تم فتح السكوتر"
/// - Big glowing green checkmark circle
/// - Real scooter visual on glowing circular base (side angle)
/// - "تم فتح السكوتر بنجاح"
/// - "تبدأ الرحلة تلقائياً"
/// - Automatically transitions into Step 9: الرحلة النشطة
class RideStartedPage extends StatefulWidget {
  const RideStartedPage({super.key, required this.scooter});
  final ScooterModel? scooter;

  @override
  State<RideStartedPage> createState() => _RideStartedPageState();
}

class _RideStartedPageState extends State<RideStartedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;
  Timer? _autoTransitionTimer;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Infographic note: "عند فتح السكوتر بنجاح تبدأ الرحلة تلقائياً دون ضغط أي زر إضافي"
    _autoTransitionTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        context.pushReplacement(
          AppRoutes.rideActive,
          extra: widget.scooter,
        );
      }
    });
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _autoTransitionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

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
                    onTap: () => context.go(AppRoutes.home),
                  ),
                  const Text(
                    'تم فتح السكوتر',
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

            const SizedBox(height: 20),

            // ── Big Glowing Green Checkmark Circle ───────────────────────────
            AnimatedBuilder(
              animation: _glowCtrl,
              builder: (_, _) {
                final pulse = _glowCtrl.value;
                return Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withAlpha((40 + 30 * pulse).toInt()),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha((110 + 60 * pulse).toInt()),
                        blurRadius: 24 + 12 * pulse,
                        spreadRadius: 3 + 2 * pulse,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.primary,
                    size: 52,
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ── Scooter Side Visual on Glowing Pedestal ──────────────────────
            Expanded(
              child: Center(
                child: ScooterHeroView(
                  height: (sh * 0.32).clamp(210.0, 270.0),
                  imagePath:
                      'assets/images/Neon Green Electric Scooter Icon-3.png',
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Success Messages ─────────────────────────────────────────────
            const Text(
              'تم فتح السكوتر بنجاح',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'تبدأ الرحلة تلقائياً',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
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
