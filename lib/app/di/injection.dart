import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/interceptors/auth_interceptor.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/storage/preferences_storage.dart';
import '../../core/storage/secure_storage.dart';

final GetIt getIt = GetIt.instance;

/// Registers all application dependencies.
/// Call [configureDependencies] once in [main] before [runApp].
Future<void> configureDependencies() async {
  // ── Core Storage ────────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<SecureStorage>(() => SecureStorage());

  getIt.registerLazySingleton<PreferencesStorage>(
    () => PreferencesStorage(sharedPreferences),
  );

  // ── Networking ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(storage: getIt<SecureStorage>()),
  );

  getIt.registerLazySingleton<DioClient>(
    () => DioClient(authInterceptor: getIt<AuthInterceptor>()),
  );

  // ── Services ────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // Initialize connectivity monitoring
  await getIt<ConnectivityService>().initialize();

  // Feature-specific dependencies are registered in their own modules.
  // Example: await registerAuthDependencies(getIt);
}
