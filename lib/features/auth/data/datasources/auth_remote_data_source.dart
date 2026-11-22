import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/otp_response_model.dart';

abstract interface class IAuthRemoteDataSource {
  Future<OtpResponseModel> requestOtp(String phoneNumber);

  Future<String> verifyOtp({
    required String phoneNumber,
    required String code,
  });

  Future<AuthResponseModel> register({
    required String verificationToken,
    required String fullName,
    required String password,
  });

  Future<AuthResponseModel> login({
    required String phoneNumber,
    required String password,
  });
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final DioClient _dioClient;

  const AuthRemoteDataSource(this._dioClient);

  @override
  Future<OtpResponseModel> requestOtp(String phoneNumber) async {
    final response = await _dioClient.post(
      '/api/mobile/auth/register/request-otp',
      data: {'phoneNumber': phoneNumber},
    );

    final data = response.data;
    if (data is Map && data['success'] == true) {
      final payload = data['data'];
      if (payload is Map<String, dynamic>) {
        return OtpResponseModel.fromJson(payload);
      }
      return const OtpResponseModel();
    }

    final message = (data is Map ? data['message'] : null)?.toString() ??
        'فشل إرسال كود التحقق.';
    throw ServerException(message, statusCode: response.statusCode ?? 400);
  }

  @override
  Future<String> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    final response = await _dioClient.post(
      '/api/mobile/auth/register/verify-otp',
      data: {
        'phoneNumber': phoneNumber,
        'code': code,
      },
    );

    final data = response.data;
    if (data is Map && data['success'] == true) {
      final payload = data['data'];
      String? token;
      if (payload is Map) {
        token = (payload['verificationToken'] ??
                payload['token'] ??
                payload['verification_token'] ??
                payload['code'])
            ?.toString();
      } else if (payload is String) {
        token = payload;
      }

      if (token != null && token.trim().isNotEmpty) {
        return token.trim();
      }
      // If the backend returned success without a specific token field, return a fallback marker.
      return 'verified';
    }

    final message = (data is Map ? data['message'] : null)?.toString() ??
        'رمز التحقق غير صحيح.';
    throw ServerException(message, statusCode: response.statusCode ?? 400);
  }

  @override
  Future<AuthResponseModel> register({
    required String verificationToken,
    required String fullName,
    required String password,
  }) async {
    final response = await _dioClient.post(
      '/api/mobile/auth/register',
      data: {
        'verificationToken': verificationToken,
        'fullName': fullName,
        'password': password,
      },
    );

    final data = response.data;
    if (data is Map && data['success'] == true) {
      final payload = data['data'];
      if (payload is Map<String, dynamic>) {
        return AuthResponseModel.fromJson(payload);
      }
      return const AuthResponseModel();
    }

    final message = (data is Map ? data['message'] : null)?.toString() ??
        'فشل إنشاء الحساب.';
    throw ServerException(message, statusCode: response.statusCode ?? 400);
  }

  @override
  Future<AuthResponseModel> login({
    required String phoneNumber,
    required String password,
  }) async {
    final response = await _dioClient.post(
      '/api/mobile/auth/login',
      data: {
        'phoneNumber': phoneNumber,
        'password': password,
      },
    );

    final data = response.data;
    if (data is Map && data['success'] == true) {
      final payload = data['data'];
      if (payload is Map<String, dynamic>) {
        return AuthResponseModel.fromJson(payload);
      }
      return const AuthResponseModel();
    }

    final message = (data is Map ? data['message'] : null)?.toString() ??
        'رقم الهاتف أو كلمة المرور غير صحيحة.';
    throw ServerException(message, statusCode: response.statusCode ?? 400);
  }
}

