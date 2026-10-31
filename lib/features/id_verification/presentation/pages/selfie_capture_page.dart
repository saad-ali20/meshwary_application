import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/verification_session.dart';

/// Selfie capture page — camera-only (front camera), oval face frame.
class SelfieCapturePage extends StatefulWidget {
  const SelfieCapturePage({super.key, required this.session});

  final VerificationSession session;

  @override
  State<SelfieCapturePage> createState() => _SelfieCapturePageState();
}

class _SelfieCapturePageState extends State<SelfieCapturePage> {
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.session.selfiePath;
  }

  Future<void> _takeSelfie() async {
    setState(() => _isLoading = true);
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        preferredCameraDevice: CameraDevice.front,
      );
      if (file != null && mounted) {
        setState(() => _imagePath = file.path);
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _continue() {
    if (_imagePath == null) return;
    widget.session.selfiePath = _imagePath;
    context.push(AppRoutes.verificationReview, extra: widget.session);
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final hasImage = _imagePath != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sh * 0.025)
                  .copyWith(top: sh * 0.012),
              child: Row(
                children: [
                  _BackButton(onTap: () => context.pop()),
                  const Spacer(),
                  _StepBadge(current: 11, total: 15),
                ],
              ),
            ),

            SizedBox(height: sh * 0.02),

            // ── Title ────────────────────────────────────────────────────────
            Text(
              'تصوير الوجه الشخصي',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: sh * 0.026,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: sh * 0.025),

            // ── Oval Face Frame ───────────────────────────────────────────────
            GestureDetector(
              onTap: hasImage ? null : _takeSelfie,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: sh * 0.06),
                height: sh * 0.30,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: hasImage ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                  boxShadow: hasImage
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(40),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: ClipOval(
                  child: hasImage
                      ? Image.file(File(_imagePath!), fit: BoxFit.cover)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.face_rounded,
                              color: AppColors.textDisabled,
                              size: sh * 0.09,
                            ),
                            SizedBox(height: sh * 0.01),
                            Text(
                              'اضغط للتصوير',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: sh * 0.015,
                                color: AppColors.textDisabled,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            SizedBox(height: sh * 0.028),

            // ── Tips ─────────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sh * 0.030),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: sh * 0.013),
                  _TipRow(
                    icon: Icons.remove_red_eye_outlined,
                    label: 'انظر مباشرةً للكاميرا',
                  ),
                  SizedBox(height: sh * 0.013),
                  _TipRow(
                    icon: Icons.face_retouching_natural_rounded,
                    label: 'تأكد من وضوح الوجه بالشبكة',
                  ),
                  SizedBox(height: sh * 0.013),
                  _TipRow(
                    icon: Icons.wb_sunny_outlined,
                    label: 'إضاءة جيدة ومتوازنة',
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── Bottom actions ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sh * 0.025)
                  .copyWith(bottom: sh * 0.012),
              child: hasImage
                  ? Column(
                      children: [
                        _PrimaryButton(
                          id: 'btn_selfie_continue',
                          label: 'متابعة لمراجعة البيانات',
                          onPressed: _continue,
                        ),
                        SizedBox(height: sh * 0.012),
                        TextButton(
                          onPressed: () => setState(() => _imagePath = null),
                          child: Text(
                            'إعادة التصوير',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.016,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    )
                  : _CaptureButton(
                      id: 'btn_selfie_capture',
                      isLoading: _isLoading,
                      onTap: _takeSelfie,
                      label: 'التقط صورة شخصية',
                      icon: Icons.camera_front_rounded,
                    ),
            ),

            SizedBox(height: bottom + sh * 0.01),
          ],
        ),
      ),
    );
  }
}

// ── Tip Row ───────────────────────────────────────────────────────────────────

class _TipRow extends StatelessWidget {
  const _TipRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: sh * 0.020,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
        SizedBox(width: sh * 0.014),
        Icon(icon, color: AppColors.primary, size: sh * 0.030),
      ],
    );
  }
}

// ── Capture Button ────────────────────────────────────────────────────────────

class _CaptureButton extends StatefulWidget {
  const _CaptureButton({
    required this.id,
    required this.onTap,
    required this.isLoading,
    required this.label,
    required this.icon,
  });
  final String id;
  final VoidCallback onTap;
  final bool isLoading;
  final String label;
  final IconData icon;

  @override
  State<_CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<_CaptureButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
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
                blurRadius: 18,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: widget.isLoading
              ? Center(
                  child: SizedBox(
                    width: sh * 0.028,
                    height: sh * 0.028,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon,
                        color: AppColors.textOnPrimary, size: sh * 0.026),
                    SizedBox(width: sh * 0.010),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: sh * 0.019,
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

// ── Step Badge ────────────────────────────────────────────────────────────────

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: sh * 0.014, vertical: sh * 0.006),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        '$current / $total',
        style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: sh * 0.014,
            color: AppColors.textSecondary),
      ),
    );
  }
}

// ── Back Button ───────────────────────────────────────────────────────────────

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

// ── Primary Button ────────────────────────────────────────────────────────────

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
                  offset: const Offset(0, 6)),
            ],
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
    );
  }
}
