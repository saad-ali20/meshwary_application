import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/models/scooter_model.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.scooters = const [],
    this.selectedScooter,
    this.errorMessage,
    this.initialPosition = const CameraPosition(
      target: LatLng(30.05396477896633, 30.965692024233526), // Sheikh Zayed, Egypt
      zoom: 15.0,
    ),
  });

  final HomeStatus status;
  final List<ScooterModel> scooters;
  final ScooterModel? selectedScooter;
  final String? errorMessage;
  final CameraPosition initialPosition;

  /// Only scooters with status == ScooterStatus.available
  List<ScooterModel> get availableScooters =>
      scooters.where((s) => s.isAvailable).toList(growable: false);

  HomeState copyWith({
    HomeStatus? status,
    List<ScooterModel>? scooters,
    ScooterModel? Function()? selectedScooter,
    String? Function()? errorMessage,
    CameraPosition? initialPosition,
  }) {
    return HomeState(
      status: status ?? this.status,
      scooters: scooters ?? this.scooters,
      selectedScooter:
          selectedScooter != null ? selectedScooter() : this.selectedScooter,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      initialPosition: initialPosition ?? this.initialPosition,
    );
  }

  @override
  List<Object?> get props => [
        status,
        scooters,
        selectedScooter,
        errorMessage,
        initialPosition,
      ];
}
