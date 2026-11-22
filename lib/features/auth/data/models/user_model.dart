import 'package:equatable/equatable.dart';

/// User profile model corresponding to AuthenticatedUserDto.
class UserModel extends Equatable {
  final String id;
  final String fullName;
  final String phoneNumber;
  final List<String> roles;
  final List<String> permissions;
  final bool phoneNumberVerified;
  final bool mustChangePassword;
  final bool requiresOnboarding;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.roles = const [],
    this.permissions = const [],
    this.phoneNumberVerified = false,
    this.mustChangePassword = false,
    this.requiresOnboarding = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as String?) ?? '',
      fullName: (json['fullName'] as String?) ?? '',
      phoneNumber: (json['phoneNumber'] as String?) ?? '',
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      phoneNumberVerified: (json['phoneNumberVerified'] as bool?) ?? false,
      mustChangePassword: (json['mustChangePassword'] as bool?) ?? false,
      requiresOnboarding: (json['requiresOnboarding'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'roles': roles,
      'permissions': permissions,
      'phoneNumberVerified': phoneNumberVerified,
      'mustChangePassword': mustChangePassword,
      'requiresOnboarding': requiresOnboarding,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    List<String>? roles,
    List<String>? permissions,
    bool? phoneNumberVerified,
    bool? mustChangePassword,
    bool? requiresOnboarding,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      roles: roles ?? this.roles,
      permissions: permissions ?? this.permissions,
      phoneNumberVerified: phoneNumberVerified ?? this.phoneNumberVerified,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
      requiresOnboarding: requiresOnboarding ?? this.requiresOnboarding,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        roles,
        permissions,
        phoneNumberVerified,
        mustChangePassword,
        requiresOnboarding,
      ];
}

