import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _methods = [
    {
      'id': 'visa_4521',
      'title': 'بطاقة بنكية',
      'subtitle': '•••• 4521',
      'isDefault': true,
      'isVisa': true,
    },
    {
      'id': 'vf_cash',
      'title': 'Vodafone Cash',
      'subtitle': '+20 123 456 7890',
      'isDefault': false,
      'isVodafone': true,
    },
  ];

  void _showAddPaymentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF132225),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'إضافة طريقة دفع جديدة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              tileColor: const Color(0xFF192D31),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: const Icon(Icons.credit_card_rounded, color: AppColors.primary),
              title: const Text(
                'بطاقة بنكية (Visa / MasterCard)',
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600, color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('شاشة ربط البطاقة البنكية ستتوفر قريباً.', style: TextStyle(fontFamily: 'Cairo'))),
                );
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              tileColor: const Color(0xFF192D31),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: const Icon(Icons.phone_android_rounded, color: Color(0xFFE60000)),
              title: const Text(
                'محفظة إلكترونية (Vodafone Cash / InstaPay)',
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600, color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('شاشة ربط المحافظ ستتوفر قريباً.', style: TextStyle(fontFamily: 'Cairo'))),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _setAsDefault() {
    setState(() {
      for (int i = 0; i < _methods.length; i++) {
        _methods[i]['isDefault'] = (i == _selectedIndex);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تعيين طريقة الدفع كافتراضية.', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteMethod() {
    if (_methods.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب أن تحتفظ بطريقة دفع واحدة على الأقل.', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() {
      _methods.removeAt(_selectedIndex);
      _selectedIndex = 0;
      _methods[0]['isDefault'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حذف طريقة الدفع.', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
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
                    'طرق الدفع',
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

            // ── Content ──────────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.024),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: sh * 0.020),

                    // Section Heading
                    Text(
                      'بطاقاتك المحفوظة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: sh * 0.017,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: sh * 0.016),

                    // Methods List
                    ...List.generate(_methods.length, (index) {
                      final item = _methods[index];
                      final isSelected = _selectedIndex == index;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: EdgeInsets.symmetric(
                            horizontal: sh * 0.020,
                            vertical: sh * 0.018,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF132225),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: isSelected ? 1.8 : 1.1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withAlpha(40),
                                      blurRadius: 14,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            children: [
                              // Selection Radio Circle
                              Container(
                                width: sh * 0.026,
                                height: sh * 0.026,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.circle,
                                        size: sh * 0.012,
                                        color: AppColors.textOnPrimary,
                                      )
                                    : null,
                              ),

                              const Spacer(),

                              // Details & Default Tag
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (item['isDefault'] == true) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          margin: const EdgeInsets.only(left: 8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withAlpha(25),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              color: AppColors.primary.withAlpha(80),
                                            ),
                                          ),
                                          child: Text(
                                            'افتراضية',
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: sh * 0.013,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                      Text(
                                        item['title'] as String,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: sh * 0.018,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: sh * 0.004),
                                  Text(
                                    item['subtitle'] as String,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: sh * 0.015,
                                      color: AppColors.textSecondary,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: sh * 0.016),

                              // Provider Icon
                              Container(
                                width: sh * 0.052,
                                height: sh * 0.052,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF192D31),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: item['isVodafone'] == true
                                    ? Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFE60000),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.phone_android_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 14,
                                            height: 14,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFEB001B),
                                            ),
                                          ),
                                          Transform.translate(
                                            offset: const Offset(-4, 0),
                                            child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color(0xFFF79E1B)
                                                    .withAlpha(220),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const Spacer(),

                    // ── Add Payment Method Button ────────────────────────────
                    GestureDetector(
                      onTap: _showAddPaymentSheet,
                      child: Container(
                        width: double.infinity,
                        height: sh * 0.066,
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
                        alignment: Alignment.center,
                        child: Text(
                          'إضافة طريقة دفع',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: sh * 0.020,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: sh * 0.016),

                    // ── Delete / Set as Default Row ──────────────────────────
                    Row(
                      children: [
                        // Delete Button (Red)
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: _deleteMethod,
                            child: Container(
                              height: sh * 0.058,
                              decoration: BoxDecoration(
                                color: AppColors.error.withAlpha(20),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.error.withAlpha(100),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'حذف',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: sh * 0.017,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: sh * 0.014),

                        // Set as Default Button
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: _setAsDefault,
                            child: Container(
                              height: sh * 0.058,
                              decoration: BoxDecoration(
                                color: const Color(0xFF132225),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'تعيين كافتراضية',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: sh * 0.017,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: sh * 0.025),
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

