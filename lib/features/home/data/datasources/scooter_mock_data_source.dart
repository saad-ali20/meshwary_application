import '../models/scooter_model.dart';

abstract class ScooterDataSource {
  Future<List<ScooterModel>> getNearbyScooters({
    required double latitude,
    required double longitude,
    String? compoundId,
  });

  Future<ScooterModel> getScooterByCode(String code);
}

/// Local mock data source providing scooters.
class ScooterMockDataSource implements ScooterDataSource {
  const ScooterMockDataSource();

  static const List<ScooterModel> _mockScooters = [
    ScooterModel(
      id: 'scooter_shg_01',
      code: 'SCO-0005',
      latitude: 30.039413,
      longitude: 30.955367,
      battery: 100,
      distanceMeters: 120,
      status: ScooterStatus.available,
      pricePerMinute: 2.5,
    ),
    ScooterModel(
      id: 'scooter_shg_02',
      code: 'MS-102',
      latitude: 30.0543,
      longitude: 30.9631,
      battery: 94,
      distanceMeters: 410,
      status: ScooterStatus.available,
      pricePerMinute: 1.5,
    ),
    ScooterModel(
      id: 'scooter_shg_03',
      code: 'MS-103',
      latitude: 30.0612,
      longitude: 30.9618,
      battery: 67,
      distanceMeters: 620,
      status: ScooterStatus.available,
      pricePerMinute: 1.5,
    ),
    ScooterModel(
      id: 'scooter_shg_04',
      code: 'MS-104',
      latitude: 30.0518,
      longitude: 30.9678,
      battery: 76,
      distanceMeters: 750,
      status: ScooterStatus.available,
      pricePerMinute: 1.5,
    ),
    ScooterModel(
      id: 'scooter_shg_05',
      code: 'MS-105',
      latitude: 30.0632,
      longitude: 30.9683,
      battery: 53,
      distanceMeters: 980,
      status: ScooterStatus.available,
      pricePerMinute: 1.5,
    ),
    ScooterModel(
      id: 'scooter_shg_06',
      code: 'MS-106',
      latitude: 30.0492,
      longitude: 30.9624,
      battery: 21,
      distanceMeters: 1180,
      status: ScooterStatus.reserved,
      pricePerMinute: 1.5,
    ),
  ];

  @override
  Future<List<ScooterModel>> getNearbyScooters({
    required double latitude,
    required double longitude,
    String? compoundId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return List<ScooterModel>.unmodifiable(_mockScooters);
  }

  @override
  Future<ScooterModel> getScooterByCode(String code) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _mockScooters.firstWhere(
      (s) => s.code.toLowerCase() == code.toLowerCase(),
      orElse: () => _mockScooters.first,
    );
  }
}
