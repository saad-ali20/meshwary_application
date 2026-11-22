import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  static const List<Map<String, dynamic>> _transactions = [
    {
      'title': 'رحلة',
      'date': '7 أكتوبر 2026 - 04:32 م',
      'amount': '-31 جنيه',
      'isPositive': false,
      'icon': Icons.electric_scooter_rounded,
    },
    {
      'title': 'إضافة رصيد',
      'date': '7 أكتوبر 2026 - 02:15 م',
      'amount': '+100 جنيه',
      'isPositive': true,
      'icon': Icons.add_circle_outline_rounded,
    },
    {
      'title': 'استرداد',
      'date': '6 أكتوبر 2026 - 11:20 ص',
      'amount': '+25 جنيه',
      'isPositive': true,
      'icon': Icons.replay_rounded,
    },
    {
      'title': 'Promotion',
      'date': '5 أكتوبر 2026 - 09:45 م',
      'amount': '+20 جنيه',
      'isPositive': true,
      'icon': Icons.card_giftcard_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
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
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
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
                    'المحفظة',
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

                    // ── Balance Card ─────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(sh * 0.024),
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(20),
                            blurRadius: 18,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: sh * 0.070,
                            height: sh * 0.070,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(30),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              color: AppColors.primary,
                              size: sh * 0.038,
                            ),
                          ),
                          SizedBox(height: sh * 0.012),
                          Text(
                            'رصيدك الحالي',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.016,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: sh * 0.004),
                          Text(
                            '150 جنيه',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.038,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: sh * 0.022),

                          // Add balance button
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('شاشة شحن الرصيد ستتوفر في التحديث القادم.', style: TextStyle(fontFamily: 'Cairo')),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: sh * 0.060,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withAlpha(80),
                                    blurRadius: 14,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'إضافة رصيد',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: sh * 0.018,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: sh * 0.012),

                          // Transactions button
                          Container(
                            width: double.infinity,
                            height: sh * 0.056,
                            decoration: BoxDecoration(
                              color: const Color(0xFF192D31),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'المعاملات',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: sh * 0.017,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: sh * 0.028),

                    // Section Heading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'عرض الكل',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: sh * 0.015,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'آخر المعاملات',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: sh * 0.018,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: sh * 0.014),

                    // Transactions List
                    ..._transactions.map((tx) {
                      final isPositive = tx['isPositive'] as bool;
                      final amountColor =
                          isPositive ? AppColors.primary : AppColors.error;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(sh * 0.016),
                        decoration: BoxDecoration(
                          color: const Color(0xFF132225),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Text(
                              tx['amount'] as String,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: sh * 0.018,
                                fontWeight: FontWeight.w800,
                                color: amountColor,
                              ),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  tx['title'] as String,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: sh * 0.016,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: sh * 0.003),
                                Text(
                                  tx['date'] as String,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: sh * 0.013,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: sh * 0.014),
                            Container(
                              width: sh * 0.046,
                              height: sh * 0.046,
                              decoration: BoxDecoration(
                                color: const Color(0xFF192D31),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                tx['icon'] as IconData,
                                color: isPositive
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                size: sh * 0.024,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

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

