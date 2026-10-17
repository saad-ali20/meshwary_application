import 'package:flutter/material.dart';

/// Meshwary centralized color palette.
/// Never use raw hex values in feature screens — reference these tokens.
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF57F56D);
  static const Color primaryDim = Color(0xFF3ABF50);
  static const Color primaryGlow = Color(0x3357F56D);

  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF091112);
  static const Color surface = Color(0xFF152528);
  static const Color card = Color(0xFF17292A);
  static const Color cardElevated = Color(0xFF1E3235);
  static const Color overlay = Color(0xCC091112);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF5FFF8);
  static const Color textSecondary = Color(0xFF9CB9B2);
  static const Color textDisabled = Color(0xFF4A6B65);
  static const Color textOnPrimary = Color(0xFF091112);

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFFF6464);
  static const Color errorSurface = Color(0x1AFF6464);
  static const Color warning = Color(0xFFFFD166);
  static const Color warningSurface = Color(0x1AFFD166);
  static const Color success = Color(0xFF57F56D);
  static const Color successSurface = Color(0x1A57F56D);
  static const Color info = Color(0xFF4DB8D4);

  // ── Borders & Dividers ─────────────────────────────────────────────────────
  static const Color border = Color(0xFF1F3B3E);
  static const Color borderFocused = Color(0xFF57F56D);
  static const Color divider = Color(0xFF152528);

  // ── Map / Ride status ──────────────────────────────────────────────────────
  static const Color available = Color(0xFF57F56D);
  static const Color reserved = Color(0xFFFFD166);
  static const Color unavailable = Color(0xFFFF6464);
  static const Color charging = Color(0xFF4DB8D4);

  // ── Scrim / Shadows ────────────────────────────────────────────────────────
  static const Color scrim = Color(0x80000000);
  static const Color shadow = Color(0xFF000000);
  static const Color primaryShadow = Color(0x4057F56D);
}
