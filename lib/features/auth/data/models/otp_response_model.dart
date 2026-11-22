import 'package:equatable/equatable.dart';

/// Response data returned from `request-otp` endpoint.
class OtpResponseModel extends Equatable {
  final String? expiresAtUtc;
  final int resendAfterSeconds;

  const OtpResponseModel({
    this.expiresAtUtc,
    this.resendAfterSeconds = 60,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      expiresAtUtc: json['expiresAtUtc'] as String?,
      resendAfterSeconds: (json['resendAfterSeconds'] as num?)?.toInt() ?? 60,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expiresAtUtc': expiresAtUtc,
      'resendAfterSeconds': resendAfterSeconds,
    };
  }

  @override
  List<Object?> get props => [expiresAtUtc, resendAfterSeconds];
}

