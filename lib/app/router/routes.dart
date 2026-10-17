/// Named route constants for go_router.
/// Use these constants instead of hard-coding path strings.
abstract final class AppRoutes {
  // ── Foundation ─────────────────────────────────────────────────────────────
  static const String designPreview = '/';

  // ── Auth (future) ──────────────────────────────────────────────────────────
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String phoneAuth = '/auth/phone';
  static const String otpVerification = '/auth/otp';
  static const String profileCompletion = '/auth/profile';

  // ── Identity Verification (future) ────────────────────────────────────────
  static const String idVerification = '/verification/id';

  // ── Main App (future) ──────────────────────────────────────────────────────
  static const String home = '/home';
  static const String rideActive = '/ride/active';
  static const String rideReceipt = '/ride/receipt';
  static const String wallet = '/wallet';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String support = '/support';
}
