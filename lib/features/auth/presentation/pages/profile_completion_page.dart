import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';

class ProfileCompletionPage extends StatefulWidget {
  const ProfileCompletionPage({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<ProfileCompletionPage> createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends State<ProfileCompletionPage>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

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

    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue => _nameController.text.trim().isNotEmpty;

  void _continue() {
    if (!_canContinue) return;
    // TODO: Navigate to home when home page is ready
    context.go(AppRoutes.onboarding);
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
                      padding:
                          EdgeInsets.symmetric(horizontal: sh * 0.032),
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: sh * 0.03),

                          // ── Avatar ────────────────────────────────────────
                          _AvatarPicker(size: sh * 0.13),

                          SizedBox(height: sh * 0.03),

                          // ── Title ─────────────────────────────────────────
                          Text(
                            'أكمل ملفك الشخصي',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.030,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: sh * 0.006),
                          Text(
                            'ساعدنا نتعرفك بشكل أفضل',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: sh * 0.017,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          SizedBox(height: sh * 0.04),

                          // ── Name field ────────────────────────────────────
                          _LabeledField(
                            label: 'الاسم',
                            hint: 'أدخل اسمك الكامل',
                            controller: _nameController,
                            focusNode: _nameFocus,
                            keyboardType: TextInputType.name,
                            onSubmitted: (_) =>
                                _emailFocus.requestFocus(),
                          ),

                          SizedBox(height: sh * 0.022),

                          // ── Phone field (read-only) ────────────────────────
                          _LabeledField(
                            label: 'رقم الهاتف',
                            hint: widget.phoneNumber,
                            controller: TextEditingController(
                              text: widget.phoneNumber,
                            ),
                            focusNode: FocusNode(),
                            readOnly: true,
                          ),

                          SizedBox(height: sh * 0.022),

                          // ── Email field ───────────────────────────────────
                          _LabeledField(
                            label: 'البريد الإلكتروني (اختياري)',
                            hint: 'example@email.com',
                            controller: _emailController,
                            focusNode: _emailFocus,
                            keyboardType: TextInputType.emailAddress,
                            onSubmitted: (_) =>
                                FocusScope.of(context).unfocus(),
                          ),

                          SizedBox(height: sh * 0.04),

                          // ── Continue button ───────────────────────────────
                          _PrimaryButton(
                            id: 'btn_continue',
                            label: 'متابعة',
                            enabled: _canContinue,
                            onPressed: _continue,
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

// ── Avatar Picker ─────────────────────────────────────────────────────────────

class _AvatarPicker extends StatefulWidget {
  const _AvatarPicker({required this.size});

  final double size;

  @override
  State<_AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<_AvatarPicker> {
  bool _hasImage = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.size;

    return GestureDetector(
      onTap: () {
        // TODO: image picker
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Avatar circle
          Container(
            width: s,
            height: s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(25),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.person_rounded,
              color: AppColors.textSecondary,
              size: s * 0.55,
            ),
          ),

          // Camera badge
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: s * 0.32,
              height: s * 0.32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.background,
                  width: 2.5,
                ),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                color: AppColors.textOnPrimary,
                size: s * 0.17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Labeled Field ─────────────────────────────────────────────────────────────

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.focusNode,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final bool readOnly;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: sh * 0.016,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: sh * 0.008),

        // Input
        Container(
          height: sh * 0.072,
          decoration: BoxDecoration(
            color: readOnly
                ? AppColors.surface.withAlpha(180)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: readOnly ? AppColors.border.withAlpha(120) : AppColors.border,
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            readOnly: readOnly,
            textAlign: TextAlign.right,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: sh * 0.019,
              fontWeight: FontWeight.w500,
              color: readOnly ? AppColors.textSecondary : AppColors.textPrimary,
              letterSpacing: readOnly ? 1.0 : 0,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: 'Cairo',
                fontSize: sh * 0.018,
                color: AppColors.textDisabled,
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: sh * 0.018),
            ),
            onSubmitted: onSubmitted,
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
      onTapDown:
          widget.enabled ? (_) => setState(() => _pressed = true) : null,
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
