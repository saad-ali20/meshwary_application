import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/verification_session.dart';

/// Shows all captured images + user info for final review before submission.
class DataReviewPage extends StatefulWidget {
  const DataReviewPage({super.key, required this.session});

  final VerificationSession session;

  @override
  State<DataReviewPage> createState() => _DataReviewPageState();
}

class _DataReviewPageState extends State<DataReviewPage>
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

  void _submit() {
    context.push(AppRoutes.verificationProcessing, extra: widget.session);
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final s = widget.session;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fade,
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ─────────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.025)
                    .copyWith(top: sh * 0.012),
                child: Row(
                  children: [
                    _BackButton(onTap: () => context.pop()),
                    const Spacer(),
                    _StepBadge(current: 12, total: 15),
                  ],
                ),
              ),

              SizedBox(height: sh * 0.02),

              Text(
                'مراجعة البيانات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: sh * 0.028,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: sh * 0.022),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: sh * 0.025),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Image thumbnails ────────────────────────────────────
                      Row(
                        children: [
                          _ImageThumb(
                            path: s.idFrontPath,
                            label: 'الوجه الأمامي',
                            isCircle: false,
                          ),
                          SizedBox(width: sh * 0.012),
                          _ImageThumb(
                            path: s.idBackPath,
                            label: 'الوجه الخلفي',
                            isCircle: false,
                          ),
                          SizedBox(width: sh * 0.012),
                          _ImageThumb(
                            path: s.selfiePath,
                            label: 'الصورة الشخصية',
                            isCircle: true,
                          ),
                        ],
                      ),

                      SizedBox(height: sh * 0.026),

                      // ── User info card ──────────────────────────────────────
                      Container(
                        padding: EdgeInsets.all(sh * 0.022),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            _InfoRow(
                              label: 'الاسم',
                              value: s.fullName,
                            ),
                            Divider(
                              color: AppColors.border,
                              height: sh * 0.032,
                            ),
                            _InfoRow(
                              label: 'رقم الهاتف',
                              value: s.phoneNumber,
                            ),
                            Divider(
                              color: AppColors.border,
                              height: sh * 0.032,
                            ),
                            _InfoRow(
                              label: 'تاريخ الميلاد',
                              value: s.dateOfBirth ?? '—',
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: sh * 0.022),

                      // ── Note ───────────────────────────────────────────────
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: sh * 0.018,
                          vertical: sh * 0.014,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGlow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withAlpha(60),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.primary,
                              size: sh * 0.022,
                            ),
                            SizedBox(width: sh * 0.010),
                            Expanded(
                              child: Text(
                                'سيتم مراجعة بياناتك خلال دقائق قليلة بعد الإرسال',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: sh * 0.015,
                                  color: AppColors.primary,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: sh * 0.03),
                    ],
                  ),
                ),
              ),

              // ── Submit button ───────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.025)
                    .copyWith(bottom: sh * 0.02 + bottom),
                child: _PrimaryButton(
                  id: 'btn_submit_review',
                  label: 'إرسال الطلب',
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Image Thumbnail ───────────────────────────────────────────────────────────

class _ImageThumb extends StatelessWidget {
  const _ImageThumb({
    required this.path,
    required this.label,
    required this.isCircle,
  });

  final String? path;
  final String label;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final size = sh * 0.115;

    return Expanded(
      child: Column(
        children: [
          Container(
            height: size,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isCircle ? null : BorderRadius.circular(10),
              border: Border.all(
                color: path != null ? AppColors.primary : AppColors.border,
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius:
                  isCircle ? BorderRadius.circular(size) : BorderRadius.circular(9),
              child: path != null
                  ? Image.file(File(path!), fit: BoxFit.cover)
                  : Icon(
                      isCircle ? Icons.face_rounded : Icons.credit_card_rounded,
                      color: AppColors.textDisabled,
                      size: sh * 0.04,
                    ),
            ),
          ),
          SizedBox(height: sh * 0.006),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: sh * 0.013,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Row ──────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: sh * 0.018,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: sh * 0.015,
            color: AppColors.textSecondary,
          ),
        ),
      ],
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
        child: Icon(Icons.chevron_right_rounded,
            color: AppColors.textPrimary, size: sh * 0.028),
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
