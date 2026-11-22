import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/scooter_model.dart';

/// Screen 6: التحقق قبل الفتح (التحقق من السكوتر)
/// Step 6 in the user journey:
/// - Top bar: Back button, "التحقق من السكوتر"
/// - 3 Verification items with glowing green checks:
///   1. الهوية: تم التحقق منها
///   2. وسيلة الدفع: محفظتي (الرصيد: 52 جنيه)
///   3. السكوتر: متاح - SC-1024
/// - Bottom CTA: "فتح السكوتر" with lock icon -> Step 7: جاري فتح السكوتر
class PreUnlockVerificationPage extends StatefulWidget {
  const PreUnlockVerificationPage({super.key, required this.scooter});
  final ScooterModel? scooter;

  @override
  State<PreUnlockVerificationPage> createState() =>
      _PreUnlockVerificationPageState();
}

class _PreUnlockVerificationPageState extends State<PreUnlockVerificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final scooterCode = widget.scooter?.code ?? 'SC-1024';

    return Scaffold(
      backgroundColor: const Color(0xFF071214),
      body: SafeArea(
        bottom: false,
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            children: [
              // ── Top Bar ────────────────────────────────────────────────────
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
                      'التحقق من السكوتر',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Verification Checklist ─────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Item 1: الهوية
                      _VerificationCard(
                        title: 'الهوية',
                        subtitle: 'تم التحقق منها',
                        icon: Icons.badge_outlined,
                      ),

                      const SizedBox(height: 14),

                      // Item 2: وسيلة الدفع
                      _VerificationCard(
                        title: 'وسيلة الدفع',
                        subtitle: 'محفظتي (الرصيد: 52 جنيه)',
                        icon: Icons.account_balance_wallet_outlined,
                      ),

                      const SizedBox(height: 14),

                      // Item 3: السكوتر
                      _VerificationCard(
                        title: 'السكوتر',
                        subtitle: 'متاح - $scooterCode',
                        icon: Icons.electric_scooter_rounded,
                      ),

                      const Spacer(),

                      // Info text
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.verified_user_rounded,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'تم التحقق من جميع المتطلبات بنجاح',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Color(0xFF9CB9B2),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // ── Bottom Action Button: فتح السكوتر ──────────────────────────
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
                      context.pushReplacement(
                        AppRoutes.unlockingProgress,
                        extra: widget.scooter,
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
                            color: AppColors.primary.withAlpha(80),
                            blurRadius: 18,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_open_rounded,
                            color: Color(0xFF071214),
                            size: 22,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'فتح السكوتر',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF071214),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerificationCard extends StatelessWidget {
  const _VerificationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E2226),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withAlpha(55),
        ),
      ),
      child: Row(
        children: [
          // Green glowing checkmark circle
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withAlpha(25),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Color(0xFF9CB9B2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Leading Category Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF132B30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
        ],
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
