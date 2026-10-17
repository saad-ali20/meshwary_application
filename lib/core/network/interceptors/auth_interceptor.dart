import 'package:dio/dio.dart';
import '../../storage/secure_storage.dart';

/// Injects the Authorization header on every request if a token is available.
/// On 401 responses the token is cleared to force re-authentication.
class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;

  AuthInterceptor({SecureStorage? storage})
    : _storage = storage ?? SecureStorage();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token is invalid or expired — clear session.
      await _storage.clearSession();
      // TODO: Optionally emit a global auth-expired event here.
    }
    handler.next(err);
  }
}
