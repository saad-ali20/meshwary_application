/// Named route constants for go_router.
/// Use these constants instead of hard-coding path strings.
abstract final class AppRoutes {
  // ── Foundation ─────────────────────────────────────────────────────────────
  static const String splash = '/';
  static const String designPreview = '/design-preview';

  // ── Auth ───────────────────────────────────────────────────────────────────
  static const String onboarding = '/onboarding';
  static const String login = '/auth/login';
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


  // ── Main App ───────────────────────────────────────────────────────────────
  static const String home               = '/home';
  static const String myRides            = '/rides';
  static const String wallet             = '/wallet';
  static const String notifications      = '/notifications';
  static const String profile            = '/profile';

  // ── Profile Sub-routes ─────────────────────────────────────────────────────
  static const String personalInfo       = '/profile/personal-info';
  static const String paymentMethods     = '/profile/payment-methods';
  static const String inviteFriends      = '/profile/invite-friends';
  static const String settings           = '/profile/settings';
  static const String aboutApp           = '/profile/about';
  static const String terms              = '/profile/terms';
  static const String support            = '/profile/support';

  // ── Scooter & Ride Cycle ───────────────────────────────────────────────────
  static const String scooterDetails     = '/scooter/details';
  static const String navigateScooter    = '/scooter/navigate';
  static const String bookScooter        = '/scooter/book';
  static const String activeReservation  = '/scooter/active-reservation';
  static const String paymentMethod      = '/payment/select';
  static const String qrScan             = '/ride/qr';
  static const String unlockVerification = '/ride/unlock-verification';
  static const String unlockingProgress  = '/ride/unlocking';
  static const String rideStarted        = '/ride/started';
  static const String rideActive         = '/ride/active';
  static const String rideReceipt        = '/ride/receipt';
}
