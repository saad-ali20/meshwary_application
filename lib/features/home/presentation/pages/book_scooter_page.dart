import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/scooter_model.dart';
import '../widgets/scooter_hero_view.dart';

/// Screen 3: تفاصيل الحجز (Reservation Details)
/// Step 3 in the user journey:
/// - Top bar: Back button, "حجز السكوتر"
/// - Hero: Scooter on illuminated green pedestal
/// - Duration selection: 10 دقائق | 30 دقيقة | 60 دقيقة
/// - Fee breakdown & auto-cancel policy info
/// - CTA Button: "تأكيد الحجز" -> Navigates to Step 4: الحجز النشط
class BookScooterPage extends StatefulWidget {
  const BookScooterPage({super.key, required this.scooter});
  final ScooterModel scooter;

  @override
  State<BookScooterPage> createState() => _BookScooterPageState();
}

class _BookScooterPageState extends State<BookScooterPage> {
  int _selectedDurationMinutes = 10;
  final double _bookingFee = 5.0; // 5 جنيه

  final List<int> _durations = [10, 30, 60];

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
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
                    'حجز السكوتر',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 44), // balancer
                ],
              ),
            ),

            // ── Body ─────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 6),

                    // ── Hero Scooter Visual ──────────────────────────────────
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          center: Alignment(0, 0.2),
                          radius: 0.9,
                          colors: [
                            Color(0xFF0E2A2E),
                            Color(0xFF071417),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(45),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ScooterHeroView(
                        height: (sh * 0.26).clamp(180.0, 230.0),
                        imagePath:
                            'assets/images/Neon Green Electric Scooter Icon-3.png',
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Section Title: مدة الحجز ─────────────────────────────
                    const Text(
                      'مدة الحجز',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Duration Selectors (10, 30, 60 دقائق) ────────────────
                    Row(
                      children: _durations.map((duration) {
                        final isSelected = _selectedDurationMinutes == duration;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedDurationMinutes = duration),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : const Color(0xFF0E2226),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : const Color(0xFF1B3840),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary.withAlpha(75),
                                            blurRadius: 12,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    '$duration دقائق',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: isSelected
                                          ? const Color(0xFF071214)
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // ── Pricing & Auto-Cancel Policy Card ────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0C1B1F),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF173038)),
                      ),
                      child: Column(
                        children: [
                          // Booking Fee Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_bookingFee.toStringAsFixed(0)} جنيه',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'رسوم الحجز',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.access_time_filled_rounded,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          const Divider(color: Color(0xFF1B3840), height: 1),
                          const SizedBox(height: 12),

                          // Policy info
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'تنتهي الحجز تلقائياً بعد $_selectedDurationMinutes دقائق من التأكيد',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    color: Color(0xFF4A7A84),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFF4A7A84),
                                size: 18,
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

            // ── Confirm Button ───────────────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + bottom),
              decoration: const BoxDecoration(
                color: Color(0xFF091417),
                border: Border(top: BorderSide(color: Color(0xFF162D33))),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.push(
                      AppRoutes.activeReservation,
                      extra: {
                        'scooter': s,
                        'durationMinutes': _selectedDurationMinutes,
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF57F56D), Color(0xFF38D952)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(75),
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'تأكيد الحجز',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF071214),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
