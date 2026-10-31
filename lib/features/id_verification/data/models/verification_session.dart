/// Holds all data collected during the identity verification flow.
/// Passed as [extra] through go_router between verification screens.
class VerificationSession {
  final String fullName;
  final String phoneNumber;
  String? idFrontPath;
  String? idBackPath;
  String? selfiePath;
  String? dateOfBirth; // YYYY/MM/DD

  VerificationSession({
    required this.fullName,
    required this.phoneNumber,
    this.idFrontPath,
    this.idBackPath,
    this.selfiePath,
    this.dateOfBirth,
  });

  bool get idFrontCaptured => idFrontPath != null && idFrontPath!.isNotEmpty;
  bool get idBackCaptured => idBackPath != null && idBackPath!.isNotEmpty;
  bool get selfieCaptured => selfiePath != null && selfiePath!.isNotEmpty;
  bool get isComplete => idFrontCaptured && idBackCaptured && selfieCaptured;
}
