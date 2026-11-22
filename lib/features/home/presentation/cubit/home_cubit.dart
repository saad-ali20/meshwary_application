import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/scooter_model.dart';
import '../../data/repositories/scooter_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._scooterRepository) : super(const HomeState());

  final ScooterRepository _scooterRepository;

  Future<void> loadScooters({String? compoundId}) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final scooters = await _scooterRepository.getNearbyScooters(
        latitude: state.initialPosition.target.latitude,
        longitude: state.initialPosition.target.longitude,
        compoundId: compoundId,
      );

      final available = scooters.where((s) => s.isAvailable).toList();
      final defaultSelected = available.isNotEmpty ? available.first : null;

      emit(
        state.copyWith(
          status: HomeStatus.loaded,
          scooters: scooters,
          selectedScooter: () => defaultSelected,
          errorMessage: () => null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: () => e.toString(),
        ),
      );
    }
  }

  void selectScooter(ScooterModel? scooter) {
    emit(state.copyWith(selectedScooter: () => scooter));
  }

  void clearSelection() {
    emit(state.copyWith(selectedScooter: () => null));
  }
}
