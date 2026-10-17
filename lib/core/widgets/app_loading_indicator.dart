import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Full-screen or inline loading indicator.
///
/// Use [AppLoadingIndicator.fullScreen] for page-level loading states.
/// Use [AppLoadingIndicator()] inline within cards or sections.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = 36,
    this.color,
    this.strokeWidth = 3.0,
  });

  const AppLoadingIndicator.fullScreen({Key? key}) : this(key: key, size: 48);

  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
      ),
    );

    if (size == 48) {
      return Center(child: indicator);
    }
    return indicator;
  }
}
