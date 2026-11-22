import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  static const _faqs = [
    (
      'كيف أبدأ رحلة سكوتر؟',
      'قم بمسح رمز QR الموجود على المقود واضغط على "بدء الرحلة"، ثم ادفع السكوتر بقدمك واضغط على دواسة السرعة.'
    ),
    (
      'كيف يتم حساب تكلفة الرحلة؟',
      'يتم احتساب رسوم فتح القفل بالإضافة إلى تكلفة محددة لكل دقيقة استخدام، وتُخصم تلقائياً من محفظتك أو بطاقتك.'
    ),
    (
      'أين يمكنني إنهاء الرحلة وركن السكوتر؟',
      'يمكنك ركن السكوتر في أي منطقة مسموحة بالركن داخل النطاق الجغرافي المحدد بالخريطة، دون إعاقة المشاة أو المرور.'
    ),
    (
      'ماذا أفعل في حالة نفاد بطارية السكوتر؟',
      'يرجى ركن السكوتر بأمان وإنهاء الرحلة عبر التطبيق، ويمكنك استئجار سكوتر آخر قريب منك فوراً.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
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
                    'مركز المساعدة',
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

            // Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.024),
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(height: sh * 0.015),

                  // Quick support contact banner
                  Container(
                    padding: EdgeInsets.all(sh * 0.020),
                    decoration: BoxDecoration(
                      color: const Color(0xFF132225),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withAlpha(90)),
                    ),
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            final uri = Uri.parse('tel:01016811270');
                            if (await canLaunchUrl(uri)) await launchUrl(uri);
                          },
                          icon: const Icon(Icons.headset_mic_rounded, size: 18),
                          label: const Text(
                            'اتصل بالدعم',
                            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'هل تواجه مشكلة؟',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: sh * 0.017,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'فريق الدعم متاح 24/7',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: sh * 0.014,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: sh * 0.028),

                  Text(
                    'الأسئلة الشائعة',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: sh * 0.020,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: sh * 0.014),

                  ..._faqs.map((faq) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF132225),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Theme(
                          data: ThemeData(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            iconColor: AppColors.primary,
                            collapsedIconColor: AppColors.textSecondary,
                            title: Text(
                              faq.$1,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: sh * 0.016,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  sh * 0.020,
                                  0,
                                  sh * 0.020,
                                  sh * 0.020,
                                ),
                                child: Text(
                                  faq.$2,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: sh * 0.015,
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),

                  SizedBox(height: sh * 0.025),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

