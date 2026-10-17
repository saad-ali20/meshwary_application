import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// Full-screen or inline error state widget.
///
/// Shows an icon, message, and optional retry action.
class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, this.message, this.onRetry, this.icon});

  final String? message;
  final VoidCallback? onRetry;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.errorSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.wifi_off_rounded,
                color: AppColors.error,
                size: 32,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              message ?? 'حدث خطأ، يرجى المحاولة مجدداً.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: 180,
                child: AppButton(label: 'إعادة المحاولة', onPressed: onRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
