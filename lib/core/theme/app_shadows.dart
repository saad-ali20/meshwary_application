import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Meshwary shadow tokens — subtle depth for dark surfaces.
abstract final class AppShadows {
  /// Soft card elevation shadow.
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 4)),
  ];

  /// Neon primary glow — use sparingly on focal elements.
  static const List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: AppColors.primaryShadow,
      blurRadius: 20,
      offset: Offset(0, 0),
    ),
  ];

  /// Medium elevation shadow.
  static const List<BoxShadow> elevated = [
    BoxShadow(color: Color(0x4D000000), blurRadius: 24, offset: Offset(0, 8)),
  ];

  /// Bottom sheet shadow.
  static const List<BoxShadow> bottomSheet = [
    BoxShadow(color: Color(0x66000000), blurRadius: 32, offset: Offset(0, -4)),
  ];

  /// Subtle inner shadow for input fields (as border highlight).
  static List<BoxShadow> inputFocused = [
    BoxShadow(
      color: AppColors.primaryGlow,
      blurRadius: 8,
      offset: const Offset(0, 0),
    ),
  ];
}
