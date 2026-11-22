import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class InviteFriendsPage extends StatelessWidget {
  const InviteFriendsPage({super.key});

  static const String _referralCode = 'SAEED50';

  void _copyCode(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: _referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.textOnPrimary),
            SizedBox(width: 8),
            Text(
              'تم نسخ كود الإحالة بنجاح!',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                color: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _shareCode(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'استخدم كود الإحالة SAEED50 للحصول على رصيد مجاني في مشواري!',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
        ),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────────────────────────
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
                    'ادعُ أصحابك وخد رصيد مجاني',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: sh * 0.022,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: sh * 0.048),
                ],
              ),
            ),

            // ── Body ─────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.026),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: sh * 0.020),

                    // ── Illustration / Scooters & Gift Box ───────────────────
                    Container(
                      width: double.infinity,
                      height: sh * 0.180,
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(25),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background radial glow
                          Container(
                            width: sh * 0.16,
                            height: sh * 0.16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.primary.withAlpha(50),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Content Row: Scooter - Gift - Scooter
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.electric_scooter_rounded,
                                color: AppColors.primary,
                                size: sh * 0.075,
                              ),
                              Container(
                                width: sh * 0.090,
                                height: sh * 0.090,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(35),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.card_giftcard_rounded,
                                  color: AppColors.primary,
                                  size: sh * 0.052,
                                ),
                              ),
                              Transform.flip(
                                flipX: true,
                                child: Icon(
                                  Icons.electric_scooter_rounded,
                                  color: AppColors.primary,
                                  size: sh * 0.075,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: sh * 0.026),

                    // ── Headline ─────────────────────────────────────────────
                    Text(
                      'شارك الكود مع أصحابك\nعلى رصيد مجاني',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: sh * 0.024,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),

                    SizedBox(height: sh * 0.028),

                    // ── Referral Code Card ───────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: sh * 0.024,
                        vertical: sh * 0.024,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(80),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'كود الإحالة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.016,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: sh * 0.010),

                          // Large Code
                          Text(
                            _referralCode,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.038,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: 4.0,
                            ),
                          ),

                          SizedBox(height: sh * 0.020),

                          // Action Buttons
                          Row(
                            children: [
                              // Share Button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _shareCode(context),
                                  child: Container(
                                    height: sh * 0.060,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF192D31),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'مشاركة الكود',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: sh * 0.017,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: sh * 0.012),

                              // Copy Button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _copyCode(context),
                                  child: Container(
                                    height: sh * 0.060,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withAlpha(80),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'نسخ الكود',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: sh * 0.017,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textOnPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: sh * 0.025),

                    // ── Progress Card ────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: sh * 0.022,
                        vertical: sh * 0.020,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '3 / 5',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: sh * 0.016,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'تقدمك في الإحالة',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: sh * 0.017,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: sh * 0.008),
                          Text(
                            'دعوت 3 أصدقاء',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.015,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: sh * 0.014),

                          // Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: 0.60,
                              minHeight: 8,
                              backgroundColor: const Color(0xFF192D31),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: sh * 0.014),

                          // Earnings highlight
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'حصلت على 60 جنيه',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: sh * 0.017,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
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

