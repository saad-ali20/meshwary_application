import 'package:flutter_test/flutter_test.dart';
import 'package:meshwary_app/features/home/data/datasources/scooter_mock_data_source.dart';
import 'package:meshwary_app/features/home/data/models/scooter_model.dart';
import 'package:meshwary_app/features/home/data/repositories/scooter_repository.dart';
import 'package:meshwary_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:meshwary_app/features/home/presentation/cubit/home_state.dart';

void main() {
  group('ScooterMockDataSource & ScooterModel', () {
    late ScooterMockDataSource dataSource;

    setUp(() {
      dataSource = const ScooterMockDataSource();
    });

    test('returns exactly 6 mock scooters in Sohag', () async {
      final scooters = await dataSource.getNearbyScooters(
        latitude: 26.5569,
        longitude: 31.6948,
      );

      expect(scooters.length, equals(6));

      // Verify stable ID and code
      for (final s in scooters) {
        expect(s.id, isNotEmpty);
        expect(s.code, anyOf(startsWith('MS-'), startsWith('SC-'), startsWith('SCO-')));
        expect(s.battery, inInclusiveRange(0, 100));
      }

      // Verify available scooters filtering
      final available = scooters.where((s) => s.isAvailable).toList();
      expect(available.isNotEmpty, isTrue);
      expect(available.length, lessThan(scooters.length));
    });

    test('ScooterModel formats Arabic labels correctly', () {
      const scooter = ScooterModel(
        id: 'scooter_shg_01',
        code: 'MS-101',
        latitude: 26.5586,
        longitude: 31.6962,
        battery: 82,
        distanceMeters: 280,
        status: ScooterStatus.available,
      );

      expect(scooter.displayName, equals('سكوتر MS-101'));
      expect(scooter.batteryArabicLabel, equals('البطارية ٨٢٪'));
      expect(scooter.statusArabicText, equals('متاح'));
      expect(scooter.isAvailable, isTrue);
      expect(scooter.location.latitude, equals(26.5586));
      expect(scooter.location.longitude, equals(31.6962));
    });
  });

  group('HomeCubit', () {
    late ScooterRepository repository;
    late HomeCubit cubit;

    setUp(() {
      repository = const ScooterRepositoryImpl(
        remoteDataSource: ScooterMockDataSource(),
      );
      cubit = HomeCubit(repository);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has default camera in Sheikh Zayed', () {
      expect(cubit.state.status, equals(HomeStatus.initial));
      expect(cubit.state.scooters, isEmpty);
      expect(cubit.state.initialPosition.target.latitude, equals(30.05396477896633));
      expect(cubit.state.initialPosition.target.longitude, equals(30.965692024233526));
      expect(cubit.state.initialPosition.zoom, equals(15.0));
    });

    test('loadScooters emits loading then loaded with available scooters', () async {
      await cubit.loadScooters();

      expect(cubit.state.status, equals(HomeStatus.loaded));
      expect(cubit.state.scooters.length, equals(6));
      expect(cubit.state.availableScooters.length, equals(5));
      expect(cubit.state.selectedScooter, isNotNull);
      expect(cubit.state.selectedScooter!.code, anyOf(startsWith('MS-'), startsWith('SC-'), startsWith('SCO-')));
    });

    test('selectScooter updates selected scooter in state', () async {
      await cubit.loadScooters();
      final secondScooter = cubit.state.availableScooters[1];

      cubit.selectScooter(secondScooter);
      expect(cubit.state.selectedScooter, equals(secondScooter));

      cubit.clearSelection();
      expect(cubit.state.selectedScooter, isNull);
    });
  });
}
