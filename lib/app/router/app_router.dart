import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/phone_auth_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/profile_completion_page.dart';
import '../../features/design_preview/presentation/pages/design_preview_page.dart';
import '../../features/id_verification/data/models/verification_session.dart';
import '../../features/id_verification/presentation/pages/id_capture_page.dart';
import '../../features/id_verification/presentation/pages/id_verification_intro_page.dart';
import '../../features/id_verification/presentation/pages/selfie_capture_page.dart';
import '../../features/id_verification/presentation/pages/data_review_page.dart';
import '../../features/id_verification/presentation/pages/verification_processing_page.dart';
import '../../features/id_verification/presentation/pages/verification_result_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'routes.dart';

/// Meshwary declarative router.
final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.designPreview,
      name: 'design-preview',
      builder: (context, state) => const DesignPreviewPage(),
    ),

    // ── Auth routes ─────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.phoneAuth,
      name: 'phone-auth',
      builder: (context, state) => const PhoneAuthPage(),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      name: 'otp-verification',
      builder: (context, state) => OtpVerificationPage(
        phoneNumber: (state.extra as String?) ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.profileCompletion,
      name: 'profile-completion',
      builder: (context, state) => ProfileCompletionPage(
        phoneNumber: (state.extra as String?) ?? '',
      ),
    ),

    // ── Identity Verification routes ─────────────────────────────────────────
    GoRoute(
      path: AppRoutes.idVerificationIntro,
      name: 'id-verification-intro',
      builder: (context, state) => IdVerificationIntroPage(
        session: state.extra as VerificationSession,
      ),
    ),
    GoRoute(
      path: AppRoutes.idCaptureFront,
      name: 'id-capture-front',
      builder: (context, state) => IdCapturePage(
        session: state.extra as VerificationSession,
        isBack: false,
      ),
    ),
    GoRoute(
      path: AppRoutes.idCaptureBack,
      name: 'id-capture-back',
      builder: (context, state) => IdCapturePage(
        session: state.extra as VerificationSession,
        isBack: true,
      ),
    ),
    GoRoute(
      path: AppRoutes.selfieCapture,
      name: 'selfie-capture',
      builder: (context, state) => SelfieCapturePage(
        session: state.extra as VerificationSession,
      ),
    ),
    GoRoute(
      path: AppRoutes.verificationReview,
      name: 'verification-review',
      builder: (context, state) => DataReviewPage(
        session: state.extra as VerificationSession,
      ),
    ),
    GoRoute(
      path: AppRoutes.verificationProcessing,
      name: 'verification-processing',
      builder: (context, state) => VerificationProcessingPage(
        session: state.extra as VerificationSession,
      ),
    ),
    GoRoute(
      path: AppRoutes.verificationResult,
      name: 'verification-result',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return VerificationResultPage(
          session: extra['session'] as VerificationSession,
          isSuccess: extra['isSuccess'] as bool,
        );
      },
    ),
  ],

  // TODO: Implement redirect guard when auth is ready.
  // redirect: (context, state) async { ... },
);

