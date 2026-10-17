import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures.
/// Failures are the expected, handled error states returned from repositories.
sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Network / connectivity failure.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'لا يوجد اتصال بالإنترنت.']);
}

/// HTTP server-side failure (4xx / 5xx).
final class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Request timed out.
final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'انتهت مهلة الطلب.']);
}

/// 401 Unauthorized — session expired.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'انتهت جلستك. يرجى تسجيل الدخول مجدداً.',
  ]);
}

/// Local storage read/write failure.
final class StorageFailure extends Failure {
  const StorageFailure([super.message = 'خطأ في التخزين المحلي.']);
}

/// Unexpected / unclassified failure.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'حدث خطأ غير متوقع.']);
}
