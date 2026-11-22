import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/scooter_model.dart';

/// Screen 5: Payment method selection.
class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key, required this.scooter});
  final ScooterModel scooter;

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage>
    with SingleTickerProviderStateMixin {
  int _selectedMethod = 0;
  late AnimationController _ctrl;
  late Animation<double> _fade;

  static const _methods = [
    (Icons.account_balance_wallet_rounded, 'المحفظة', 'الرصيد الحالي 5 ج.م'),
    (Icons.credit_card_rounded, 'بطاقة بنكية', '**** 4521'),
    (Icons.phone_android_rounded, 'Vodafone Cash', '+20 10xxxxxxxx'),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400))
      ..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fade,
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ───────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.024)
                    .copyWith(top: sh * 0.012),
                child: Row(
                  children: [
                    _BackBtn(onTap: () => context.pop()),
                    const Spacer(),
                    Text('وسيلة الدفع',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: sh * 0.022,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    const Spacer(),
                    SizedBox(width: sh * 0.050),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: sh * 0.024),
                  child: Column(
                    children: [
                      SizedBox(height: sh * 0.028),

                      // ── Amount summary ──────────────────────────────────
                      Container(
                        padding: EdgeInsets.all(sh * 0.018),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(10),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.primary.withAlpha(50)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.scooter.pricePerMinute.toStringAsFixed(1)} ج.م/دقيقة',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: sh * 0.022,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary),
                            ),
                            Text('رسوم الرحلة',
                                style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: sh * 0.016,
                                    color: Colors.white70)),
                          ],
                        ),
                      ),

                      SizedBox(height: sh * 0.028),

                      // ── Payment methods ──────────────────────────────────
                      ...List.generate(_methods.length, (i) {
                        final m = _methods[i];
                        final sel = _selectedMethod == i;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedMethod = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.only(bottom: sh * 0.012),
                            padding: EdgeInsets.all(sh * 0.018),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.primary.withAlpha(15)
                                  : const Color(0xFF0D1E22),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: sel
                                    ? AppColors.primary
                                    : const Color(0xFF1E3A40),
                                width: sel ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: sh * 0.028,
                                  height: sh * 0.028,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: sel
                                          ? AppColors.primary
                                          : const Color(0xFF2A4A52),
                                      width: 2,
                                    ),
                                    color: sel
                                        ? AppColors.primary
                                        : Colors.transparent,
                                  ),
                                  child: sel
                                      ? Icon(Icons.check_rounded,
                                          color: const Color(0xFF091215),
                                          size: sh * 0.018)
                                      : null,
                                ),
                                SizedBox(width: sh * 0.014),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(m.$2,
                                        style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: sh * 0.017,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white)),
                                    Text(m.$3,
                                        style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: sh * 0.013,
                                            color: const Color(0xFF4A7A84))),
                                  ],
                                ),
                                const Spacer(),
                                Icon(m.$1,
                                    color: sel
                                        ? AppColors.primary
                                        : const Color(0xFF2A4A52),
                                    size: sh * 0.032),
                              ],
                            ),
                          ),
                        );
                      }),

                      SizedBox(height: sh * 0.010),

                      // ── Add new method ───────────────────────────────────
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(sh * 0.016),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF1E3A40),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline_rounded,
                                  color: const Color(0xFF4A7A84),
                                  size: sh * 0.024),
                              SizedBox(width: sh * 0.010),
                              Text('إضافة وسيلة دفع جديدة',
                                  style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: sh * 0.016,
                                      color: const Color(0xFF4A7A84))),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: sh * 0.030),
                    ],
                  ),
                ),
              ),

              // ── Confirm button ────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.024)
                    .copyWith(bottom: sh * 0.020 + bottom),
                child: _PrimaryBtn(
                  id: 'btn_confirm_payment',
                  label: 'متابعة الدفع',
                  onTap: () =>
                      context.push(AppRoutes.qrScan, extra: widget.scooter),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  const _BackBtn({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: sh * 0.050,
        height: sh * 0.050,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1E22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E3A40)),
        ),
        child: Icon(Icons.chevron_right_rounded,
            color: Colors.white, size: sh * 0.026),
      ),
    );
  }
}

class _PrimaryBtn extends StatefulWidget {
  const _PrimaryBtn(
      {required this.id, required this.label, required this.onTap});
  final String id, label;
  final VoidCallback onTap;

  @override
  State<_PrimaryBtn> createState() => _PrimaryBtnState();
}

class _PrimaryBtnState extends State<_PrimaryBtn> {
  bool _p = false;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTapDown: (_) => setState(() => _p = true),
      onTapUp: (_) {
        setState(() => _p = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _p = false),
      child: AnimatedScale(
        scale: _p ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          key: ValueKey(widget.id),
          width: double.infinity,
          height: sh * 0.066,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withAlpha(80),
                  blurRadius: 18,
                  offset: const Offset(0, 5)),
            ],
          ),
          alignment: Alignment.center,
          child: Text(widget.label,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: sh * 0.019,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF091215))),
        ),
      ),
    );
  }
}
