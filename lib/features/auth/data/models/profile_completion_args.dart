import 'package:equatable/equatable.dart';

/// Arguments passed from OtpVerificationPage to ProfileCompletionPage.
class ProfileCompletionArgs extends Equatable {
  final String phoneNumber;
  final String verificationToken;

  const ProfileCompletionArgs({
    required this.phoneNumber,
    required this.verificationToken,
  });

  @override
  List<Object?> get props => [phoneNumber, verificationToken];
}

