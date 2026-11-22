import 'package:dio/dio.dart';
import '../../../../core/models/compound.dart';

/// Repository responsible for fetching and updating the rider's compound information.
class CompoundRepository {
  CompoundRepository(this._dio);

  final Dio _dio;

  /// Fetch the rider profile which may contain the default compound.
  Future<Compound?> fetchProfile() async {
    final response = await _dio.get('/api/mobile/account/profile');
    final raw = response.data;
    final Map<String, dynamic> data = raw is Map<String, dynamic>
        ? (raw['data'] is Map<String, dynamic>
            ? raw['data'] as Map<String, dynamic>
            : raw)
        : {};

    final defaultCompound = data['defaultCompound'];
    if (defaultCompound == null) return null;
    return Compound.fromJson(defaultCompound as Map<String, dynamic>);
  }

  /// Suggest a compound based on the current GPS location.
  Future<Compound?> suggestByLocation({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.get(
      '/api/mobile/compounds/suggest',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
      },
    );
    final raw = response.data;
    final Map<String, dynamic> data = raw is Map<String, dynamic>
        ? (raw['data'] is Map<String, dynamic>
            ? raw['data'] as Map<String, dynamic>
            : raw)
        : {};

    if (data.isEmpty || data['id'] == null) {
      if (raw is Map && raw['data'] != null && raw['data'] is Map) {
        return Compound.fromJson(raw['data'] as Map<String, dynamic>);
      }
      return null;
    }
    return Compound.fromJson(data);
  }

  /// List active compounds (used for manual selection).
  Future<List<Compound>> listCompounds({
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    final response = await _dio.get(
      '/api/mobile/compounds',
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );

    final raw = response.data;
    final List<dynamic> items;
    if (raw is List) {
      items = raw;
    } else if (raw is Map && raw['data'] is List) {
      items = raw['data'] as List;
    } else if (raw is Map && raw['items'] is List) {
      items = raw['items'] as List;
    } else {
      items = const [];
    }

    return items
        .map((e) => Compound.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Save the selected default compound for the rider.
  Future<void> setDefaultCompound(String? compoundId) async {
    await _dio.put(
      '/api/mobile/account/default-compound',
      data: {
        'compoundId': compoundId,
      },
    );
  }
}
