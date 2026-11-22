import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileMenuItem extends StatefulWidget {
  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.trailingText,
    this.isDestructive = false,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String? trailingText;
  final bool isDestructive;

  @override
  State<ProfileMenuItem> createState() => _ProfileMenuItemState();
}

class _ProfileMenuItemState extends State<ProfileMenuItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    final itemColor =
        widget.isDestructive ? AppColors.error : AppColors.textPrimary;
    final iconColor =
        widget.isDestructive ? AppColors.error : AppColors.textPrimary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.symmetric(
            horizontal: sh * 0.020,
            vertical: sh * 0.018,
          ),
          decoration: BoxDecoration(
            color: widget.isDestructive
                ? AppColors.error.withAlpha(15)
                : const Color(0xFF132225),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isDestructive
                  ? AppColors.error.withAlpha(60)
                  : AppColors.border,
              width: 1.1,
            ),
          ),
          child: Row(
            children: [
              // Left side: Chevron or trailing text
              if (widget.trailingText != null)
                Text(
                  widget.trailingText!,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: sh * 0.016,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              Icon(
                Icons.chevron_left_rounded,
                color: widget.isDestructive
                    ? AppColors.error
                    : AppColors.textSecondary,
                size: sh * 0.026,
              ),

              const Spacer(),

              // Right side (RTL): Title + Icon
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: sh * 0.018,
                  fontWeight: FontWeight.w600,
                  color: itemColor,
                ),
              ),
              SizedBox(width: sh * 0.016),
              Container(
                width: sh * 0.046,
                height: sh * 0.046,
                decoration: BoxDecoration(
                  color: widget.isDestructive
                      ? AppColors.error.withAlpha(30)
                      : const Color(0xFF192D31),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.icon,
                  color: iconColor,
                  size: sh * 0.024,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

