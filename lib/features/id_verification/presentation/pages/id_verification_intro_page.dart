import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/verification_session.dart';

/// Screen shown after profile completion.
/// Explains the 3-step identity verification flow and lets the user begin.
class IdVerificationIntroPage extends StatefulWidget {
  const IdVerificationIntroPage({
    super.key,
    required this.session,
  });

  final VerificationSession session;

  @override
  State<IdVerificationIntroPage> createState() =>
      _IdVerificationIntroPageState();
}

class _IdVerificationIntroPageState extends State<IdVerificationIntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sh * 0.030),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: sh * 0.015),

                  // ── Back button ────────────────────────────────────────────
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: _BackButton(onTap: () => context.pop()),
                  ),

                  SizedBox(height: sh * 0.04),

                  // ── Title ─────────────────────────────────────────────────
                  Text(
                    'التحقق من الهوية',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: sh * 0.034,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: sh * 0.018),

                  // ── Description ───────────────────────────────────────────
                  Text(
                    'لضمان أمان جميع المستخدمين\nيجب إكمال التحقق من الهوية\nقبل استخدام السكوتر',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: sh * 0.018,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),

                  SizedBox(height: sh * 0.05),

                  // ── Steps ─────────────────────────────────────────────────
                  _StepItem(
                    label: 'تصوير بطاقة الرقم القومي',
                    delay: 100,
                  ),
                  SizedBox(height: sh * 0.018),
                  _StepItem(
                    label: 'تصوير الوجه الشخصي',
                    delay: 200,
                  ),
                  SizedBox(height: sh * 0.018),
                  _StepItem(
                    label: 'مراجعة البيانات',
                    delay: 300,
                  ),

                  const Spacer(),

                  // ── Start button ───────────────────────────────────────────
                  _PrimaryButton(
                    id: 'btn_start_verification',
                    label: 'إبدأ التحقق',
                    onPressed: () => context.push(
                      AppRoutes.idCaptureFront,
                      extra: widget.session,
                    ),
                  ),

                  SizedBox(height: sh * 0.018),

                  // ── Skip link ──────────────────────────────────────────────
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.onboarding),
                    child: Text(
                      'بمكنك تصفح التطبيق الآن',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: sh * 0.017,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),

                  SizedBox(height: sh * 0.035 + bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Step Item ─────────────────────────────────────────────────────────────────

class _StepItem extends StatefulWidget {
  const _StepItem({required this.label, required this.delay});

  final String label;
  final int delay;

  @override
  State<_StepItem> createState() => _StepItemState();
}

class _StepItemState extends State<_StepItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sh * 0.020,
        vertical: sh * 0.016,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          // Check icon
          ScaleTransition(
            scale: _scale,
            child: Container(
              width: sh * 0.036,
              height: sh * 0.036,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: AppColors.textOnPrimary,
                size: sh * 0.022,
              ),
            ),
          ),
          SizedBox(width: sh * 0.016),
          Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: sh * 0.019,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: sh * 0.052,
        height: sh * 0.052,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textPrimary,
          size: sh * 0.028,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.id,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final String id;
  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: widget.enabled ? 1.0 : 0.45,
          duration: const Duration(milliseconds: 200),
          child: Container(
            key: ValueKey(widget.id),
            width: double.infinity,
            height: sh * 0.068,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
              boxShadow: widget.enabled
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(80),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: sh * 0.02,
                fontWeight: FontWeight.w700,
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
