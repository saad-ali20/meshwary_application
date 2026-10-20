import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

/// Meshwary text styles — Cairo typeface, Arabic-first.
/// Use these via Theme.of(context).textTheme when possible.
/// Reference these constants only when context is unavailable.
abstract final class AppTextStyles {
  // ── Display ────────────────────────────────────────────────────────────────
  static TextStyle get displayLarge => TextStyle(fontFamily: 'Cairo', 
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle get displayMedium => TextStyle(fontFamily: 'Cairo', 
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  // ── Headline ───────────────────────────────────────────────────────────────
  static TextStyle get headlineLarge => TextStyle(fontFamily: 'Cairo', 
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get headlineMedium => TextStyle(fontFamily: 'Cairo', 
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get headlineSmall => TextStyle(fontFamily: 'Cairo', 
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  // ── Title ──────────────────────────────────────────────────────────────────
  static TextStyle get titleLarge => TextStyle(fontFamily: 'Cairo', 
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get titleMedium => TextStyle(fontFamily: 'Cairo', 
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get titleSmall => TextStyle(fontFamily: 'Cairo', 
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ── Body ───────────────────────────────────────────────────────────────────
  static TextStyle get bodyLarge => TextStyle(fontFamily: 'Cairo', 
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get bodyMedium => TextStyle(fontFamily: 'Cairo', 
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get bodySmall => TextStyle(fontFamily: 'Cairo', 
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ── Label ──────────────────────────────────────────────────────────────────
  static TextStyle get labelLarge => TextStyle(fontFamily: 'Cairo', 
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static TextStyle get labelMedium => TextStyle(fontFamily: 'Cairo', 
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static TextStyle get labelSmall => TextStyle(fontFamily: 'Cairo', 
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // ── Semantic helpers ───────────────────────────────────────────────────────
  static TextStyle get buttonLabel => TextStyle(fontFamily: 'Cairo', 
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnPrimary,
    letterSpacing: 0.2,
  );

  static TextStyle get caption => TextStyle(fontFamily: 'Cairo', 
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textDisabled,
    height: 1.4,
    letterSpacing: AppSpacing.xs,
  );

  static TextStyle get overline => TextStyle(fontFamily: 'Cairo', 
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
  );

  static TextStyle get price => TextStyle(fontFamily: 'Cairo', 
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    height: 1.2,
  );
}
