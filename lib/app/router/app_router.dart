import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/phone_auth_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/profile_completion_page.dart';
import '../../features/design_preview/presentation/pages/design_preview_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'routes.dart';

/// Meshwary declarative router.
///
/// Structure is designed to support future auth and identity-verification
/// guards via [redirect] callbacks — do not add fake guard logic now.
///
/// Guards will inspect [SecureStorage] / [PreferencesStorage] to redirect
/// unauthenticated or unverified users to the appropriate flow.
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
  ],

  // TODO: Implement redirect guard when auth is ready.
  // redirect: (context, state) async {
  //   final hasSession = await getIt<SecureStorage>().hasActiveSession();
  //   if (!hasSession && !state.matchedLocation.startsWith('/auth')) {
  //     return AppRoutes.phoneAuth;
  //   }
  //   return null;
  // },
);

