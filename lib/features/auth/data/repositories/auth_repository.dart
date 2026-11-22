// ignore_for_file: prefer_initializing_formals
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/storage/preferences_storage.dart';
import '../../../../core/storage/secure_storage.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_response_model.dart';
import '../models/otp_response_model.dart';
import '../models/user_model.dart';

class AuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  UserModel? _currentUser;
  AuthResponseModel? _currentAuthResponse;

  AuthRepository({
    required IAuthRemoteDataSource remoteDataSource,
    PreferencesStorage? preferencesStorage,
    required SecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage,
        _sharedPreferences = sharedPreferences;

  UserModel? get currentUser => _currentUser;
  AuthResponseModel? get currentAuthResponse => _currentAuthResponse;

  /// Phase 1: Request OTP code for a phone number.
  Future<OtpResponseModel> requestOtp(String phoneNumber) async {
    return await _remoteDataSource.requestOtp(phoneNumber);
  }

  /// Phase 2: Verify the OTP code sent to the phone number.
  /// Returns the `verificationToken` needed for registration.
  Future<String> verifyOtp(String phoneNumber, String code) async {
    return await _remoteDataSource.verifyOtp(
      phoneNumber: phoneNumber,
      code: code,
    );
  }

  /// Phase 3: Complete registration with full name, password, and verification token.
  /// Automatically stores tokens and user details in SharedPreferences and SecureStorage.
  Future<AuthResponseModel> register({
    required String verificationToken,
    required String fullName,
    required String password,
  }) async {
    final response = await _remoteDataSource.register(
      verificationToken: verificationToken,
      fullName: fullName,
      password: password,
    );

    await _saveAuthSession(response);
    return response;
  }

  /// Login with phone number and password.
  /// Automatically stores tokens and user details in SharedPreferences and SecureStorage.
  Future<AuthResponseModel> login({
    required String phoneNumber,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(
      phoneNumber: phoneNumber,
      password: password,
    );

    await _saveAuthSession(response);
    return response;
  }

  Future<void> _saveAuthSession(AuthResponseModel response) async {
    _currentAuthResponse = response;
    _currentUser = response.user;

    // 1. Save tokens to SharedPreferences
    if (response.accessToken != null && response.accessToken!.isNotEmpty) {
      await _sharedPreferences.setString('accessToken', response.accessToken!);
      await _sharedPreferences.setString('_msh_access_token', response.accessToken!);
    }
    if (response.refreshToken != null && response.refreshToken!.isNotEmpty) {
      await _sharedPreferences.setString('refreshToken', response.refreshToken!);
      await _sharedPreferences.setString('_msh_refresh_token', response.refreshToken!);
    }
    if (response.accessTokenExpiresAtUtc != null) {
      await _sharedPreferences.setString(
        'accessTokenExpiresAtUtc',
        response.accessTokenExpiresAtUtc!,
      );
    }
    if (response.refreshTokenExpiresAtUtc != null) {
      await _sharedPreferences.setString(
        'refreshTokenExpiresAtUtc',
        response.refreshTokenExpiresAtUtc!,
      );
    }

    // 2. Save user model to SharedPreferences
    if (response.user != null) {
      final userJson = jsonEncode(response.user!.toJson());
      await _sharedPreferences.setString('user', userJson);
      await _sharedPreferences.setString('userId', response.user!.id);
      await _sharedPreferences.setString('fullName', response.user!.fullName);
      await _sharedPreferences.setString('phoneNumber', response.user!.phoneNumber);
    }

    // 3. Save to SecureStorage for AuthInterceptor
    if (response.accessToken != null && response.accessToken!.isNotEmpty) {
      await _secureStorage.writeAccessToken(response.accessToken!);
    }
    if (response.refreshToken != null && response.refreshToken!.isNotEmpty) {
      await _secureStorage.writeRefreshToken(response.refreshToken!);
    }
    if (response.user != null) {
      await _secureStorage.writeUserId(response.user!.id);
    }
  }

  /// Check if the stored access token exists and has not expired.
  Future<bool> isTokenValid() async {
    final token = await _secureStorage.readAccessToken() ??
        _sharedPreferences.getString('accessToken');
    if (token == null || token.trim().isEmpty) {
      return false;
    }

    final expiresAtStr =
        _sharedPreferences.getString('accessTokenExpiresAtUtc');
    if (expiresAtStr != null && expiresAtStr.isNotEmpty) {
      try {
        final expiresAt = DateTime.parse(expiresAtStr).toUtc();
        final now = DateTime.now().toUtc();
        if (now.isAfter(expiresAt)) {
          // Token is expired!
          return false;
        }
      } catch (_) {}
    }

    return true;
  }

  /// Checks if user has previously registered or logged in on this device.
  bool get hasSavedAccount {
    final phone = _sharedPreferences.getString('phoneNumber');
    final user = _sharedPreferences.getString('user');
    return (phone != null && phone.isNotEmpty) ||
        (user != null && user.isNotEmpty);
  }

  /// Returns previously used phone number if available.
  String? get savedPhoneNumber => _sharedPreferences.getString('phoneNumber');

  /// Loads cached user profile from SharedPreferences.
  Future<UserModel?> loadCachedUser() async {
    if (_currentUser != null) return _currentUser;

    final userJson = _sharedPreferences.getString('user');
    if (userJson != null && userJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(userJson) as Map<String, dynamic>;
        _currentUser = UserModel.fromJson(decoded);
        return _currentUser;
      } catch (_) {}
    }
    return null;
  }

  /// Clears stored tokens and user session.
  Future<void> logout() async {
    _currentUser = null;
    _currentAuthResponse = null;

    await _sharedPreferences.remove('accessToken');
    await _sharedPreferences.remove('refreshToken');
    await _sharedPreferences.remove('_msh_access_token');
    await _sharedPreferences.remove('_msh_refresh_token');
    await _sharedPreferences.remove('accessTokenExpiresAtUtc');
    await _sharedPreferences.remove('refreshTokenExpiresAtUtc');
    await _sharedPreferences.remove('user');
    await _sharedPreferences.remove('userId');
    await _sharedPreferences.remove('fullName');
    await _sharedPreferences.remove('phoneNumber');

    await _secureStorage.clearSession();
  }
}

