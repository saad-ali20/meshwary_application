import 'package:equatable/equatable.dart';
import 'user_model.dart';

/// Authentication response model containing access token, refresh token, and user profile.
class AuthResponseModel extends Equatable {
  final String? accessToken;
  final String? accessTokenExpiresAtUtc;
  final String? refreshToken;
  final String? refreshTokenExpiresAtUtc;
  final UserModel? user;

  const AuthResponseModel({
    this.accessToken,
    this.accessTokenExpiresAtUtc,
    this.refreshToken,
    this.refreshTokenExpiresAtUtc,
    this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String?,
      accessTokenExpiresAtUtc: json['accessTokenExpiresAtUtc'] as String?,
      refreshToken: json['refreshToken'] as String?,
      refreshTokenExpiresAtUtc: json['refreshTokenExpiresAtUtc'] as String?,
      user: json['user'] != null && json['user'] is Map<String, dynamic>
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'accessTokenExpiresAtUtc': accessTokenExpiresAtUtc,
      'refreshToken': refreshToken,
      'refreshTokenExpiresAtUtc': refreshTokenExpiresAtUtc,
      'user': user?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        accessToken,
        accessTokenExpiresAtUtc,
        refreshToken,
        refreshTokenExpiresAtUtc,
        user,
      ];
}

