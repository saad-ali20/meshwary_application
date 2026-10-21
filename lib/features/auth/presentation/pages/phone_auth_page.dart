import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _phoneFocus = FocusNode();
  bool _agreedToTerms = false;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));
    _fadeCtrl.forward();
    _phoneController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  /// رقم الهاتف المصري: 11 رقم يبدأ بـ 010 أو 011 أو 012 أو 015
  bool get _isValidEgyptianPhone {
    final phone = _phoneController.text.trim();
    if (phone.length != 11) return false;
    return phone.startsWith('010') ||
        phone.startsWith('011') ||
        phone.startsWith('012') ||
        phone.startsWith('015');
  }

  bool get _canSubmit => _isValidEgyptianPhone;

  void _sendOtp() {
    if (!_canSubmit) return;
    final phone = '+20${_phoneController.text.trim()}';
    context.push(AppRoutes.otpVerification, extra: phone);
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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: sh * 0.030),
            physics: const ClampingScrollPhysics(),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: sh * 0.055),

                    // ── Logo ────────────────────────────────────────────────
                    Image.asset(
                      'assets/images/meshwary_logo.png',
                      height: sh * 0.150,
                    ),
                    // SizedBox(height: sh * 0.012),

                    // Text(
                    //   'مشواري',
                    //   style: TextStyle(
                    //     fontFamily: 'Cairo',
                    //     fontSize: sh * 0.036,
                    //     fontWeight: FontWeight.w800,
                    //     color: AppColors.textPrimary,
                    //     height: 1.1,
                    //   ),
                    // ),
                    // Text(
                    //   'سكوتر الصعيد',
                    //   style: TextStyle(
                    //     fontFamily: 'Cairo',
                    //     fontSize: sh * 0.018,
                    //     fontWeight: FontWeight.w600,
                    //     color: AppColors.primary,
                    //     letterSpacing: 0.5,
                    //   ),
                    // ),
                    SizedBox(height: sh * 0.025),

                    // ── Welcome ─────────────────────────────────────────────
                    Text(
                      'مرحباً بك في مشواري',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: sh * 0.028,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: sh * 0.006),
                    Text(
                      'أدخل رقم هاتفك للمتابعة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: sh * 0.017,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: sh * 0.032),

                    // ── Phone field ─────────────────────────────────────────
                    _PhoneField(
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                    ),

                    SizedBox(height: sh * 0.022),

                    // ── Send OTP button ─────────────────────────────────────
                    _PrimaryButton(
                      id: 'btn_send_otp',
                      label: 'إرسال كود التحقق',
                      enabled: _canSubmit,
                      onPressed: _sendOtp,
                    ),

                    SizedBox(height: sh * 0.018),

                    // ── Terms checkbox ──────────────────────────────────────
                    _TermsRow(
                      value: _agreedToTerms,
                      onChanged: (v) =>
                          setState(() => _agreedToTerms = v ?? false),
                    ),

                    SizedBox(height: sh * 0.028),

                    // ── Or divider ──────────────────────────────────────────
                    const _OrDivider(),

                    SizedBox(height: sh * 0.025),

                    // ── Social sign-in ──────────────────────────────────────
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     _SocialButton(
                    //       id: 'btn_google',
                    //       label: 'G',
                    //       labelStyle: TextStyle(
                    //         fontSize: sh * 0.024,
                    //         fontWeight: FontWeight.w700,
                    //         color: AppColors.textPrimary,
                    //       ),
                    //       onPressed: () {},
                    //     ),
                    //     SizedBox(width: sh * 0.018),
                    //     _SocialButton(
                    //       id: 'btn_apple',
                    //       icon: Icons.apple,
                    //       onPressed: () {},
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: sh * 0.04 + bottom),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Phone Field ───────────────────────────────────────────────────────────────

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller, required this.focusNode});

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    return Container(
      height: sh * 0.072,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: Row(
        children: [
          // Number input (RTL: on the right)
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.right,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: sh * 0.02,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: 1.2,
              ),
              decoration: InputDecoration(
                hintText: 'رقم الهاتف',
                hintStyle: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: sh * 0.018,
                  color: AppColors.textDisabled,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: sh * 0.018),
              ),
            ),
          ),

          // Divider
          Container(width: 1, height: sh * 0.04, color: AppColors.border),

          // Country code badge
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sh * 0.015),
            child: Row(
              children: [
                Text('🇪🇬', style: TextStyle(fontSize: sh * 0.022)),
                SizedBox(width: sh * 0.006),
                Text(
                  '+20',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: sh * 0.018,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(width: sh * 0.004),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                  size: sh * 0.022,
                ),
              ],
            ),
          ),
        ],
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
    final active = widget.enabled;

    return GestureDetector(
      onTapDown: active ? (_) => setState(() => _pressed = true) : null,
      onTapUp: active
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
          opacity: active ? 1.0 : 0.45,
          duration: const Duration(milliseconds: 200),
          child: Container(
            key: ValueKey(widget.id),
            width: double.infinity,
            height: sh * 0.068,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
              boxShadow: active
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

// ── Terms Row ─────────────────────────────────────────────────────────────────

class _TermsRow extends StatelessWidget {
  const _TermsRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Custom checkbox
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: sh * 0.026,
            height: sh * 0.026,
            decoration: BoxDecoration(
              color: value ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? AppColors.primary : AppColors.border,
                width: 1.5,
              ),
            ),
            child: value
                ? Icon(
                    Icons.check_rounded,
                    size: sh * 0.018,
                    color: AppColors.textOnPrimary,
                  )
                : null,
          ),
        ),
        SizedBox(width: sh * 0.01),
        Flexible(
          child: Text.rich(
            TextSpan(
              text: 'بتسجيلك توافق على ',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: sh * 0.015,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(
                  text: 'الشروط والأحكام وسياسة الخصوصية',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: sh * 0.015,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// ── Or Divider ────────────────────────────────────────────────────────────────

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.border, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sh * 0.014),
          child: Text(
            'أو',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: sh * 0.016,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.border, thickness: 1)),
      ],
    );
  }
}

// ── Social Button ─────────────────────────────────────────────────────────────

class _SocialButton extends StatefulWidget {
  const _SocialButton({
    required this.id,
    required this.onPressed,
    this.icon,
    this.label,
    this.labelStyle,
  });

  final String id;
  final VoidCallback onPressed;
  final IconData? icon;
  final String? label;
  final TextStyle? labelStyle;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final size = sh * 0.072;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          key: ValueKey(widget.id),
          width: size * 1.4,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 1.2),
          ),
          alignment: Alignment.center,
          child: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: AppColors.textPrimary,
                  size: sh * 0.028,
                )
              : Text(widget.label ?? '', style: widget.labelStyle),
        ),
      ),
    );
  }
}
