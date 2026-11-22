import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

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
                    'الشروط والأحكام',
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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.024),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: sh * 0.015),

                    _SectionCard(
                      sh: sh,
                      title: '1. شروط الاستخدام والسلامة',
                      content:
                          'يجب أن يكون عمر الراكب 18 عاماً فأكثر وأن يحمل بطاقة رقم قومي سارية. يُنصح بشدة بارتداء خوذة واقية أثناء القيادة والالتزام بقواعد المرور المحلية.',
                    ),
                    _SectionCard(
                      sh: sh,
                      title: '2. قواعد الركن ومناطق الخدمة',
                      content:
                          'يُحظر ركن السكوتر في الأماكن المغلقة، المداخل العامة، أو أمام مسارات الطوارئ وذوي الاحتياجات الخاصة. الركن في منطقة محظورة قد يعرض الحساب لغرامات إدارية.',
                    ),
                    _SectionCard(
                      sh: sh,
                      title: '3. الأسعار والمدفوعات',
                      content:
                          'تخضع رسوم فتح القفل وسعر الدقيقة للمعدلات المعلنة بالتطبيق وقت بدء الرحلة. يتم خصم الرصيد تلقائياً من وسيلة الدفع الافتراضية عند إنهاء الرحلة.',
                    ),
                    _SectionCard(
                      sh: sh,
                      title: '4. سياسة الخصوصية وحماية البيانات',
                      content:
                          'نلتزم بحماية بياناتك الشخصية وبيانات الموقع الجغرافي واستخدامها فقط لغرض تحسين تجربة الركوب وتقديم الدعم الفني دون مشاركتها مع أطراف ثالثة.',
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.sh,
    required this.title,
    required this.content,
  });

  final double sh;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(sh * 0.020),
      decoration: BoxDecoration(
        color: const Color(0xFF132225),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: sh * 0.018,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: sh * 0.008),
          Text(
            content,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: sh * 0.015,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

