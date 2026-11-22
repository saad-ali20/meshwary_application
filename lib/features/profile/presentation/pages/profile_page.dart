import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di/injection.dart';
import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../widgets/profile_menu_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'Saad Ali';
  String _phoneNumber = '01016811270';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authRepo = getIt<AuthRepository>();
    final user = await authRepo.loadCachedUser();
    if (user != null && mounted) {
      setState(() {
        if (user.fullName.trim().isNotEmpty) {
          _userName = user.fullName.trim();
        }
        if (user.phoneNumber.trim().isNotEmpty) {
          _phoneNumber = user.phoneNumber.trim();
        }
      });
    }
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
                    'حسابي',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: sh * 0.026,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: sh * 0.048), // Balancing placeholder
                ],
              ),
            ),

            // ── Scrollable Content ───────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.024),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: sh * 0.015),

                    // ── User Avatar & Info ───────────────────────────────────
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow circle
                          Container(
                            width: sh * 0.125,
                            height: sh * 0.125,
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
                          // Avatar Circle
                          Container(
                            width: sh * 0.110,
                            height: sh * 0.110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF132225),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(60),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Center(
                                child: Icon(
                                  Icons.person_rounded,
                                  color: AppColors.primary,
                                  size: sh * 0.085,
                                ),
                              ),
                            ),
                          ),
                          // Small bottom badge
                          Positioned(
                            bottom: 2,
                            right: sh * 0.008,
                            child: Container(
                              width: sh * 0.034,
                              height: sh * 0.034,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.background,
                                  width: 2.2,
                                ),
                              ),
                              child: Icon(
                                Icons.bolt_rounded,
                                color: AppColors.textOnPrimary,
                                size: sh * 0.020,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: sh * 0.014),

                    // User Full Name
                    Text(
                      _userName,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: sh * 0.024,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: sh * 0.004),

                    // Phone Number
                    Text(
                      _phoneNumber,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: sh * 0.016,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),

                    SizedBox(height: sh * 0.028),

                    // ── Menu List ────────────────────────────────────────────
                    ProfileMenuItem(
                      title: 'البيانات الشخصية',
                      icon: Icons.person_outline_rounded,
                      onTap: () => context.push(AppRoutes.personalInfo),
                    ),
                    ProfileMenuItem(
                      title: 'طرق الدفع',
                      icon: Icons.credit_card_rounded,
                      onTap: () => context.push(AppRoutes.paymentMethods),
                    ),
                    ProfileMenuItem(
                      title: 'رحلاتي',
                      icon: Icons.electric_scooter_rounded,
                      onTap: () => context.push(AppRoutes.myRides),
                    ),
                    ProfileMenuItem(
                      title: 'المحفظة',
                      icon: Icons.account_balance_wallet_outlined,
                      onTap: () => context.push(AppRoutes.wallet),
                    ),
                    ProfileMenuItem(
                      title: 'دعوة الأصدقاء',
                      icon: Icons.card_giftcard_rounded,
                      onTap: () => context.push(AppRoutes.inviteFriends),
                    ),
                    ProfileMenuItem(
                      title: 'مركز المساعدة',
                      icon: Icons.help_outline_rounded,
                      onTap: () => context.push(AppRoutes.support),
                    ),
                    ProfileMenuItem(
                      title: 'الإعدادات',
                      icon: Icons.settings_outlined,
                      onTap: () => context.push(AppRoutes.settings),
                    ),
                    ProfileMenuItem(
                      title: 'الشروط والأحكام',
                      icon: Icons.description_outlined,
                      onTap: () => context.push(AppRoutes.terms),
                    ),

                    SizedBox(height: sh * 0.014),

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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: AppColors.error,
                              size: sh * 0.022,
                            ),
                            SizedBox(width: sh * 0.010),
                            Text(
                              'تسجيل الخروج',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: sh * 0.018,
                                fontWeight: FontWeight.w700,
                                color: AppColors.error,
                              ),
                            ),
                          ],
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
