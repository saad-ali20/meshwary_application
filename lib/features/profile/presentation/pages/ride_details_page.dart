import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class RideDetailsPage extends StatefulWidget {
  const RideDetailsPage({super.key, this.rideData});

  final Map<String, dynamic>? rideData;

  @override
  State<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  int _rating = 5;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final ride = widget.rideData ?? {
      'id': 'SC-1024',
      'startTime': '7 أكتوبر 2026 - 04:20 م',
      'endTime': '7 أكتوبر 2026 - 04:32 م',
      'duration': '12 دقيقة',
      'distance': '3.4 كم',
      'cost': '31 جنيه',
      'status': 'مكتملة',
      'paymentMethod': 'بطاقة بنكية •••• 4521',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sh * 0.024,
                vertical: sh * 0.012,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: sh * 0.048,
                      height: sh * 0.048,
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.textPrimary,
                        size: sh * 0.028,
                      ),
                    ),
                  ),
                  Text(
                    'تفاصيل الرحلة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: sh * 0.024,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: sh * 0.048),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.024),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: sh * 0.015),

                    // ── Mini Route Map ───────────────────────────────────────
                    Container(
                      width: double.infinity,
                      height: sh * 0.170,
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Styled Mock Dark Map background
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                color: const Color(0xFF0F1B1E),
                                child: CustomPaint(
                                  painter: _RouteMapPainter(),
                                ),
                              ),
                            ),
                          ),
                          // Start Pin
                          Positioned(
                            top: 24,
                            right: 40,
                            child: _MapPinBadge(
                              label: 'بداية الرحلة',
                              color: AppColors.primary,
                              icon: Icons.play_arrow_rounded,
                            ),
                          ),
                          // End Pin
                          Positioned(
                            bottom: 24,
                            left: 40,
                            child: _MapPinBadge(
                              label: 'نهاية الرحلة',
                              color: AppColors.error,
                              icon: Icons.stop_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: sh * 0.018),

                    // ── Scooter Info Header Card ─────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: sh * 0.020,
                        vertical: sh * 0.014,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary.withAlpha(80),
                              ),
                            ),
                            child: Text(
                              ride['status'] as String,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            ride['id'] as String,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: sh * 0.014),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFF192D31),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.electric_scooter_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: sh * 0.016),

                    // ── Ride Stats Card ──────────────────────────────────────
                    Container(
                      padding: EdgeInsets.all(sh * 0.020),
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          _StatRow(
                            label: 'وقت البداية',
                            value: (ride['startTime'] ?? '7 أكتوبر 2026 - 04:20 م') as String,
                            icon: Icons.access_time_rounded,
                          ),
                          _StatRow(
                            label: 'وقت النهاية',
                            value: (ride['endTime'] ?? '7 أكتوبر 2026 - 04:32 م') as String,
                            icon: Icons.update_rounded,
                          ),
                          _StatRow(
                            label: 'مدة الرحلة',
                            value: (ride['duration'] ?? '12 دقيقة') as String,
                            icon: Icons.timer_outlined,
                          ),
                          _StatRow(
                            label: 'المسافة',
                            value: (ride['distance'] ?? '3.4 كم') as String,
                            icon: Icons.route_rounded,
                          ),
                          _StatRow(
                            label: 'السكوتر',
                            value: ride['id'] as String,
                            icon: Icons.electric_scooter_outlined,
                          ),
                          _StatRow(
                            label: 'التكلفة',
                            value: ride['cost'] as String,
                            icon: Icons.attach_money_rounded,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: sh * 0.016),

                    // ── Cost Breakdown Card ──────────────────────────────────
                    Container(
                      padding: EdgeInsets.all(sh * 0.020),
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'تفصيل التكلفة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: sh * 0.010),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ride['cost'] as String,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const Text(
                                'سعر الرحلة',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.border, height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ride['cost'] as String,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Text(
                                'المجموع',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: sh * 0.016),

                    // ── Payment Method & Status Card ─────────────────────────
                    Container(
                      padding: EdgeInsets.all(sh * 0.020),
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'طريقة الدفع',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: sh * 0.008),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'بطاقة بنكية •••• 4521',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF192D31),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'VISA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: sh * 0.020),

                    // ── Rating Section ───────────────────────────────────────
                    Container(
                      padding: EdgeInsets.all(sh * 0.020),
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'تقييم الرحلة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: sh * 0.012),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final starNum = index + 1;
                              final isSelected = starNum <= _rating;

                              return GestureDetector(
                                onTap: () => setState(() => _rating = starNum),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(
                                    Icons.star_rounded,
                                    color: isSelected
                                        ? const Color(0xFFFFD166)
                                        : const Color(0xFF1F3B3E),
                                    size: sh * 0.038,
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: sh * 0.018),

                          // Rating submit button
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'شكراً لتقييمك رحلتك في مشواري!',
                                    style: TextStyle(fontFamily: 'Cairo'),
                                  ),
                                  backgroundColor: AppColors.primary,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: sh * 0.058,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'تقييم الرحلة',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: sh * 0.030),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    this.isLast = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, size: 16, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapPinBadge extends StatelessWidget {
  const _MapPinBadge({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0D191C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(60),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Icon(icon, size: 14, color: color),
        ],
      ),
    );
  }
}

class _RouteMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF172B30)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    final path = Path()
      ..moveTo(size.width - 50, 40)
      ..lineTo(size.width - 90, 70)
      ..lineTo(size.width - 140, 60)
      ..lineTo(size.width - 180, 110)
      ..lineTo(60, 120);

    final routePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

