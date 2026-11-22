import 'package:go_router/go_router.dart';
import '../../features/auth/data/models/profile_completion_args.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/phone_auth_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/profile_completion_page.dart';
import '../../features/design_preview/presentation/pages/design_preview_page.dart';
import '../../features/home/data/models/scooter_model.dart';
import '../../features/home/presentation/pages/active_reservation_page.dart';
import '../../features/home/presentation/pages/active_ride_page.dart';
import '../../features/home/presentation/pages/book_scooter_page.dart';
import '../../features/home/presentation/pages/home_map_page.dart';
import '../../features/home/presentation/pages/navigate_to_scooter_page.dart';
import '../../features/home/presentation/pages/payment_method_page.dart';
import '../../features/home/presentation/pages/pre_unlock_verification_page.dart';
import '../../features/home/presentation/pages/qr_scan_page.dart';
import '../../features/home/presentation/pages/ride_started_page.dart';
import '../../features/home/presentation/pages/scooter_details_page.dart';
import '../../features/home/presentation/pages/unlocking_scooter_page.dart';
import '../../features/id_verification/data/models/verification_session.dart';
import '../../features/id_verification/presentation/pages/id_capture_page.dart';
import '../../features/id_verification/presentation/pages/id_verification_intro_page.dart';
import '../../features/id_verification/presentation/pages/selfie_capture_page.dart';
import '../../features/id_verification/presentation/pages/data_review_page.dart';
import '../../features/id_verification/presentation/pages/verification_processing_page.dart';
import '../../features/id_verification/presentation/pages/verification_result_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/about_app_page.dart';
import '../../features/profile/presentation/pages/help_center_page.dart';
import '../../features/profile/presentation/pages/invite_friends_page.dart';
import '../../features/profile/presentation/pages/my_rides_page.dart';
import '../../features/profile/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/payment_methods_page.dart';
import '../../features/profile/presentation/pages/personal_details_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/terms_conditions_page.dart';
import '../../features/profile/presentation/pages/wallet_page.dart';
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
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
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
      builder: (context, state) {
        if (state.extra is ProfileCompletionArgs) {
          final args = state.extra as ProfileCompletionArgs;
          return ProfileCompletionPage(
            phoneNumber: args.phoneNumber,
            verificationToken: args.verificationToken,
          );
        } else if (state.extra is Map<String, dynamic>) {
          final map = state.extra as Map<String, dynamic>;
          return ProfileCompletionPage(
            phoneNumber: (map['phoneNumber'] as String?) ?? '',
            verificationToken: (map['verificationToken'] as String?) ?? '',
          );
        }
        return ProfileCompletionPage(
          phoneNumber: (state.extra as String?) ?? '',
          verificationToken: '',
        );
      },
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
    // ── Home & Ride cycle ────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeMapPage(),
    ),
    GoRoute(
      path: AppRoutes.scooterDetails,
      name: 'scooter-details',
      builder: (context, state) {
        if (state.extra is ScooterModel) {
          return ScooterDetailsPage(
            scooter: state.extra as ScooterModel,
          );
        } else if (state.extra is String) {
          return ScooterDetailsPage.fromCode(
            code: state.extra as String,
          );
        }
        return const ScooterDetailsPage();
      },
    ),
    GoRoute(
      path: AppRoutes.navigateScooter,
      name: 'navigate-scooter',
      builder: (context, state) => NavigateToScooterPage(
        scooter: state.extra as ScooterModel,
      ),
    ),
    GoRoute(
      path: AppRoutes.bookScooter,
      name: 'book-scooter',
      builder: (context, state) => BookScooterPage(
        scooter: state.extra as ScooterModel,
      ),
    ),
    GoRoute(
      path: AppRoutes.activeReservation,
      name: 'active-reservation',
      builder: (context, state) {
        if (state.extra is Map<String, dynamic>) {
          final data = state.extra as Map<String, dynamic>;
          return ActiveReservationPage(
            scooter: data['scooter'] as ScooterModel,
            initialMinutes: (data['durationMinutes'] as int?) ?? 10,
          );
        }
        return ActiveReservationPage(
          scooter: state.extra as ScooterModel,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.paymentMethod,
      name: 'payment-method',
      builder: (context, state) => PaymentMethodPage(
        scooter: state.extra as ScooterModel,
      ),
    ),
    GoRoute(
      path: AppRoutes.qrScan,
      name: 'qr-scan',
      builder: (context, state) => QrScanPage(
        scooter: state.extra as ScooterModel?,
      ),
    ),
    GoRoute(
      path: AppRoutes.unlockVerification,
      name: 'unlock-verification',
      builder: (context, state) => PreUnlockVerificationPage(
        scooter: state.extra as ScooterModel?,
      ),
    ),
    GoRoute(
      path: AppRoutes.unlockingProgress,
      name: 'unlocking-progress',
      builder: (context, state) => UnlockingScooterPage(
        scooter: state.extra as ScooterModel?,
      ),
    ),
    GoRoute(
      path: AppRoutes.rideStarted,
      name: 'ride-started',
      builder: (context, state) => RideStartedPage(
        scooter: state.extra as ScooterModel?,
      ),
    ),
    GoRoute(
      path: AppRoutes.rideActive,
      name: 'ride-active',
      builder: (context, state) => ActiveRidePage(
        scooter: state.extra as ScooterModel?,
      ),
    ),

    // ── Main Tabs & Profile Screens ──────────────────────────────────────────
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: AppRoutes.personalInfo,
      name: 'personal-info',
      builder: (context, state) => const PersonalDetailsPage(),
    ),
    GoRoute(
      path: AppRoutes.paymentMethods,
      name: 'payment-methods',
      builder: (context, state) => const PaymentMethodsPage(),
    ),
    GoRoute(
      path: AppRoutes.inviteFriends,
      name: 'invite-friends',
      builder: (context, state) => const InviteFriendsPage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.aboutApp,
      name: 'about-app',
      builder: (context, state) => const AboutAppPage(),
    ),
    GoRoute(
      path: AppRoutes.terms,
      name: 'terms-and-conditions',
      builder: (context, state) => const TermsAndConditionsPage(),
    ),
    GoRoute(
      path: AppRoutes.support,
      name: 'help-center',
      builder: (context, state) => const HelpCenterPage(),
    ),
    GoRoute(
      path: AppRoutes.myRides,
      name: 'my-rides',
      builder: (context, state) => const MyRidesPage(),
    ),
    GoRoute(
      path: AppRoutes.wallet,
      name: 'wallet',
      builder: (context, state) => const WalletPage(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      name: 'notifications',
      builder: (context, state) => const NotificationsPage(),
    ),
  ],

  // TODO: Implement redirect guard when auth is ready.
  // redirect: (context, state) async { ... },
);

