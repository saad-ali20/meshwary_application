import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
                    'عن التطبيق',
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
                padding: EdgeInsets.symmetric(horizontal: sh * 0.026),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: sh * 0.025),

                    // App Logo
                    Image.asset(
                      'assets/images/meshwary_logo.png',
                      height: sh * 0.17,
                    ),

                    SizedBox(height: sh * 0.012),

                    // Text(
                    //   'سكوتر الصعيد',
                    //   style: TextStyle(
                    //     fontFamily: 'Cairo',
                    //     fontSize: sh * 0.022,
                    //     fontWeight: FontWeight.w700,
                    //     color: AppColors.textPrimary,
                    //   ),
                    // ),
                    SizedBox(height: sh * 0.004),

                    Text(
                      'الإصدار 1.0.0',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: sh * 0.016,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: sh * 0.038),

                    // ── Section 1: عن الشركة ─────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(sh * 0.020),
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'عن الشركة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.018,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: sh * 0.008),
                          Text(
                            'مشواري هو خدمة مشاركة السكوتر الكهربائي التي تهدف لتسهيل تنقلك في مدينتك بسرعة وأمان وبتكلفة مناسبة.',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.015,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: sh * 0.020),

                    // ── Section 2: تواصل معنا ────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(sh * 0.020),
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'تواصل معنا',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.018,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: sh * 0.014),

                          // Phone
                          GestureDetector(
                            onTap: () => _makePhoneCall('01016811270'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '01016811270',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: sh * 0.016,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF192D31),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.phone_rounded,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: sh * 0.012),

                          // Email
                          GestureDetector(
                            onTap: () => _sendEmail('support@meshwary.com'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'support@meshwary.com',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: sh * 0.016,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF192D31),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.email_rounded,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: sh * 0.018),

                          // Social Icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SocialCircleIcon(
                                icon: Icons.facebook,
                                onTap: () {},
                              ),
                              const SizedBox(width: 14),
                              _SocialCircleIcon(
                                icon: Icons.camera_alt_outlined,
                                onTap: () {},
                              ),
                              const SizedBox(width: 14),
                              _SocialCircleIcon(
                                icon: Icons.close_rounded,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: sh * 0.035),

                    // ── Footer Links ─────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.terms),
                          child: Text(
                            'الشروط والأحكام',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.015,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '•',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: sh * 0.018,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.terms),
                          child: Text(
                            'سياسة الخصوصية',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.015,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
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

class _SocialCircleIcon extends StatelessWidget {
  const _SocialCircleIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF192D31),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}
