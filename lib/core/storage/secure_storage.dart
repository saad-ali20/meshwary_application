import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/exceptions.dart';

/// Wrapper around [FlutterSecureStorage] for session credentials.
///
/// Keys are defined as private constants to avoid typos across the codebase.
/// NEVER store national ID images, biometric data, or raw passwords here.
class SecureStorage {
  static const _accessTokenKey = '_msh_access_token';
  static const _refreshTokenKey = '_msh_refresh_token';
  static const _userIdKey = '_msh_user_id';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // ── Access Token ────────────────────────────────────────────────────────────
  Future<void> writeAccessToken(String token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
    } catch (e) {
      throw const StorageException('Failed to write access token.');
    }
  }

  Future<String?> readAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      throw const StorageException('Failed to read access token.');
    }
  }

  // ── Refresh Token ───────────────────────────────────────────────────────────
  Future<void> writeRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
    } catch (e) {
      throw const StorageException('Failed to write refresh token.');
    }
  }

  Future<String?> readRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      throw const StorageException('Failed to read refresh token.');
    }
  }

  // ── User ID ─────────────────────────────────────────────────────────────────
  Future<void> writeUserId(String userId) async {
    try {
      await _storage.write(key: _userIdKey, value: userId);
    } catch (e) {
      throw const StorageException('Failed to write user ID.');
    }
  }

  Future<String?> readUserId() async {
    try {
      return await _storage.read(key: _userIdKey);
    } catch (e) {
      throw const StorageException('Failed to read user ID.');
    }
  }

  // ── Session ─────────────────────────────────────────────────────────────────
  Future<void> clearSession() async {
    try {
      await Future.wait([
        _storage.delete(key: _accessTokenKey),
        _storage.delete(key: _refreshTokenKey),
        _storage.delete(key: _userIdKey),
      ]);
    } catch (e) {
      throw const StorageException('Failed to clear session.');
    }
  }

  Future<bool> hasActiveSession() async {
    final token = await readAccessToken();
    return token != null && token.isNotEmpty;
  }
}
