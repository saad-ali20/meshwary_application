import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../auth/data/repositories/auth_repository.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final _nameController = TextEditingController(text: 'Saad Ali');
  final _phoneController = TextEditingController(text: '01016811270');
  final _emailController = TextEditingController(text: 'sa3167364@gmail.com');

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await getIt<AuthRepository>().loadCachedUser();
    if (user != null && mounted) {
      setState(() {
        if (user.fullName.isNotEmpty) _nameController.text = user.fullName;
        if (user.phoneNumber.isNotEmpty) {
          _phoneController.text = user.phoneNumber;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.textOnPrimary),
            SizedBox(width: 8),
            Text(
              'تم حفظ التغييرات بنجاح.',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                color: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sh * 0.024,
                vertical: sh * 0.012,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: sh * 0.048,
                      height: sh * 0.048,
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.textPrimary,
                        size: sh * 0.028,
                      ),
                    ),
                  ),
                  Text(
                    'البيانات الشخصية',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: sh * 0.024,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: sh * 0.048),
                ],
              ),
            ),

            // ── Body ─────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.028),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: sh * 0.025),

                    // Avatar with Camera Badge
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: sh * 0.130,
                          height: sh * 0.130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF132225),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(50),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            color: AppColors.primary,
                            size: sh * 0.085,
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: sh * 0.008,
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'ميزة تحديث الصورة الشخصية قيد التطوير.',
                                    style: TextStyle(fontFamily: 'Cairo'),
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              width: sh * 0.040,
                              height: sh * 0.040,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.background,
                                  width: 2.2,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_rounded,
                                color: AppColors.textOnPrimary,
                                size: sh * 0.022,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: sh * 0.040),

                    // ── Full Name Field ──────────────────────────────────────
                    _ProfileTextField(
                      label: 'الاسم',
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                    ),

                    SizedBox(height: sh * 0.022),

                    // ── Phone Number Field ───────────────────────────────────
                    _ProfileTextField(
                      label: 'رقم الهاتف',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      readOnly: true,
                    ),

                    SizedBox(height: sh * 0.022),

                    // ── Email Field ──────────────────────────────────────────
                    _ProfileTextField(
                      label: 'البريد الإلكتروني',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: sh * 0.045),

                    // ── Save Button ──────────────────────────────────────────
                    GestureDetector(
                      onTap: _isSaving ? null : _saveChanges,
                      child: Container(
                        width: double.infinity,
                        height: sh * 0.066,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(90),
                              blurRadius: 18,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: _isSaving
                            ? SizedBox(
                                width: sh * 0.028,
                                height: sh * 0.028,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.textOnPrimary,
                                ),
                              )
                            : Text(
                                'حفظ التغييرات',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: sh * 0.020,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: sh * 0.030),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.label,
    required this.controller,
    required this.keyboardType,
    this.readOnly = false,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool readOnly;

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
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: sh * 0.008),
        Container(
          height: sh * 0.068,
          decoration: BoxDecoration(
            color: const Color(0xFF132225),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: readOnly
                  ? AppColors.border.withAlpha(120)
                  : AppColors.border,
              width: 1.2,
            ),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: sh * 0.020),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: sh * 0.019,
              fontWeight: FontWeight.w600,
              color: readOnly ? AppColors.textSecondary : AppColors.textPrimary,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
