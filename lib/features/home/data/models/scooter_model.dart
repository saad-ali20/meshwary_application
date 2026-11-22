import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/models/compound.dart';

enum ScooterStatus { available, reserved, inUse, maintenance }

/// Represents a single scooter on the map and throughout the ride booking flow.
class ScooterModel extends Equatable {
  const ScooterModel({
    required this.id,
    required this.code,
    required this.latitude,
    required this.longitude,
    required this.battery,
    required this.distanceMeters,
    required this.status,
    this.pricePerMinute = 1.5,
    this.compound,
    this.isRideable = true,
    this.notRideableReason,
    this.mainImageUrl,
  });

  /// Stable unique identifier (e.g. 'scooter_shg_01')
  final String id;

  /// Visible display code (e.g. 'SCO-0005')
  final String code;

  /// GPS Latitude
  final double latitude;

  /// GPS Longitude
  final double longitude;

  /// Battery percentage (0-100)
  final int battery;

  /// Walking / straight-line distance in meters
  final double distanceMeters;

  /// Current availability status
  final ScooterStatus status;

  /// Price per minute in Egyptian Pounds (EGP)
  final double pricePerMinute;

  /// Residential compound info
  final Compound? compound;

  /// Whether scooter can be unlocked & ridden
  final bool isRideable;

  /// Explanation if scooter cannot be ridden
  final String? notRideableReason;

  /// Optional image URL returned by the backend
  final String? mainImageUrl;

  /// Factory to create a model from the backend JSON.
  factory ScooterModel.fromJson(Map<String, dynamic> json) {
    final compound = json['compound'] as Map<String, dynamic>?;
    final location = json['location'] as Map<String, dynamic>?;
    final double lat = (location?['latitude'] as num?)?.toDouble() ?? 0.0;
    final double lng = (location?['longitude'] as num?)?.toDouble() ?? 0.0;
    final int battery = (json['batteryPercent'] as num?)?.toInt() ?? 0;
    final double distanceMeters =
        (json['distanceMeters'] as num?)?.toDouble() ?? 0.0;

    return ScooterModel(
      id: (json['id'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      latitude: lat,
      longitude: lng,
      battery: battery,
      distanceMeters: distanceMeters,
      status: _statusFromRideability(
        json['rideability'] as String?,
        json['isRideable'] as bool?,
      ),
      pricePerMinute: (json['pricePerMinute'] as num?)?.toDouble() ?? 1.5,
      compound: compound != null ? Compound.fromJson(compound) : null,
      isRideable: json['isRideable'] as bool? ??
          (json['rideability']?.toString().toLowerCase() == 'rideable'),
      notRideableReason: json['notRideableReason'] as String?,
      mainImageUrl: json['mainImageUrl'] as String?,
    );
  }

  static ScooterStatus _statusFromRideability(
    String? rideability,
    bool? isRideableFlag,
  ) {
    if (isRideableFlag != null && !isRideableFlag) {
      return ScooterStatus.maintenance;
    }
    switch (rideability?.toLowerCase()) {
      case 'rideable':
        return ScooterStatus.available;
      case 'reserved':
        return ScooterStatus.reserved;
      case 'inuse':
        return ScooterStatus.inUse;
      default:
        return (isRideableFlag == true)
            ? ScooterStatus.available
            : ScooterStatus.maintenance;
    }
  }

  /// Convenience getter for Google Maps coordinate
  LatLng get location => LatLng(latitude, longitude);

  bool get isAvailable => status == ScooterStatus.available && isRideable;

  String get distanceLabel {
    if (distanceMeters <= 0) return 'قريب منك';
    if (distanceMeters < 1000) return '${distanceMeters.round()} م';
    return '${(distanceMeters / 1000).toStringAsFixed(1)} كم';
  }

  String get walkMinutes {
    if (distanceMeters <= 0) return 'دقيقة واحدة';
    final mins = (distanceMeters / 83).ceil();
    return '$mins دقيقة';
  }

  String get batteryLabel => '$battery%';

  /// Compact Arabic label with Eastern Arabic numerals, e.g. "البطارية ٨٢٪"
  String get batteryArabicLabel {
    const arabicNumbers = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };
    final numStr = battery
        .toString()
        .split('')
        .map((ch) => arabicNumbers[ch] ?? ch)
        .join();
    return 'البطارية $numStr٪';
  }

  /// Compact display title, e.g. "سكوتر SCO-0005"
  String get displayName => 'سكوتر $code';

  /// Arabic status text
  String get statusArabicText {
    if (!isRideable) return 'غير متاح للركوب';
    switch (status) {
      case ScooterStatus.available:
        return 'متاح';
      case ScooterStatus.reserved:
        return 'محجوز';
      case ScooterStatus.inUse:
        return 'قيد الاستخدام';
      case ScooterStatus.maintenance:
        return 'صيانة';
    }
  }

  /// Kept for backward compatibility with previous pages
  double get relX => 0.5;
  double get relY => 0.5;

  @override
  List<Object?> get props => [
        id,
        code,
        latitude,
        longitude,
        battery,
        distanceMeters,
        status,
        pricePerMinute,
        compound,
        isRideable,
        notRideableReason,
        mainImageUrl,
      ];
}
