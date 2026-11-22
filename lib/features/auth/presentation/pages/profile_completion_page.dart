import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di/injection.dart';
import '../../../../app/router/routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/auth_repository.dart';

class ProfileCompletionPage extends StatefulWidget {
  const ProfileCompletionPage({
    super.key,
    required this.phoneNumber,
    this.verificationToken = '',
  });

  final String phoneNumber;
  final String verificationToken;

  @override
  State<ProfileCompletionPage> createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends State<ProfileCompletionPage>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));

    _nameController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  bool get _isNameValid => _nameController.text.trim().length >= 2;
  bool get _isPasswordValid => _passwordController.text.length >= 6;
  bool get _doPasswordsMatch =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  bool get _canSubmit =>
      _isNameValid &&
      _isPasswordValid &&
      _confirmPasswordController.text.isNotEmpty &&
      !_isLoading;

  Future<void> _submitRegistration() async {
    if (!_canSubmit) return;

    final fullName = _nameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      _showErrorSnackBar('كلمتا المرور غير متطابقتين، يرجى التأكد وإعادة المحاولة.');
      return;
    }

    if (widget.verificationToken.isEmpty) {
      _showErrorSnackBar('رمز التحقق مفقود، يرجى العودة وطلب كود تحقق جديد.');
      return;
    }

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      await getIt<AuthRepository>().register(
        verificationToken: widget.verificationToken,
        fullName: fullName,
        password: password,
      );

      if (!mounted) return;

      _showSuccessSnackBar('تم إنشاء الحساب بنجاح! مرحباً بك يا $fullName');

      // Navigate directly to Home
      context.go(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      final message = e is AppException
          ? e.message
          : 'تعذر إنشاء الحساب. يرجى التأكد من البيانات والمحاولة مجدداً.';
      _showErrorSnackBar(message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                color: AppColors.textOnPrimary, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
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
                  // ── Top Bar ──────────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sh * 0.024,
                      vertical: sh * 0.012,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _BackButton(onTap: () => context.pop()),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: sh * 0.016,
                            vertical: sh * 0.007,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withAlpha(80),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'الخطوة الأخيرة',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: sh * 0.014,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Scrollable Body ──────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: sh * 0.032),
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: sh * 0.015),

                          // ── Header Icon Badge ────────────────────────────
                          Container(
                            width: sh * 0.11,
                            height: sh * 0.11,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surface,
                              border: Border.all(
                                color: AppColors.primary.withAlpha(100),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(40),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person_add_alt_1_rounded,
                              color: AppColors.primary,
                              size: sh * 0.052,
                            ),
                          ),

                          SizedBox(height: sh * 0.024),

                          // ── Title & Subtitle ─────────────────────────────
                          Text(
                            'إكمال بيانات الحساب',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.028,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: sh * 0.006),
                          Text(
                            'أدخل اسمك الكامل وكلمة المرور لتأمين حسابك',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.016,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          SizedBox(height: sh * 0.025),

                          // ── Verified Phone Card ───────────────────────────
                          _VerifiedPhoneCard(
                            phoneNumber: widget.phoneNumber,
                            sh: sh,
                          ),

                          SizedBox(height: sh * 0.024),

                          // ── Full Name Field ──────────────────────────────
                          _CustomInputField(
                            label: 'الاسم بالكامل',
                            hint: 'مثال: أحمد محمد علي',
                            controller: _nameController,
                            focusNode: _nameFocus,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.badge_outlined,
                            onSubmitted: (_) =>
                                _passwordFocus.requestFocus(),
                          ),

                          SizedBox(height: sh * 0.020),

                          // ── Password Field ───────────────────────────────
                          _CustomInputField(
                            label: 'كلمة المرور',
                            hint: '8 أحرف على الأقل (أرقام وحروف)',
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.lock_outline_rounded,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                                size: sh * 0.024,
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                            onSubmitted: (_) =>
                                _confirmPasswordFocus.requestFocus(),
                          ),

                          SizedBox(height: sh * 0.020),

                          // ── Confirm Password Field ────────────────────────
                          _CustomInputField(
                            label: 'تأكيد كلمة المرور',
                            hint: 'أعد إدخال كلمة المرور',
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            obscureText: _obscureConfirmPassword,
                            textInputAction: TextInputAction.done,
                            prefixIcon: Icons.lock_reset_rounded,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                                size: sh * 0.024,
                              ),
                              onPressed: () => setState(() =>
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword),
                            ),
                            onSubmitted: (_) => _submitRegistration(),
                          ),

                          if (_confirmPasswordController.text.isNotEmpty) ...[
                            SizedBox(height: sh * 0.010),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  _doPasswordsMatch
                                      ? 'كلمتا المرور متطابقتان'
                                      : 'كلمتا المرور غير متطابقتين',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: sh * 0.014,
                                    fontWeight: FontWeight.w600,
                                    color: _doPasswordsMatch
                                        ? AppColors.primary
                                        : AppColors.error,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  _doPasswordsMatch
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  size: sh * 0.018,
                                  color: _doPasswordsMatch
                                      ? AppColors.primary
                                      : AppColors.error,
                                ),
                              ],
                            ),
                          ],

                          SizedBox(height: sh * 0.034),

                          // ── Submit Button ────────────────────────────────
                          _PrimaryButton(
                            id: 'btn_register_submit',
                            label: 'إنشاء الحساب ومتابعة',
                            enabled: _canSubmit,
                            isLoading: _isLoading,
                            onPressed: _submitRegistration,
                          ),

                          SizedBox(height: sh * 0.03 + bottom),
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

// ── Verified Phone Card ───────────────────────────────────────────────────────

class _VerifiedPhoneCard extends StatelessWidget {
  const _VerifiedPhoneCard({
    required this.phoneNumber,
    required this.sh,
  });

  final String phoneNumber;
  final double sh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sh * 0.020,
        vertical: sh * 0.014,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: Row(
        children: [
          // Verified Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: sh * 0.012,
              vertical: sh * 0.005,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: AppColors.primary,
                  size: sh * 0.018,
                ),
                SizedBox(width: sh * 0.005),
                Text(
                  'تم التحقق',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: sh * 0.014,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            phoneNumber,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: sh * 0.019,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(width: sh * 0.010),
          Text('🇪🇬', style: TextStyle(fontSize: sh * 0.022)),
        ],
      ),
    );
  }
}

// ── Custom Input Field ────────────────────────────────────────────────────────

class _CustomInputField extends StatelessWidget {
  const _CustomInputField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: sh * 0.016,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: sh * 0.008),
        Container(
          height: sh * 0.070,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 1.2),
          ),
          child: Row(
            children: [
              ?suffixIcon,
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  obscureText: obscureText,
                  textAlign: TextAlign.right,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: sh * 0.019,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: sh * 0.016,
                      color: AppColors.textDisabled,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: sh * 0.018,
                    ),
                  ),
                  onSubmitted: onSubmitted,
                ),
              ),
              if (prefixIcon != null) ...[
                Padding(
                  padding: EdgeInsets.only(right: sh * 0.016),
                  child: Icon(
                    prefixIcon,
                    color: AppColors.textSecondary,
                    size: sh * 0.024,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
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
                    width: sh * 0.030,
                    height: sh * 0.030,
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
