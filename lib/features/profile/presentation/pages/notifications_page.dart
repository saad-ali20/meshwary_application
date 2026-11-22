import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _activeFilter = 0; // 0: الكل, 1: رحلات, 2: دفع, 3: عروض, 4: النظام

  static const List<Map<String, dynamic>> _allNotifications = [
    {
      'title': 'تم إنهاء رحلتك بنجاح',
      'body': 'تم إنهاء رحلتك بنجاح، استمتع برحلتك القادمة!',
      'time': '04:32 م',
      'category': 1, // رحلات
      'icon': Icons.check_circle_outline_rounded,
      'isSuccess': true,
    },
    {
      'title': 'تم إضافة 100 جنيه لمحفظتك',
      'body': 'تم إضافة 100 جنيه إلى رصيد محفظتك.',
      'time': '02:15 م',
      'category': 2, // دفع
      'icon': Icons.account_balance_wallet_outlined,
      'isSuccess': true,
    },
    {
      'title': 'لديك عرض جديد',
      'body': 'خصم خاص على الرحلات هذا الأسبوع!',
      'time': '11:20 ص',
      'category': 3, // عروض
      'icon': Icons.card_giftcard_rounded,
      'isSuccess': true,
    },
    {
      'title': 'تحديثات النظام',
      'body': 'تم تحديث التطبيق لإضافة مميزات جديدة.',
      'time': '09:45 م',
      'category': 4, // النظام
      'icon': Icons.settings_outlined,
      'isSuccess': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    final filtered = _allNotifications.where((n) {
      if (_activeFilter == 0) return true;
      return n['category'] == _activeFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
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
                    'الإشعارات',
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

            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              padding: EdgeInsets.symmetric(
                horizontal: sh * 0.024,
                vertical: sh * 0.008,
              ),
              child: Row(
                children: [
                  _FilterPill(
                    label: 'النظام',
                    isActive: _activeFilter == 4,
                    onTap: () => setState(() => _activeFilter = 4),
                  ),
                  const SizedBox(width: 8),
                  _FilterPill(
                    label: 'عروض',
                    isActive: _activeFilter == 3,
                    onTap: () => setState(() => _activeFilter = 3),
                  ),
                  const SizedBox(width: 8),
                  _FilterPill(
                    label: 'دفع',
                    isActive: _activeFilter == 2,
                    onTap: () => setState(() => _activeFilter = 2),
                  ),
                  const SizedBox(width: 8),
                  _FilterPill(
                    label: 'رحلات',
                    isActive: _activeFilter == 1,
                    onTap: () => setState(() => _activeFilter = 1),
                  ),
                  const SizedBox(width: 8),
                  _FilterPill(
                    label: 'الكل',
                    isActive: _activeFilter == 0,
                    onTap: () => setState(() => _activeFilter = 0),
                  ),
                ],
              ),
            ),

            // Notifications List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.024),
                physics: const BouncingScrollPhysics(),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final notif = filtered[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(sh * 0.018),
                    decoration: BoxDecoration(
                      color: const Color(0xFF132225),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notif['time'] as String,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: sh * 0.013,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                notif['title'] as String,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: sh * 0.016,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: sh * 0.004),
                              Text(
                                notif['body'] as String,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: sh * 0.014,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: sh * 0.014),
                        Container(
                          width: sh * 0.046,
                          height: sh * 0.046,
                          decoration: BoxDecoration(
                            color: notif['isSuccess'] == true
                                ? AppColors.primary.withAlpha(25)
                                : const Color(0xFF192D31),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            notif['icon'] as IconData,
                            color: notif['isSuccess'] == true
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: sh * 0.024,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : const Color(0xFF132225),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isActive ? AppColors.textOnPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

