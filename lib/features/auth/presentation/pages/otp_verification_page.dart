import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage>
    with SingleTickerProviderStateMixin {
  static const int _otpLength = 6;
  static const int _timerSeconds = 45;

  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  Timer? _timer;
  int _secondsLeft = _timerSeconds;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));
    _startTimer();

    // Listen to all controllers
    for (final c in _controllers) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = _timerSeconds;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _canResend = true;
          t.cancel();
        }
      });
    });
  }

  String get _timerText {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _otpValue => _controllers.map((c) => c.text).join();

  bool get _otpComplete => _otpValue.length == _otpLength;

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _verifyOtp() {
    if (!_otpComplete) return;
    context.push(AppRoutes.profileCompletion, extra: widget.phoneNumber);
  }

  void _resendCode() {
    if (!_canResend) return;
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Column(
                children: [
                  // ── Back button ────────────────────────────────────────────
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: sh * 0.01,
                        right: sh * 0.018,
                      ),
                      child: _BackButton(onTap: () => context.pop()),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: sh * 0.032),
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: sh * 0.04),

                          // ── Illustration ─────────────────────────────────
                          _OtpIllustration(size: sh * 0.18),

                          SizedBox(height: sh * 0.038),

                          // ── Title ────────────────────────────────────────
                          Text(
                            'أدخل كود التحقق',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.030,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          SizedBox(height: sh * 0.01),

                          // ── Subtitle ─────────────────────────────────────
                          Text(
                            'تم إرسال كود مكون من 6 أرقام إلى',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.017,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: sh * 0.004),
                          Text(
                            widget.phoneNumber,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.02,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: 1.4,
                            ),
                          ),

                          SizedBox(height: sh * 0.04),

                          // ── OTP boxes ────────────────────────────────────
                          _OtpBoxes(
                            controllers: _controllers,
                            focusNodes: _focusNodes,
                            onChanged: _onOtpChanged,
                          ),

                          SizedBox(height: sh * 0.032),

                          // ── Timer ────────────────────────────────────────
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _canResend
                                ? const SizedBox.shrink()
                                : Text(
                                    'سيتم إعادة إرسال الكود خلال $_timerText',
                                    key: const ValueKey('timer'),
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: sh * 0.016,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                          ),

                          SizedBox(height: sh * 0.018),

                          // ── Resend & change number ───────────────────────
                          _TextLinkButton(
                            id: 'btn_resend',
                            label: 'إعادة إرسال الكود',
                            enabled: _canResend,
                            onTap: _resendCode,
                          ),
                          SizedBox(height: sh * 0.01),
                          _TextLinkButton(
                            id: 'btn_change_phone',
                            label: 'تغيير رقم الهاتف',
                            enabled: true,
                            onTap: () => context.pop(),
                          ),

                          SizedBox(height: sh * 0.038),

                          // ── Verify button ────────────────────────────────
                          _PrimaryButton(
                            id: 'btn_verify_otp',
                            label: 'تحقق',
                            enabled: _otpComplete,
                            onPressed: _verifyOtp,
                          ),

                          SizedBox(height: sh * 0.04 + bottom),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── OTP Illustration ──────────────────────────────────────────────────────────

class _OtpIllustration extends StatelessWidget {
  const _OtpIllustration({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.primary.withAlpha(40), Colors.transparent],
              ),
            ),
          ),
          // Inner circle
          Container(
            width: size * 0.7,
            height: size * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppColors.primary,
              size: size * 0.35,
            ),
          ),
          // Sparkles
          Positioned(
            top: size * 0.06,
            right: size * 0.1,
            child: _Sparkle(size: size * 0.08),
          ),
          Positioned(
            bottom: size * 0.1,
            left: size * 0.05,
            child: _Sparkle(size: size * 0.06),
          ),
        ],
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.add, color: AppColors.primary.withAlpha(160), size: size);
  }
}

// ── OTP Boxes ─────────────────────────────────────────────────────────────────

class _OtpBoxes extends StatelessWidget {
  const _OtpBoxes({
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(int index, String value) onChanged;

  @override
  Widget build(BuildContext context) {
    const gapCount = 5; // فراغات بين 6 مربعات
    const gapWidth = 8.0;
    const totalGaps = gapCount * gapWidth;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxSize =
              (constraints.maxWidth - totalGaps) / controllers.length;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(controllers.length, (i) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _OtpBox(
                    controller: controllers[i],
                    focusNode: focusNodes[i],
                    size: boxSize,
                    onChanged: (v) => onChanged(i, v),
                    onBackspace: () {
                      if (controllers[i].text.isEmpty && i > 0) {
                        focusNodes[i - 1].requestFocus();
                      }
                    },
                  ),
                  if (i < controllers.length - 1)
                    const SizedBox(width: gapWidth),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.size,
    required this.onChanged,
    required this.onBackspace,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final double size;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    final isFilled = controller.text.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isFilled ? AppColors.primary.withAlpha(20) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFilled ? AppColors.primary : AppColors.border,
          width: isFilled ? 1.5 : 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (v) {
          if (v.length > 1) {
            controller.text = v[v.length - 1];
            controller.selection = TextSelection.collapsed(
              offset: controller.text.length,
            );
          }
          onChanged(v.isEmpty ? '' : controller.text);
        },
      ),
    );
  }
}

// ── Text Link Button ──────────────────────────────────────────────────────────

class _TextLinkButton extends StatelessWidget {
  const _TextLinkButton({
    required this.id,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String id;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    return GestureDetector(
      key: ValueKey(id),
      onTap: enabled ? onTap : null,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: sh * 0.017,
          fontWeight: FontWeight.w600,
          color: enabled ? AppColors.primary : AppColors.textDisabled,
          decoration: TextDecoration.underline,
          decorationColor: enabled ? AppColors.primary : AppColors.textDisabled,
        ),
        child: Text(label),
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
          border: Border.all(color: AppColors.border, width: 1),
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
