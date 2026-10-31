/// Named route constants for go_router.
/// Use these constants instead of hard-coding path strings.
abstract final class AppRoutes {
  // ── Foundation ─────────────────────────────────────────────────────────────
  static const String splash = '/';
  static const String designPreview = '/design-preview';

  // ── Auth (future) ──────────────────────────────────────────────────────────
  static const String onboarding = '/onboarding';
  static const String phoneAuth = '/auth/phone';
  static const String otpVerification = '/auth/otp';
  static const String profileCompletion = '/auth/profile';

  // ── Identity Verification ─────────────────────────────────────────────────
  static const String idVerificationIntro = '/verification/intro';
  static const String idCaptureFront    = '/verification/id-front';
  static const String idCaptureBack     = '/verification/id-back';
  static const String selfieCapture     = '/verification/selfie';
  static const String verificationReview      = '/verification/review';
  static const String verificationProcessing  = '/verification/processing';
  static const String verificationResult      = '/verification/result';


  // ── Main App (future) ──────────────────────────────────────────────────────
  static const String home = '/home';
  static const String rideActive = '/ride/active';
  static const String rideReceipt = '/ride/receipt';
  static const String wallet = '/wallet';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String support = '/support';
}
