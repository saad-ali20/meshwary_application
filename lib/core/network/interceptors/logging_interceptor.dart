import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Development-only request/response logger.
/// Automatically disabled in production via [AppConfig.enableNetworkLogs].
/// IMPORTANT: This interceptor must never log Authorization headers or
/// sensitive personal data in plain text.
class LoggingInterceptor extends Interceptor {
  static const _redactedKeys = {
    'authorization',
    'password',
    'token',
    'secret',
    'national_id',
    'phone',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌── REQUEST ────────────────────────────────────');
      debugPrint('│ ${options.method} ${options.uri}');
      final safeHeaders = _redactHeaders(options.headers);
      debugPrint('│ Headers: $safeHeaders');
      if (options.data != null) {
        debugPrint('│ Body: ${_redactBody(options.data)}');
      }
      debugPrint('└───────────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌── RESPONSE ───────────────────────────────────');
      debugPrint('│ ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('│ Body: ${response.data}');
      debugPrint('└───────────────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌── ERROR ──────────────────────────────────────');
      debugPrint('│ ${err.type.name} ${err.requestOptions.uri}');
      debugPrint('│ Message: ${err.message}');
      debugPrint('└───────────────────────────────────────────────');
    }
    handler.next(err);
  }

  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) {
    return {
      for (final entry in headers.entries)
        entry.key: _redactedKeys.contains(entry.key.toLowerCase())
            ? '***REDACTED***'
            : entry.value,
    };
  }

  dynamic _redactBody(dynamic body) {
    if (body is Map<String, dynamic>) {
      return {
        for (final entry in body.entries)
          entry.key: _redactedKeys.contains(entry.key.toLowerCase())
              ? '***REDACTED***'
              : entry.value,
      };
    }
    return body;
  }
}
