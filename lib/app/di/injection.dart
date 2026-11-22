import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/interceptors/auth_interceptor.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/storage/preferences_storage.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/home/data/datasources/scooter_mock_data_source.dart';
import '../../features/home/data/datasources/scooter_remote_data_source.dart';
import '../../features/home/data/repositories/scooter_repository.dart';
import '../../features/home/domain/repositories/compound_repository.dart';
import '../../features/home/presentation/cubit/compound_cubit.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void>? _diInitializationFuture;

/// Initializes all application dependencies once.
/// Safe to call concurrently — returns the same singleton Future.
Future<void> ensureDependenciesInitialized() {
  _diInitializationFuture ??= _initDependenciesInternal();
  return _diInitializationFuture!;
}

/// Backwards-compatible alias for [ensureDependenciesInitialized].
Future<void> configureDependencies() => ensureDependenciesInitialized();

Future<void> _initDependenciesInternal() async {
  try {
    final sharedPreferences = await SharedPreferences.getInstance();

    if (!getIt.isRegistered<SecureStorage>()) {
      getIt.registerLazySingleton<SecureStorage>(() => SecureStorage());
    }

    if (!getIt.isRegistered<PreferencesStorage>()) {
      getIt.registerLazySingleton<PreferencesStorage>(
        () => PreferencesStorage(sharedPreferences),
      );
    }

    if (!getIt.isRegistered<AuthInterceptor>()) {
      getIt.registerLazySingleton<AuthInterceptor>(
        () => AuthInterceptor(storage: getIt<SecureStorage>()),
      );
    }

    if (!getIt.isRegistered<DioClient>()) {
      getIt.registerLazySingleton<DioClient>(
        () => DioClient(authInterceptor: getIt<AuthInterceptor>()),
      );
    }

    if (!getIt.isRegistered<ConnectivityService>()) {
      getIt.registerLazySingleton<ConnectivityService>(
        () => ConnectivityService(),
      );
    }

    // Initialize connectivity in background, never block
    try {
      getIt<ConnectivityService>().initialize().catchError((_) {});
    } catch (_) {}

    if (!getIt.isRegistered<IAuthRemoteDataSource>()) {
      getIt.registerLazySingleton<IAuthRemoteDataSource>(
        () => AuthRemoteDataSource(getIt<DioClient>()),
      );
    }

    if (!getIt.isRegistered<AuthRepository>()) {
      getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepository(
          remoteDataSource: getIt<IAuthRemoteDataSource>(),
          preferencesStorage: getIt<PreferencesStorage>(),
          secureStorage: getIt<SecureStorage>(),
          sharedPreferences: sharedPreferences,
        ),
      );
    }

    if (!getIt.isRegistered<CompoundRepository>()) {
      getIt.registerLazySingleton<CompoundRepository>(
        () => CompoundRepository(getIt<DioClient>().instance),
      );
    }

    if (!getIt.isRegistered<CompoundCubit>()) {
      getIt.registerLazySingleton<CompoundCubit>(
        () => CompoundCubit(getIt<CompoundRepository>()),
      );
    }

    if (!getIt.isRegistered<ScooterRemoteDataSource>()) {
      getIt.registerLazySingleton<ScooterRemoteDataSource>(
        () => ScooterRemoteDataSource(getIt<DioClient>()),
      );
    }

    if (!getIt.isRegistered<ScooterDataSource>()) {
      getIt.registerLazySingleton<ScooterDataSource>(
        () => const ScooterMockDataSource(),
      );
    }

    if (!getIt.isRegistered<ScooterRepository>()) {
      getIt.registerLazySingleton<ScooterRepository>(
        () => ScooterRepositoryImpl(
          remoteDataSource: getIt<ScooterRemoteDataSource>(),
          mockDataSource: getIt<ScooterDataSource>(),
        ),
      );
    }

    if (!getIt.isRegistered<HomeCubit>()) {
      getIt.registerFactory<HomeCubit>(
        () => HomeCubit(getIt<ScooterRepository>()),
      );
    }
  } catch (e, stack) {
    debugPrint('DI Initialization error: $e\n$stack');
  }
}
