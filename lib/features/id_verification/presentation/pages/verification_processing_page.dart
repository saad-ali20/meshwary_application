import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/verification_session.dart';

/// Processing screen shown after data submission — simulates backend review.
class VerificationProcessingPage extends StatefulWidget {
  const VerificationProcessingPage({super.key, required this.session});

  final VerificationSession session;

  @override
  State<VerificationProcessingPage> createState() =>
      _VerificationProcessingPageState();
}

class _VerificationProcessingPageState
    extends State<VerificationProcessingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateCtrl;

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    super.dispose();
  }

  void _dismiss() {
    // Simulate a random success/failure for demo.
    // In production this would come from API response.
    final isSuccess = math.Random().nextBool();
    context.pushReplacement(
      AppRoutes.verificationResult,
      extra: {'session': widget.session, 'isSuccess': isSuccess},
    );
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sh * 0.030),
          child: Column(
            children: [
              SizedBox(height: sh * 0.015),

              // ── Step badge top-right ───────────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: _StepBadge(current: 13, total: 15),
              ),

              const Spacer(),

              // ── Hourglass animation ───────────────────────────────────────
              AnimatedBuilder(
                animation: _rotateCtrl,
                builder: (_, child) {
                  return Transform.rotate(
                    angle: _rotateCtrl.value * 2 * math.pi,
                    child: Container(
                      width: sh * 0.15,
                      height: sh * 0.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(30),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.hourglass_top_rounded,
                        color: AppColors.primary,
                        size: sh * 0.07,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: sh * 0.04),

              // ── Title ─────────────────────────────────────────────────────
              Text(
                'جاري مراجعة بياناتك',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: sh * 0.030,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: sh * 0.014),

              Text(
                'سيتم إشعارك بالنتيجة خلال دقائق قليلة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: sh * 0.017,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),

              const Spacer(),

              // ── OK button ─────────────────────────────────────────────────
              _PrimaryButton(
                id: 'btn_processing_ok',
                label: 'حسناً',
                onPressed: _dismiss,
              ),

              SizedBox(height: sh * 0.035 + bottom),
            ],
          ),
        ),
      ),
    );
  }
}

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

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton(
      {required this.id, required this.label, required this.onPressed});
  final String id;
  final String label;
  final VoidCallback onPressed;

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
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withAlpha(80),
                  blurRadius: 20,
                  offset: const Offset(0, 6))
            ],
          ),
          alignment: Alignment.center,
          child: Text(widget.label,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: sh * 0.02,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textOnPrimary)),
        ),
      ),
    );
  }
}
