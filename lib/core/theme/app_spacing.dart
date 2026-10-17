/// Meshwary spacing scale.
/// Base unit: 4dp — all values are multiples of 4 for optical consistency.
abstract final class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;
  static const double massive = 64.0;

  /// Horizontal screen padding (safe content area).
  static const double screenH = 20.0;

  /// Vertical screen padding.
  static const double screenV = 24.0;

  /// Standard card internal padding.
  static const double cardPadding = 16.0;

  /// Vertical spacing between form fields.
  static const double fieldGap = 16.0;

  /// Standard button height.
  static const double buttonHeight = 52.0;

  /// Minimum touch target.
  static const double touchTarget = 44.0;

  /// BottomSheet top drag handle height.
  static const double dragHandle = 4.0;
}
