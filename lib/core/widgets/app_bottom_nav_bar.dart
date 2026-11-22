import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/router/routes.dart';
import '../theme/app_colors.dart';

/// Meshwary 5-tab Bottom Navigation Bar.
///
/// Corresponds to:
/// 0: الرئيسية (Home)
/// 1: رحلاتي (My Rides)
/// 2: المحفظة (Wallet)
/// 3: الإشعارات (Notifications)
/// 4: حسابي (Profile / My Account)
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int>? onTap;

  static const _items = [
    (Icons.home_rounded, Icons.home_outlined, 'الرئيسية', AppRoutes.home),
    (
      Icons.electric_scooter_rounded,
      Icons.electric_scooter_outlined,
      'رحلاتي',
      AppRoutes.myRides,
    ),
    (
      Icons.account_balance_wallet_rounded,
      Icons.account_balance_wallet_outlined,
      'المحفظة',
      AppRoutes.wallet,
    ),
    (
      Icons.notifications_rounded,
      Icons.notifications_outlined,
      'الإشعارات',
      AppRoutes.notifications,
    ),
    (
      Icons.person_rounded,
      Icons.person_outline_rounded,
      'حسابي',
      AppRoutes.profile,
    ),
  ];

  void _handleTap(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
      return;
    }

    if (index == currentIndex) return;

    final targetRoute = _items[index].$4;
    context.go(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Container(
      height: 64 + bottom,
      padding: EdgeInsets.only(bottom: bottom),
      decoration: const BoxDecoration(
        color: Color(0xFF091215),
        border: Border(
          top: BorderSide(
            color: Color(0xFF162529),
            width: 1.2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final active = currentIndex == i;

          return Expanded(
            child: GestureDetector(
              onTap: () => _handleTap(context, i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Active top bar indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    width: active ? 22 : 0,
                    height: 3,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(120),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),

                  // Icon
                  Icon(
                    active ? item.$1 : item.$2,
                    color: active ? AppColors.primary : const Color(0xFF4A6B65),
                    size: 23,
                  ),
                  const SizedBox(height: 3),

                  // Label
                  Text(
                    item.$3,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: active ? AppColors.primary : const Color(0xFF4A6B65),
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

