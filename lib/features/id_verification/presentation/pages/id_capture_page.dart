import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/verification_session.dart';

/// Reusable page for capturing both the front and back of the national ID.
class IdCapturePage extends StatefulWidget {
  const IdCapturePage({
    super.key,
    required this.session,
    required this.isBack,
  });

  final VerificationSession session;
  final bool isBack; // false = front, true = back

  @override
  State<IdCapturePage> createState() => _IdCapturePageState();
}

class _IdCapturePageState extends State<IdCapturePage> {
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  bool _isLoading = false;

  int get _stepNumber => widget.isBack ? 10 : 9;
  String get _sideLabel => widget.isBack ? 'الوجه الخلفي' : 'الوجه الأمامي';

  @override
  void initState() {
    super.initState();
    _imagePath = widget.isBack
        ? widget.session.idBackPath
        : widget.session.idFrontPath;
  }

  Future<void> _captureFromCamera() async {
    setState(() => _isLoading = true);
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (file != null && mounted) {
        setState(() => _imagePath = file.path);
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
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
    if (widget.isBack) {
      widget.session.idBackPath = _imagePath;
      context.push(AppRoutes.selfieCapture, extra: widget.session);
    } else {
      widget.session.idFrontPath = _imagePath;
      context.push(AppRoutes.idCaptureBack, extra: widget.session);
    }
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
                  _StepBadge(current: _stepNumber, total: 15),
                ],
              ),
            ),

            SizedBox(height: sh * 0.02),

            // ── Title ────────────────────────────────────────────────────────
            Text(
              'تصوير بطاقة الرقم القومي',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: sh * 0.026,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: sh * 0.004),
            Text(
              _sideLabel,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: sh * 0.018,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: sh * 0.025),

            // ── Camera Frame ─────────────────────────────────────────────────
            GestureDetector(
              onTap: hasImage ? null : _captureFromCamera,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: sh * 0.025),
                height: sh * 0.27,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: hasImage ? AppColors.primary : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image or placeholder
                      if (hasImage)
                        Image.file(
                          File(_imagePath!),
                          fit: BoxFit.cover,
                        )
                      else
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.credit_card_rounded,
                              color: AppColors.textDisabled,
                              size: sh * 0.07,
                            ),
                            SizedBox(height: sh * 0.012),
                            Text(
                              'اضغط للتصوير',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: sh * 0.016,
                                color: AppColors.textDisabled,
                              ),
                            ),
                          ],
                        ),

                      // Corner brackets overlay
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _CornerBracketPainter(
                            color: hasImage
                                ? AppColors.primary
                                : AppColors.primary.withAlpha(180),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: sh * 0.022),

            // ── Tips ─────────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sh * 0.030),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: sh * 0.013),
                  _TipRow(
                    icon: Icons.crop_free_rounded,
                    label: 'ضع البطاقة داخل الإطار',
                  ),
                  SizedBox(height: sh * 0.013),
                  _TipRow(
                    icon: Icons.visibility_rounded,
                    label: 'تأكد من وضوح البيانات',
                  ),
                  SizedBox(height: sh * 0.013),
                  _TipRow(
                    icon: Icons.wb_sunny_outlined,
                    label: 'تجنب الانعكاس والضوء القوي',
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── Capture / Continue button ─────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sh * 0.025)
                  .copyWith(bottom: sh * 0.012),
              child: hasImage
                  ? Column(
                      children: [
                        _PrimaryButton(
                          id: 'btn_continue',
                          label: widget.isBack ? 'متابعة لتصوير الوجه' : 'متابعة للوجه الخلفي',
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
                  : Row(
                      children: [
                        // Gallery button
                        _IconButton(
                          id: 'btn_gallery',
                          icon: Icons.photo_library_outlined,
                          onTap: _pickFromGallery,
                        ),
                        SizedBox(width: sh * 0.015),
                        // Camera button
                        Expanded(
                          child: _CaptureButton(
                            id: 'btn_capture',
                            isLoading: _isLoading,
                            onTap: _captureFromCamera,
                          ),
                        ),
                      ],
                    ),
            ),

            SizedBox(height: bottom + sh * 0.01),
          ],
        ),
      ),
    );
  }
}

// ── Corner Bracket Painter ────────────────────────────────────────────────────

class _CornerBracketPainter extends CustomPainter {
  const _CornerBracketPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 24.0;
    const margin = 12.0;

    final corners = [
      // Top-left
      [
        Offset(margin, margin + len),
        Offset(margin, margin),
        Offset(margin + len, margin),
      ],
      // Top-right
      [
        Offset(size.width - margin - len, margin),
        Offset(size.width - margin, margin),
        Offset(size.width - margin, margin + len),
      ],
      // Bottom-left
      [
        Offset(margin, size.height - margin - len),
        Offset(margin, size.height - margin),
        Offset(margin + len, size.height - margin),
      ],
      // Bottom-right
      [
        Offset(size.width - margin - len, size.height - margin),
        Offset(size.width - margin, size.height - margin),
        Offset(size.width - margin, size.height - margin - len),
      ],
    ];

    for (final pts in corners) {
      final path = Path()
        ..moveTo(pts[0].dx, pts[0].dy)
        ..lineTo(pts[1].dx, pts[1].dy)
        ..lineTo(pts[2].dx, pts[2].dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_CornerBracketPainter old) => old.color != color;
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
  });
  final String id;
  final VoidCallback onTap;
  final bool isLoading;

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
                    Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.textOnPrimary,
                      size: sh * 0.026,
                    ),
                    SizedBox(width: sh * 0.010),
                    Text(
                      'التقط صورة',
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

// ── Icon Button ───────────────────────────────────────────────────────────────

class _IconButton extends StatefulWidget {
  const _IconButton({required this.id, required this.icon, required this.onTap});
  final String id;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
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
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          key: ValueKey(widget.id),
          width: sh * 0.068,
          height: sh * 0.068,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(widget.icon, color: AppColors.textPrimary, size: sh * 0.026),
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
        horizontal: sh * 0.014,
        vertical: sh * 0.006,
      ),
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
          color: AppColors.textSecondary,
        ),
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
        child: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textPrimary,
          size: sh * 0.028,
        ),
      ),
    );
  }
}

// ── Primary Button ────────────────────────────────────────────────────────────

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.id,
    required this.label,
    required this.onPressed,
  });
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
                offset: const Offset(0, 6),
              ),
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
