import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_colors.dart';

/// Meshwary splash screen.
///
/// Full-screen background image with logo, tagline, and an animated
/// neon-gradient progress bar at the bottom. After the bar reaches
/// 100 %, navigates to the next screen.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  // ── Fade-in animation for logo + text ──────────────────────────────────
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  // ── Progress bar animation (0 → 1 over ~3 seconds) ────────────────────
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();

    // Fade-in animation for logo + text
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();

    // Progress bar animation
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    );
    _progressAnimation.addListener(_onProgressTick);
    _progressController.forward().then((_) {
      // Navigate to onboarding when loading is complete
      if (mounted) context.go(AppRoutes.onboarding);
    });
  }

  void _onProgressTick() {
    setState(() {
      _progressValue = _progressAnimation.value;
    });
  }

  @override
  void dispose() {
    // _progressAnimation.removeListener(_onProgressTick);
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final percent = (_progressValue * 100).round();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background image ─────────────────────────────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/meshwary_bg1.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          // ── Dark gradient overlay for readability ────────────────────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.25, 0.7, 1.0],
                  colors: [
                    AppColors.background.withAlpha(220),
                    AppColors.background.withAlpha(120),
                    Colors.transparent,
                    AppColors.background.withAlpha(240),
                  ],
                ),
              ),
            ),
          ),

          // ── Subtle neon-green border glow at bottom edge ─────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.primary.withAlpha(100),
                    AppColors.primary.withAlpha(180),
                    AppColors.primary.withAlpha(100),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ── Logo ─────────────────────────────────────────────────
                  SizedBox(
                    width: size.width * 0.55,
                    child: Image.asset(
                      'assets/images/meshwary_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Tagline ──────────────────────────────────────────────
                  // Text(
                  //   'سكوتر الصعيد',
                  //   style: TextStyle(fontFamily: 'Cairo', 
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.w600,
                  //     color: AppColors.textPrimary.withAlpha(200),
                  //     letterSpacing: 1.0,
                  //   ),
                  // ),
                  const Spacer(flex: 5),

                  // ── Neon gradient progress bar ───────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        final progress = _progressAnimation.value.clamp(
                          0.0,
                          1.0,
                        );
                        final percent = (progress * 100).round();

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 6,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A3A3D),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: progress,
                                  heightFactor: 1,
                                  child: const DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.info,
                                          AppColors.primary,
                                          AppColors.warning,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              '$percent%',
                              style: TextStyle(fontFamily: 'Cairo', 
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary.withAlpha(180),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Loading text ─────────────────────────────────────────
                  Text(
                    'جاري التحميل...',
                    style: TextStyle(fontFamily: 'Cairo', 
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: bottomPadding + 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
