import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../error/exceptions.dart' as app_ex show
    AppException,
    TimeoutException,
    NetworkException,
    ServerException,
    UnauthorizedException;
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Configured Dio HTTP client for Meshwary.
///
/// Registered as a lazy singleton via [injection.dart].
/// Do NOT import this directly in UI widgets — use repositories instead.
class DioClient {
  late final Dio _dio;

  DioClient({AuthInterceptor? authInterceptor}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Accept-Language': 'ar',
        },
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.addAll([
      authInterceptor ?? AuthInterceptor(),
      if (AppConfig.enableNetworkLogs && !AppConfig.isProduction)
        LoggingInterceptor(),
    ]);
  }

  Dio get instance => _dio;

  // ── Convenience wrappers ───────────────────────────────────────────────────

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(path, data: data, options: options);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(path, data: data, options: options);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(path, data: data, options: options);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ── Exception mapping ──────────────────────────────────────────────────────

  app_ex.AppException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.transformTimeout:
        return const app_ex.TimeoutException();

      case DioExceptionType.connectionError:
        return const app_ex.NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message = _extractErrorMessage(e.response);
        if (statusCode == 401) {
          return const app_ex.UnauthorizedException();
        }
        return app_ex.ServerException(message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return const app_ex.NetworkException('Request was cancelled.');

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        final inner = e.error;
        if (inner is app_ex.AppException) return inner;
        return const app_ex.NetworkException();
    }
  }

  String _extractErrorMessage(Response<dynamic>? response) {
    if (response?.data is Map) {
      final data = response!.data as Map<String, dynamic>;
      return (data['message'] as String?) ??
          (data['error'] as String?) ??
          'Server error ${response.statusCode}.';
    }
    return 'Server error ${response?.statusCode ?? 'unknown'}.';
  }
}
