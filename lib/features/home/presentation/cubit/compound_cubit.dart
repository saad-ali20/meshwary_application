import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/models/compound.dart';
import '../../domain/repositories/compound_repository.dart';

part 'compound_state.dart';

/// Cubit responsible for handling the rider's selected compound.
///
/// Workflow:
/// 1. Try to load the default compound from the profile.
/// 2. If none, try GPS suggestion (defaulting to Sheikh Zayed if unavailable).
/// 3. If still none, emit [CompoundState.needsSelection] (UI shows selection sheet).
/// 4. When the user selects a compound, save it via the repository and emit
///    [CompoundState.selected].
class CompoundCubit extends Cubit<CompoundState> {
  CompoundCubit(this._repository) : super(const CompoundState.initial());

  final CompoundRepository _repository;

  /// Default coordinates (Sheikh Zayed, Giza, Egypt)
  static const double defaultLatitude = 30.05396477896633;
  static const double defaultLongitude = 30.965692024233526;

  /// Load the initial compound according to the specification.
  Future<void> loadInitial() async {
    emit(const CompoundState.loading());
    try {
      // 1️⃣ Try profile default compound.
      final defaultCompound = await _repository.fetchProfile();
      if (defaultCompound != null) {
        emit(CompoundState.selected(defaultCompound));
        return;
      }

      // 2️⃣ Try GPS suggestion (falling back to Sheikh Zayed default coordinates).
      double lat = defaultLatitude;
      double lng = defaultLongitude;
      try {
        final position = await _determinePosition();
        lat = position.latitude;
        lng = position.longitude;
      } catch (_) {
        // Fallback to default coordinates for Sheikh Zayed
        lat = defaultLatitude;
        lng = defaultLongitude;
      }

      final suggested = await _repository.suggestByLocation(
        latitude: lat,
        longitude: lng,
      );

      if (suggested != null) {
        // Save as default for future launches.
        await _repository.setDefaultCompound(suggested.id);
        emit(CompoundState.selected(suggested));
        return;
      }

      // 3️⃣ No compound found by location – require manual selection.
      emit(const CompoundState.needsSelection());
    } catch (_) {
      // If profile or suggest fails, let the user choose manually
      emit(const CompoundState.needsSelection());
    }
  }

  /// Called when the user selects a compound manually.
  Future<void> selectCompound(Compound compound) async {
    emit(const CompoundState.loading());
    try {
      await _repository.setDefaultCompound(compound.id);
    } catch (_) {
      // Even if saving default compound fails on backend, continue with selected compound locally
    }
    emit(CompoundState.selected(compound));
  }

  /// Fetch active compounds list for manual selection UI.
  Future<List<Compound>> loadAvailableCompounds() async {
    try {
      return await _repository.listCompounds();
    } catch (_) {
      return const [];
    }
  }

  /// Request manual selection UI explicitly (e.g. from top bar selector).
  void requestManualSelection() {
    emit(CompoundState.needsSelection(current: state.compound));
  }

  /// Helper to get current location (asks permissions if needed).
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
      timeLimit: const Duration(seconds: 4),
    );
  }
}
