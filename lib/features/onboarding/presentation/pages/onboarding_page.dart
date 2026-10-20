import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';

// ── Data model ────────────────────────────────────────────────────────────────

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
  });

  final String image;
  final String title;
  final String subtitle;
  final String buttonLabel;
}

const _slides = [
  _OnboardingSlide(
    image: 'assets/images/meshwary_onboarding1.png',
    title: 'تحرك بحرية',
    subtitle: 'استأجر سكوتر قريب منك وتحرك\nفي المدينة بسهولة.',
    buttonLabel: 'التالي',
  ),
  _OnboardingSlide(
    image: 'assets/images/meshwary_onboarding2.png',
    title: 'امسح QR Code',
    subtitle: 'امسح QR Code الموجود على السكوتر\nوابدأ رحلتك في ثواني.',
    buttonLabel: 'التالي',
  ),
  _OnboardingSlide(
    image: 'assets/images/meshwary-onboarding3.png',
    title: 'ادفع بسهولة',
    subtitle: 'ادفع مقابل رحلتك من المحفظة\nأو طرق الدفع المتاحة.',
    buttonLabel: 'إبدأ الآن',
  ),
];

// ── Page ──────────────────────────────────────────────────────────────────────

/// Meshwary onboarding — full-screen image background with text overlay at top,
/// dots + button pinned at bottom. Matches the provided design exactly.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  late AnimationController _textAnimController;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _textAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _textFade = CurvedAnimation(
      parent: _textAnimController,
      curve: Curves.easeOut,
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _textAnimController,
            curve: Curves.easeOutCubic,
          ),
        );
    _textAnimController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textAnimController.dispose();
    super.dispose();
  }

  void _goToNext() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.go(AppRoutes.phoneAuth);
    }
  }

  void _skip() => context.go(AppRoutes.phoneAuth);

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _textAnimController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final topPadding = MediaQuery.paddingOf(context).top;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isLast = _currentIndex == _slides.length - 1;
    final slide = _slides[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── 1. Full-screen swipeable background images ──────────────────
          PageView.builder(
            reverse: true,
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _slides[index].image,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              );
            },
          ),

          // ── 2. Top gradient overlay (text readability) ──────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withAlpha(230),
                    AppColors.background.withAlpha(180),
                    AppColors.background.withAlpha(80),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.35, 0.65, 1.0],
                ),
              ),
            ),
          ),

          // ── 3. Bottom gradient overlay (dots + button readability) ──────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.22,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background.withAlpha(230),
                    AppColors.background.withAlpha(160),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),

          // ── 4. UI overlay (skip + title + subtitle at top, dots+btn at bottom)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Skip button ─────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.only(top: topPadding + 24, left: 12),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: AnimatedOpacity(
                    opacity: isLast ? 0 : 1,
                    duration: const Duration(milliseconds: 250),
                    child: TextButton.icon(
                      onPressed: isLast ? null : _skip,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                      ),
                      icon: const Icon(
                        Icons.chevron_left,
                        color: AppColors.textSecondary,
                        size: 16,
                      ),
                      label: Text(
                        'تخطي',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.12),

              // ── Title + subtitle (animated, overlaid on image top) ──────
              FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: _textSlide,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          slide.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            height: 1.65,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Spacer pushes dots+button to the very bottom ────────────
              const Spacer(),

              // ── Dot indicators (LTR: first dot always on left) ─────────
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (i) {
                    return _DotIndicator(isActive: i == _currentIndex);
                  }),
                ),
              ),

              SizedBox(height: screenHeight * 0.018),

              // ── CTA button ──────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  screenHeight * 0.025,
                  0,
                  screenHeight * 0.025,
                  bottomPadding + screenHeight * 0.025,
                ),
                child: _NeonButton(
                  label: slide.buttonLabel,
                  showArrow: !isLast,
                  onPressed: _goToNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Dot indicator ─────────────────────────────────────────────────────────────

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 20 : 7,
      height: 7,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.white.withAlpha(80),
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withAlpha(110),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
    );
  }
}

// ── Neon CTA button ───────────────────────────────────────────────────────────

class _NeonButton extends StatefulWidget {
  const _NeonButton({
    required this.label,
    required this.onPressed,
    this.showArrow = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool showArrow;

  @override
  State<_NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<_NeonButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 110),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(90),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.showArrow) ...[
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textOnPrimary,
                  size: 20,
                ),
                const SizedBox(width: 2),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
