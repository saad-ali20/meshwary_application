import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/scooter_model.dart';
import '../widgets/scooter_hero_view.dart';

/// Screen 4: الحجز النشط (Active Reservation)
/// Faithfully designed to match the user journey infographic:
/// - Top bar: Back button, "الحجز النشط"
/// - Scooter summary card with photo, code & battery pill (SC-1024 · 85%)
/// - Big countdown timer: "الوقت المتبقي للحجز" with 09:52 ticking digital clock & icon
/// - Action buttons:
///   1. "الاتجاه إلى السكوتر" (Directions to scooter)
///   2. "مسح QR لفتح السكوتر" (Scan QR to unlock) -> Step 5
///   3. "إلغاء الحجز" (Cancel reservation)
class ActiveReservationPage extends StatefulWidget {
  const ActiveReservationPage({
    super.key,
    required this.scooter,
    this.initialMinutes = 10,
  });

  final ScooterModel scooter;
  final int initialMinutes;

  @override
  State<ActiveReservationPage> createState() => _ActiveReservationPageState();
}

class _ActiveReservationPageState extends State<ActiveReservationPage>
    with SingleTickerProviderStateMixin {
  late int _remainingSeconds;
  Timer? _timer;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    // Default to 9m 52s if 10 minutes selected to match the exact mockup
    _remainingSeconds = (widget.initialMinutes == 10)
        ? (9 * 60 + 52)
        : (widget.initialMinutes * 60);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _confirmCancel() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1E22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'إلغاء الحجز',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        content: const Text(
          'هل أنت متأكد من إلغاء حجز هذا السكوتر؟ سيصبح متاحاً للمستخدمين الآخرين.',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: Color(0xFF9CB9B2),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'رجوع',
              style: TextStyle(fontFamily: 'Cairo', color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.home);
            },
            child: const Text(
              'تأكيد الإلغاء',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final s = widget.scooter;

    return Scaffold(
      backgroundColor: const Color(0xFF071214),
      body: SafeArea(
        bottom: false,
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
                    'الحجز النشط',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 44), // Balancer
                ],
              ),
            ),

            // ── Body ─────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // ── Scooter Summary Card ─────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E2226),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(50),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Thumbnail
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: const Color(0xFF081417),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.primary.withAlpha(40),
                              ),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: ScooterHeroView(
                              height: 60,
                              showGroundRings: false,
                              imagePath:
                                  'assets/images/Neon Green Electric Scooter Icon-3.png',
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  s.code,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      s.distanceLabel,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 12,
                                        color: Color(0xFF4A7A84),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withAlpha(20),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.primary.withAlpha(80),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.battery_charging_full_rounded,
                                            color: AppColors.primary,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${s.battery}%',
                                            style: const TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Big Countdown Timer Card ─────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF0F2B30),
                            Color(0xFF08161A),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(70),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(25),
                            blurRadius: 24,
                            spreadRadius: 1,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'الوقت المتبقي للحجز',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 15,
                              color: Color(0xFF9CB9B2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Clock row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Circular Clock Icon
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary.withAlpha(30),
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withAlpha(120),
                                      blurRadius: 14,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.access_time_filled_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Digital Timer
                              Text(
                                _formattedTime,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 44,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),

            // ── Action Buttons ───────────────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + bottom),
              decoration: const BoxDecoration(
                color: Color(0xFF091417),
                border: Border(top: BorderSide(color: Color(0xFF162D33))),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Button 1: الاتجاه إلى السكوتر
                  _ActionButton(
                    label: 'الاتجاه إلى السكوتر',
                    icon: Icons.navigation_rounded,
                    backgroundColor: const Color(0xFF0E2226),
                    textColor: Colors.white,
                    borderColor: const Color(0xFF1E3A40),
                    iconColor: Colors.white,
                    onTap: () {
                      context.push(AppRoutes.navigateScooter, extra: s);
                    },
                  ),

                  const SizedBox(height: 10),

                  // Button 2: مسح QR لفتح السكوتر (Primary Green)
                  _ActionButton(
                    label: 'مسح QR لفتح السكوتر',
                    icon: Icons.qr_code_scanner_rounded,
                    backgroundColor: AppColors.primary,
                    textColor: const Color(0xFF071214),
                    borderColor: AppColors.primary,
                    iconColor: const Color(0xFF071214),
                    hasGlow: true,
                    onTap: () {
                      context.push(AppRoutes.qrScan, extra: s);
                    },
                  ),

                  const SizedBox(height: 10),

                  // Button 3: إلغاء الحجز (Red Outlined)
                  _ActionButton(
                    label: 'إلغاء الحجز',
                    icon: Icons.close_rounded,
                    backgroundColor: const Color(0xFF1C1316),
                    textColor: const Color(0xFFFF6464),
                    borderColor: const Color(0xFFFF6464).withAlpha(120),
                    iconColor: const Color(0xFFFF6464),
                    onTap: _confirmCancel,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.iconColor,
    required this.onTap,
    this.hasGlow = false,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onTap;
  final bool hasGlow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: hasGlow
                ? [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(70),
                      blurRadius: 16,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ],
          ),
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
