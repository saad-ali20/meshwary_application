import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di/injection.dart';
import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../widgets/profile_menu_item.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF132225),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1F3B3E)),
        ),
        title: const Text(
          'اختر اللغة',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700, color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية', style: TextStyle(fontFamily: 'Cairo', color: AppColors.primary, fontWeight: FontWeight.w700)),
              trailing: const Icon(Icons.check_circle_rounded, color: AppColors.primary),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              title: const Text('English', style: TextStyle(fontFamily: 'Cairo', color: AppColors.textSecondary)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('English language will be supported in upcoming release.', style: TextStyle(fontFamily: 'Cairo'))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF132225),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFF1F3B3E)),
        ),
        title: const Text(
          'تسجيل الخروج',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await getIt<AuthRepository>().logout();
              if (mounted) {
                context.go(AppRoutes.phoneAuth);
              }
            },
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
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
                    'الإعدادات',
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

            // ── Body ─────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.024),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: sh * 0.020),

                    ProfileMenuItem(
                      title: 'اللغة',
                      icon: Icons.language_rounded,
                      trailingText: 'العربية',
                      onTap: _showLanguageDialog,
                    ),
                    ProfileMenuItem(
                      title: 'الإشعارات',
                      icon: Icons.notifications_none_rounded,
                      onTap: () => context.push(AppRoutes.notifications),
                    ),
                    ProfileMenuItem(
                      title: 'الموقع',
                      icon: Icons.location_on_outlined,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تفعيل إذن الموقع بدقة عالية.', style: TextStyle(fontFamily: 'Cairo')),
                            backgroundColor: AppColors.primary,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      title: 'الخصوصية',
                      icon: Icons.shield_outlined,
                      onTap: () => context.push(AppRoutes.terms),
                    ),
                    ProfileMenuItem(
                      title: 'الأمان',
                      icon: Icons.security_rounded,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('حسابك مؤمن برمز التحقق وكلمة المرور.', style: TextStyle(fontFamily: 'Cairo')),
                            backgroundColor: AppColors.primary,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      title: 'طرق الدفع',
                      icon: Icons.credit_card_rounded,
                      onTap: () => context.push(AppRoutes.paymentMethods),
                    ),
                    ProfileMenuItem(
                      title: 'الشروط والأحكام',
                      icon: Icons.description_outlined,
                      onTap: () => context.push(AppRoutes.terms),
                    ),
                    ProfileMenuItem(
                      title: 'عن التطبيق',
                      icon: Icons.info_outline_rounded,
                      onTap: () => context.push(AppRoutes.aboutApp),
                    ),

                    SizedBox(height: sh * 0.020),

                    // ── Logout Button ────────────────────────────────────────
                    GestureDetector(
                      onTap: _showLogoutDialog,
                      child: Container(
                        width: double.infinity,
                        height: sh * 0.064,
                        decoration: BoxDecoration(
                          color: AppColors.error.withAlpha(20),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.error.withAlpha(90),
                            width: 1.3,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'تسجيل الخروج',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: sh * 0.018,
                            fontWeight: FontWeight.w700,
                            color: AppColors.error,
                          ),
                        ),
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

