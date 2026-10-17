/// Meshwary environment configuration.
///
/// Values are injected via `--dart-define` at build time.
/// Example:
///   flutter run --dart-define=APP_ENV=staging \
///               --dart-define=API_BASE_URL=https://api.staging.meshwary.io
///
/// Never hard-code API keys, access tokens, or production URLs here.
abstract final class AppConfig {
  // ── Environment ────────────────────────────────────────────────────────────
  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
  static bool get isProduction => environment == 'production';

  // ── API ────────────────────────────────────────────────────────────────────
  /// TODO: Replace with actual base URL per environment before release.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.dev.meshwary.io/v1', // placeholder
  );

  // ── Timeouts ───────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 20);

  // ── App metadata ───────────────────────────────────────────────────────────
  static const String appName = 'مشواري';
  static const String appVersion = '1.0.0';

  // ── Feature flags (toggle during development) ──────────────────────────────
  static const bool enableNetworkLogs = !bool.fromEnvironment(
    'DISABLE_LOGS',
    defaultValue: false,
  );
}
