import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di/injection.dart';
import '../../../../app/router/routes.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
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

    // Pre-fill phone if saved previously
    final savedPhone = getIt<AuthRepository>().savedPhoneNumber;
    if (savedPhone != null && savedPhone.isNotEmpty) {
      final clean = savedPhone.startsWith('+20')
          ? savedPhone.replaceFirst('+20', '0')
          : savedPhone;
      _phoneController.text = clean;
    }

    _phoneController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  bool get _isValidEgyptianPhone {
    final phone = _phoneController.text.trim();
    if (phone.length != 11) return false;
    return phone.startsWith('010') ||
        phone.startsWith('011') ||
        phone.startsWith('012') ||
        phone.startsWith('015');
  }

  bool get _canSubmit =>
      _isValidEgyptianPhone &&
      _passwordController.text.length >= 6 &&
      !_isLoading;

  Future<void> _login() async {
    if (!_canSubmit) return;

    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      final authResponse = await getIt<AuthRepository>().login(
        phoneNumber: phone,
        password: password,
      );

      if (!mounted) return;

      final name = authResponse.user?.fullName ?? '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.textOnPrimary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name.isNotEmpty
                      ? 'مرحباً بعودتك يا $name!'
                      : 'تم تسجيل الدخول بنجاح!',
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate directly to Home
      context.go(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      final message = e is AppException
          ? e.message
          : 'رقم الهاتف أو كلمة المرور غير صحيحة.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 22,
              ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 4),
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

                            // ── Logo ─────────────────────────────────────────
                            Image.asset(
                              'assets/images/meshwary_logo.png',
                              height: sh * 0.220,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: sh * 0.018),

                            // ── Welcome Headline ─────────────────────────────
                            Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: sh * 0.030,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: sh * 0.006),
                            Text(
                              'مرحباً بعودتك! أدخل بياناتك للمتابعة',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: sh * 0.017,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            SizedBox(height: sh * 0.032),

                            // ── Phone Field ──────────────────────────────────
                            _PhoneField(
                              controller: _phoneController,
                              focusNode: _phoneFocus,
                              onSubmitted: (_) => _passwordFocus.requestFocus(),
                            ),

                            SizedBox(height: sh * 0.018),

                            // ── Password Field ───────────────────────────────
                            _PasswordField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              obscureText: _obscurePassword,
                              onToggleVisibility: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              onSubmitted: (_) => _login(),
                            ),

                            SizedBox(height: sh * 0.012),

                            // ── Forgot Password Link ─────────────────────────
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'لاستعادة كلمة المرور، يرجى التواصل مع الدعم الفني.',
                                        style: TextStyle(fontFamily: 'Cairo'),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'نسيت كلمة المرور؟',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: sh * 0.015,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: sh * 0.026),

                            // ── Login Button ─────────────────────────────────
                            _PrimaryLoginButton(
                              label: 'تسجيل الدخول',
                              enabled: _canSubmit,
                              isLoading: _isLoading,
                              onPressed: _login,
                            ),

                            SizedBox(height: sh * 0.028),

                            // ── Register New Account Prompt ──────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      context.push(AppRoutes.phoneAuth),
                                  child: Text(
                                    'إنشاء حساب جديد',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: sh * 0.016,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'ليس لديك حساب؟',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: sh * 0.016,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),

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

// ── Phone Field Widget ────────────────────────────────────────────────────────

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.controller,
    required this.focusNode,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onSubmitted;

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
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: sh * 0.020,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: 1.2,
              ),
              decoration: InputDecoration(
                hintText: 'رقم الهاتف (01xxxxxxxxx)',
                hintStyle: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: sh * 0.017,
                  color: AppColors.textDisabled,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: sh * 0.018),
              ),
              onSubmitted: onSubmitted,
            ),
          ),
          Container(width: 1, height: sh * 0.04, color: AppColors.border),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Password Field Widget ─────────────────────────────────────────────────────

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.focusNode,
    required this.obscureText,
    required this.onToggleVisibility,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final ValueChanged<String>? onSubmitted;

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
          IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSecondary,
              size: sh * 0.024,
            ),
            onPressed: onToggleVisibility,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: obscureText,
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.done,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: sh * 0.019,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'كلمة المرور',
                hintStyle: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: sh * 0.017,
                  color: AppColors.textDisabled,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: sh * 0.018),
              ),
              onSubmitted: onSubmitted,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sh * 0.016),
            child: Icon(
              Icons.lock_outline_rounded,
              color: AppColors.textSecondary,
              size: sh * 0.024,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Primary Button Widget ─────────────────────────────────────────────────────

class _PrimaryLoginButton extends StatefulWidget {
  const _PrimaryLoginButton({
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool enabled;
  final bool isLoading;

  @override
  State<_PrimaryLoginButton> createState() => _PrimaryLoginButtonState();
}

class _PrimaryLoginButtonState extends State<_PrimaryLoginButton> {
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
                      fontSize: sh * 0.020,
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
