import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/scooter_model.dart';
import 'scooter_mock_data_source.dart';

/// Remote data source that fetches nearby scooters and scooter details by code from the backend API.
class ScooterRemoteDataSource implements ScooterDataSource {
  final DioClient _dioClient;

  const ScooterRemoteDataSource(this._dioClient);

  @override
  Future<List<ScooterModel>> getNearbyScooters({
    required double latitude,
    required double longitude,
    String? compoundId,
    int limit = 20,
  }) async {
    final queryParameters = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'limit': limit,
    };

    if (compoundId != null && compoundId.isNotEmpty) {
      queryParameters['compoundId'] = compoundId;
    }

    final response = await _dioClient.get(
      '/api/mobile/scooters/nearby',
      queryParameters: queryParameters,
    );

    final raw = response.data;
    final List<dynamic> items;
    if (raw is List) {
      items = raw;
    } else if (raw is Map && raw['data'] is List) {
      items = raw['data'] as List;
    } else {
      items = const [];
    }

    return items
        .map((item) => ScooterModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ScooterModel> getScooterByCode(String code) async {
    final response = await _dioClient.get(
      '/api/mobile/scooters/by-code/$code',
    );

    final raw = response.data;
    final Map<String, dynamic> data;
    if (raw is Map<String, dynamic>) {
      if (raw['data'] is Map<String, dynamic>) {
        data = raw['data'] as Map<String, dynamic>;
      } else {
        data = raw;
      }
    } else {
      throw ServerException(
        'بيانات السكوتر غير صالحة',
        statusCode: response.statusCode ?? 500,
      );
    }

    return ScooterModel.fromJson(data);
  }
}
