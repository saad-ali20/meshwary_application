import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/verification_session.dart';

/// Final result screen: success (screen 14) or failure (screen 15).
class VerificationResultPage extends StatefulWidget {
  const VerificationResultPage({
    super.key,
    required this.isSuccess,
    required this.session,
  });

  final bool isSuccess;
  final VerificationSession session;

  @override
  State<VerificationResultPage> createState() => _VerificationResultPageState();
}

class _VerificationResultPageState extends State<VerificationResultPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fade,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sh * 0.030),
            child: Column(
              children: [
                SizedBox(height: sh * 0.015),

                // ── Step badge ────────────────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: _StepBadge(
                    current: widget.isSuccess ? 14 : 15,
                    total: 15,
                  ),
                ),

                const Spacer(),

                // ── Result icon ───────────────────────────────────────────────
                ScaleTransition(
                  scale: _scale,
                  child: _ResultIcon(isSuccess: widget.isSuccess, sh: sh),
                ),

                SizedBox(height: sh * 0.04),

                // ── Title ─────────────────────────────────────────────────────
                Text(
                  widget.isSuccess ? 'تم التحقق بنجاح' : 'تعذر التحقق',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: sh * 0.030,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: sh * 0.014),

                Text(
                  widget.isSuccess
                      ? 'يمكنك الآن استخدام مشواري\nوفتح السكوترات'
                      : 'تعذر التحقق من البيانات، يرجى\nالتأكد من وضوح الصور والمحاولة مجدداً',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: sh * 0.017,
                    color: AppColors.textSecondary,
                    height: 1.7,
                  ),
                ),

                const Spacer(),

                // ── Buttons ───────────────────────────────────────────────────
                if (widget.isSuccess) ...[
                  _PrimaryButton(
                    id: 'btn_go_to_map',
                    label: 'الانتقال إلى الخريطة',
                    color: AppColors.primary,
                    onPressed: () => context.go(AppRoutes.home),
                  ),
                ] else ...[
                  _PrimaryButton(
                    id: 'btn_retry',
                    label: 'إعادة المحاولة',
                    color: AppColors.error,
                    onPressed: () => context.go(
                      AppRoutes.idVerificationIntro,
                      extra: VerificationSession(
                        fullName: widget.session.fullName,
                        phoneNumber: widget.session.phoneNumber,
                      ),
                    ),
                  ),
                  SizedBox(height: sh * 0.014),
                  _OutlineButton(
                    id: 'btn_support',
                    label: 'تواصل مع الدعم',
                    onPressed: () {},
                  ),
                ],

                SizedBox(height: sh * 0.035 + bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Result Icon ───────────────────────────────────────────────────────────────

class _ResultIcon extends StatelessWidget {
  const _ResultIcon({required this.isSuccess, required this.sh});
  final bool isSuccess;
  final double sh;

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? AppColors.primary : AppColors.error;
    final icon = isSuccess ? Icons.check_rounded : Icons.close_rounded;

    return Container(
      width: sh * 0.17,
      height: sh * 0.17,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withAlpha(20),
        border: Border.all(color: color.withAlpha(80), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(50),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Icon(icon, color: color, size: sh * 0.09),
    );
  }
}

// ── Primary Button ────────────────────────────────────────────────────────────

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.id,
    required this.label,
    required this.onPressed,
    required this.color,
  });
  final String id;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          key: ValueKey(widget.id),
          width: double.infinity,
          height: sh * 0.068,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: widget.color.withAlpha(80),
                  blurRadius: 20,
                  offset: const Offset(0, 6)),
            ],
          ),
          alignment: Alignment.center,
          child: Text(widget.label,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: sh * 0.02,
                  fontWeight: FontWeight.w700,
                  color: widget.color == AppColors.primary
                      ? AppColors.textOnPrimary
                      : Colors.white)),
        ),
      ),
    );
  }
}

// ── Outline Button ────────────────────────────────────────────────────────────

class _OutlineButton extends StatefulWidget {
  const _OutlineButton(
      {required this.id, required this.label, required this.onPressed});
  final String id;
  final String label;
  final VoidCallback onPressed;

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          key: ValueKey(widget.id),
          width: double.infinity,
          height: sh * 0.062,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(widget.label,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: sh * 0.019,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
        ),
      ),
    );
  }
}

// ── Step Badge ────────────────────────────────────────────────────────────────

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: sh * 0.014, vertical: sh * 0.006),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Text('$current / $total',
          style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: sh * 0.014,
              color: AppColors.textSecondary)),
    );
  }
}
