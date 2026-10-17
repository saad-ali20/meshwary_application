import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Visual quality checkpoint — demonstrates the Meshwary design system.
/// NOT a production home screen.
class DesignPreviewPage extends StatefulWidget {
  const DesignPreviewPage({super.key});

  @override
  State<DesignPreviewPage> createState() => _DesignPreviewPageState();
}

class _DesignPreviewPageState extends State<DesignPreviewPage> {
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenH,
              vertical: AppSpacing.screenV,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildLogoSection(),
                const SizedBox(height: AppSpacing.xxxl),
                _buildSectionTitle('الألوان'),
                const SizedBox(height: AppSpacing.lg),
                _buildColorPalette(),
                const SizedBox(height: AppSpacing.xxxl),
                _buildSectionTitle('التايبوغرافي'),
                const SizedBox(height: AppSpacing.lg),
                _buildTypography(),
                const SizedBox(height: AppSpacing.xxxl),
                _buildSectionTitle('الأزرار'),
                const SizedBox(height: AppSpacing.lg),
                _buildButtons(),
                const SizedBox(height: AppSpacing.xxxl),
                _buildSectionTitle('حقل الإدخال'),
                const SizedBox(height: AppSpacing.lg),
                _buildInputField(),
                const SizedBox(height: AppSpacing.xxxl),
                _buildSectionTitle('البطاقات والسطوح'),
                const SizedBox(height: AppSpacing.lg),
                _buildCards(),
                const SizedBox(height: AppSpacing.xxxl),
                _buildSectionTitle('الحالات'),
                const SizedBox(height: AppSpacing.lg),
                _buildStatusSection(),
                const SizedBox(height: AppSpacing.massive),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Sliver AppBar ─────────────────────────────────────────────────────────

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 56,
      pinned: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      title: Text('نظام التصميم', style: AppTextStyles.titleMedium),
      actions: [
        Container(
          margin: const EdgeInsets.only(left: AppSpacing.lg),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryGlow,
            borderRadius: AppRadius.pillAll,
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Text(
            'v1.0',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  // ── Logo Section ──────────────────────────────────────────────────────────

  Widget _buildLogoSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.surface, AppColors.card, AppColors.background],
        ),
        borderRadius: AppRadius.xlAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          // Logo mark
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadius.xlAll,
              boxShadow: AppShadows.primaryGlow,
            ),
            child: const Icon(
              Icons.electric_scooter_rounded,
              color: AppColors.textOnPrimary,
              size: 44,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('مشواري', style: AppTextStyles.displayLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'تأجير السكوتر الكهربائي · سوهاج',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatChip(Icons.bolt_rounded, 'سريع', AppColors.primary),
              _buildStatChip(Icons.eco_rounded, 'نظيف', AppColors.info),
              _buildStatChip(Icons.lock_open_rounded, 'سهل', AppColors.warning),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(label, style: AppTextStyles.labelMedium),
      ],
    );
  }

  // ── Color Palette ────────────────────────────────────────────────────────

  Widget _buildColorPalette() {
    final swatches = [
      ('primary', AppColors.primary),
      ('background', AppColors.background),
      ('surface', AppColors.surface),
      ('card', AppColors.card),
      ('textPrimary', AppColors.textPrimary),
      ('textSecondary', AppColors.textSecondary),
      ('error', AppColors.error),
      ('warning', AppColors.warning),
      ('info', AppColors.info),
      ('border', AppColors.border),
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: swatches
          .map((s) => _ColorSwatch(name: s.$1, color: s.$2))
          .toList(),
    );
  }

  // ── Typography ───────────────────────────────────────────────────────────

  Widget _buildTypography() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('عنوان رئيسي كبير', style: AppTextStyles.displayMedium),
          const SizedBox(height: AppSpacing.md),
          Text('عنوان ثانوي', style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          Text('عنوان المقطع', style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          Text(
            'نص أساسي — يُستخدم للمحتوى الرئيسي في التطبيق.',
            style: AppTextStyles.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'نص ثانوي — للتفاصيل والوصف.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('تسمية صغيرة · Label', style: AppTextStyles.labelMedium),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text('السعر: ', style: AppTextStyles.labelLarge),
              Text('٢٠ جنيه', style: AppTextStyles.price),
            ],
          ),
        ],
      ),
    );
  }

  // ── Buttons ──────────────────────────────────────────────────────────────

  Widget _buildButtons() {
    return Column(
      children: [
        AppButton(
          label: 'ابدأ رحلتك الآن',
          onPressed: () {},
          leadingIcon: const Icon(Icons.electric_scooter_rounded, size: 20),
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(label: 'جارٍ المعالجة...', isLoading: true, onPressed: () {}),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'زر ثانوي',
          variant: AppButtonVariant.secondary,
          onPressed: () {},
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'زر بإطار',
          variant: AppButtonVariant.outlined,
          onPressed: () {},
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(label: 'زر معطّل', onPressed: null),
      ],
    );
  }

  // ── Input Field ──────────────────────────────────────────────────────────

  Widget _buildInputField() {
    return Column(
      children: [
        AppTextField(
          label: 'رقم الهاتف',
          hint: '01xxxxxxxxx',
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(Icons.phone_rounded, size: 20),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'كلمة المرور',
          hint: '••••••••',
          obscureText: true,
          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
          suffixIcon: const Icon(Icons.visibility_off_rounded, size: 20),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'حقل بخطأ',
          hint: 'أدخل النص',
          errorText: 'هذا الحقل مطلوب.',
          prefixIcon: const Icon(Icons.warning_amber_rounded, size: 20),
        ),
      ],
    );
  }

  // ── Cards ────────────────────────────────────────────────────────────────

  Widget _buildCards() {
    return Column(
      children: [
        AppCard(
          onTap: () {},
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGlow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.electric_scooter_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('سكوتر #MSH-042', style: AppTextStyles.titleSmall),
                    Text('متاح · البطارية ٨٧٪', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successSurface,
                  borderRadius: AppRadius.pillAll,
                ),
                child: Text(
                  'متاح',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          showShadow: true,
          backgroundColor: AppColors.cardElevated,
          child: Row(
            children: [
              const Icon(Icons.route_rounded, color: AppColors.info, size: 24),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('آخر رحلة', style: AppTextStyles.titleSmall),
                    Text(
                      'شارع الكورنيش → المحطة المركزية',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              Text('١٥ ج', style: AppTextStyles.price.copyWith(fontSize: 18)),
            ],
          ),
        ),
      ],
    );
  }

  // ── Status Section ───────────────────────────────────────────────────────

  Widget _buildStatusSection() {
    return Column(
      children: [
        // Status chips row
        Row(
          children: [
            Expanded(
              child: _StatusChip(label: 'متاح', color: AppColors.available),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _StatusChip(label: 'محجوز', color: AppColors.reserved),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _StatusChip(label: 'يُشحن', color: AppColors.charging),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _StatusChip(
                label: 'غير متاح',
                color: AppColors.unavailable,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        // Loading indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const AppLoadingIndicator(size: 24),
            const AppLoadingIndicator(size: 36),
            const AppLoadingIndicator.fullScreen(),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        // Toggle error view
        AppButton(
          label: _showError ? 'إخفاء حالة الخطأ' : 'عرض حالة الخطأ',
          variant: AppButtonVariant.outlined,
          onPressed: () => setState(() => _showError = !_showError),
        ),
        if (_showError) ...[
          const SizedBox(height: AppSpacing.lg),
          AppErrorView(
            message: 'تعذّر الاتصال بالخادم. تحقق من الإنترنت وأعد المحاولة.',
            onRetry: () => setState(() => _showError = false),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadius.pillAll,
            boxShadow: AppShadows.primaryGlow,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(title, style: AppTextStyles.headlineSmall),
      ],
    );
  }
}

// ── Private helper widgets ──────────────────────────────────────────────────

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isLight = color.computeLuminance() > 0.4;
    return Container(
      width: 88,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.smAll,
        border: Border.all(color: AppColors.border.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            name,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: isLight ? AppColors.background : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: AppRadius.smAll,
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
