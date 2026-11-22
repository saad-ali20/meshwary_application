// ignore_for_file: prefer_initializing_formals
import '../datasources/scooter_mock_data_source.dart';
import '../models/scooter_model.dart';

abstract class ScooterRepository {
  Future<List<ScooterModel>> getNearbyScooters({
    required double latitude,
    required double longitude,
    String? compoundId,
  });

  Future<ScooterModel> getScooterByCode(String code);
}

class ScooterRepositoryImpl implements ScooterRepository {
  const ScooterRepositoryImpl({
    required ScooterDataSource remoteDataSource,
    ScooterDataSource? mockDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _mockDataSource = mockDataSource;

  final ScooterDataSource _remoteDataSource;
  final ScooterDataSource? _mockDataSource;

  @override
  Future<List<ScooterModel>> getNearbyScooters({
    required double latitude,
    required double longitude,
    String? compoundId,
  }) async {
    try {
      final scooters = await _remoteDataSource.getNearbyScooters(
        latitude: latitude,
        longitude: longitude,
        compoundId: compoundId,
      );
      if (scooters.isNotEmpty) {
        return scooters;
      }
      return scooters;
    } catch (e) {
      if (_mockDataSource != null) {
        return _mockDataSource.getNearbyScooters(
          latitude: latitude,
          longitude: longitude,
          compoundId: compoundId,
        );
      }
      rethrow;
    }
  }

  @override
  Future<ScooterModel> getScooterByCode(String code) async {
    try {
      return await _remoteDataSource.getScooterByCode(code);
    } catch (e) {
      if (_mockDataSource != null) {
        return _mockDataSource.getScooterByCode(code);
      }
      rethrow;
    }
  }
}
