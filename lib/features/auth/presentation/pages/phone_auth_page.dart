import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di/injection.dart';
import '../../../../app/router/routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/auth_repository.dart';

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
  bool _isLoading = false;

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

  bool get _canSubmit => _isValidEgyptianPhone && !_isLoading;

  Future<void> _sendOtp() async {
    if (!_canSubmit) return;
    final phone = _phoneController.text.trim();

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      await getIt<AuthRepository>().requestOtp(phone);
      if (!mounted) return;
      context.push(AppRoutes.otpVerification, extra: phone);
    } catch (e) {
      if (!mounted) return;
      final message = e is AppException
          ? e.message
          : 'تعذر إرسال كود التحقق. يرجى التأكد من الرقم وإعادة المحاولة.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.030),
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: sh * 0.02),

                            // ── Logo ────────────────────────────────────────────────
                            Image.asset(
                              'assets/images/meshwary_logo.png',
                              height: sh * 0.240,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: sh * 0.020),

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
                              isLoading: _isLoading,
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

                            SizedBox(height: sh * 0.02 + bottom),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
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
    this.isLoading = false,
  });

  final String id;
  final String label;
  final VoidCallback onPressed;
  final bool enabled;
  final bool isLoading;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final active = widget.enabled && !widget.isLoading;

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
            child: widget.isLoading
                ? SizedBox(
                    width: sh * 0.03,
                    height: sh * 0.03,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.textOnPrimary,
                    ),
                  )
                : Text(
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


