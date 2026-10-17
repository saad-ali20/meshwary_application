import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper around [SharedPreferences] for non-sensitive user settings.
///
/// Only use this for:
/// - Onboarding completion flag
/// - Language preference
/// - Notification opt-in flag
///
/// NEVER store tokens, personal data, or identity-verification info here.
class PreferencesStorage {
  static const _onboardingCompleteKey = '_msh_onboarding_done';
  static const _appLocaleKey = '_msh_locale';
  static const _notificationsEnabledKey = '_msh_notifications';

  final SharedPreferences _prefs;

  PreferencesStorage(this._prefs);

  // ── Onboarding ──────────────────────────────────────────────────────────────
  bool get isOnboardingComplete =>
      _prefs.getBool(_onboardingCompleteKey) ?? false;

  Future<void> setOnboardingComplete() async {
    await _prefs.setBool(_onboardingCompleteKey, true);
  }

  // ── Locale ──────────────────────────────────────────────────────────────────
  String get appLocale => _prefs.getString(_appLocaleKey) ?? 'ar';

  Future<void> setAppLocale(String locale) async {
    await _prefs.setString(_appLocaleKey, locale);
  }

  // ── Notifications ───────────────────────────────────────────────────────────
  bool get notificationsEnabled =>
      _prefs.getBool(_notificationsEnabledKey) ?? true;

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsEnabledKey, enabled);
  }

  // ── Reset ───────────────────────────────────────────────────────────────────
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
