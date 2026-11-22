import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di/injection.dart';
import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../data/models/scooter_model.dart';
import '../cubit/compound_cubit.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../utils/map_style.dart';
import '../utils/marker_icon_generator.dart';
import '../widgets/compound_selection_sheet.dart';

/// Meshwary Home Map screen centered in Sheikh Zayed, Egypt.
/// Integrates Google Maps with custom dark styling, neon green accents,
/// compound-based scooter markers with compact Arabic details bottom sheet.
class HomeMapPage extends StatelessWidget {
  const HomeMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CompoundCubit>.value(value: getIt<CompoundCubit>()),
        BlocProvider<HomeCubit>(create: (_) => getIt<HomeCubit>()),
      ],
      child: const _HomeMapView(),
    );
  }
}

class _HomeMapView extends StatefulWidget {
  const _HomeMapView();

  @override
  State<_HomeMapView> createState() => _HomeMapViewState();
}

class _HomeMapViewState extends State<_HomeMapView> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _normalMarkerIcon;
  BitmapDescriptor? _selectedMarkerIcon;

  @override
  void initState() {
    super.initState();
    _loadMarkerIcons();

    // Trigger initial compound resolution and subsequent scooter load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final compoundCubit = context.read<CompoundCubit>();
      final homeCubit = context.read<HomeCubit>();

      if (compoundCubit.state.status == CompoundStatus.initial) {
        compoundCubit.loadInitial();
      } else if (compoundCubit.state.status == CompoundStatus.selected) {
        homeCubit.loadScooters(compoundId: compoundCubit.state.compound?.id);
      } else if (compoundCubit.state.status == CompoundStatus.needsSelection) {
        _showCompoundSelectionSheet();
      }
    });
  }

  void _showCompoundSelectionSheet() {
    final currentCompound = context.read<CompoundCubit>().state.compound;
    CompoundSelectionSheet.show(context, currentCompound: currentCompound);
  }

  Future<void> _loadMarkerIcons() async {
    final normal = await MarkerIconGenerator.getAvailableMarkerIcon(
      isSelected: false,
    );
    final selected = await MarkerIconGenerator.getAvailableMarkerIcon(
      isSelected: true,
    );
    if (mounted) {
      setState(() {
        _normalMarkerIcon = normal;
        _selectedMarkerIcon = selected;
      });
    }
  }

  void _centerOnDefaultLocation(LatLng target) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 15.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final top = MediaQuery.paddingOf(context).top;
    final bottomSheetHeight = (sh * 0.32).clamp(240.0, 310.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0B1618),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CompoundCubit, CompoundState>(
            listener: (context, compoundState) {
              if (compoundState.status == CompoundStatus.selected) {
                // Whenever compound is determined or updated, refresh scooters!
                context.read<HomeCubit>().loadScooters(
                  compoundId: compoundState.compound?.id,
                );
              } else if (compoundState.status ==
                  CompoundStatus.needsSelection) {
                _showCompoundSelectionSheet();
              }
            },
          ),
          BlocListener<HomeCubit, HomeState>(
            listenWhen: (prev, curr) =>
                prev.selectedScooter != curr.selectedScooter,
            listener: (context, state) {
              final s = state.selectedScooter;
              if (s != null) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(s.location),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            // Show only available scooters as selectable markers
            final markers = <Marker>{};
            for (final s in state.availableScooters) {
              final isSel = state.selectedScooter?.id == s.id;
              final icon = isSel
                  ? (_selectedMarkerIcon ??
                        BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen,
                        ))
                  : (_normalMarkerIcon ??
                        BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen,
                        ));

              markers.add(
                Marker(
                  markerId: MarkerId(s.id),
                  position: s.location,
                  icon: icon,
                  zIndexInt: isSel ? 3 : 1,
                  infoWindow: InfoWindow(
                    title: s.displayName,
                    snippet: '${s.batteryArabicLabel} · ${s.statusArabicText}',
                    onTap: () {
                      context.push(AppRoutes.scooterDetails, extra: s);
                    },
                  ),
                  onTap: () {
                    context.read<HomeCubit>().selectScooter(s);
                  },
                ),
              );
            }

            return Stack(
              children: [
                // ── GOOGLE MAPS ───────────────────────────────────────────────
                GoogleMap(
                  initialCameraPosition: state.initialPosition,
                  style: MeshwaryMapStyle.dark,
                  onMapCreated: (ctrl) {
                    _mapController = ctrl;
                  },
                  markers: markers,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  mapToolbarEnabled: false,
                  padding: EdgeInsets.only(
                    top: top + 64,
                    bottom: bottomSheetHeight + 10,
                    left: 12,
                    right: 12,
                  ),
                ),

                // ── Search & Compound selector bar ─────────────────────────────
                Positioned(
                  top: top + 10,
                  left: 16,
                  right: 16,
                  child: const _SearchBar(),
                ),

                // ── Re-center FAB ─────────────────────────────────────────────
                Positioned(
                  right: 16,
                  bottom: bottomSheetHeight + 16,
                  child: _LocationFab(
                    onTap: () =>
                        _centerOnDefaultLocation(state.initialPosition.target),
                  ),
                ),

                // ── Bottom Sheet with Scooter preview ─────────────────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _BottomSheet(
                    scooters: state.scooters,
                    availableCount: state.availableScooters.length,
                    selected: state.selectedScooter,
                    onSelect: (s) {
                      context.read<HomeCubit>().selectScooter(s);
                    },
                    onDetails: (s) =>
                        context.push(AppRoutes.scooterDetails, extra: s),
                    onQR: () => context.push(
                      AppRoutes.qrScan,
                      extra: state.selectedScooter,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// SEARCH BAR
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompoundCubit, CompoundState>(
      builder: (context, compoundState) {
        final compound = compoundState.compound;
        final compoundTitle = compound != null
            ? compound.name
            : 'اختر المجمع السكني';

        return GestureDetector(
          onTap: () {
            CompoundSelectionSheet.show(context, currentCompound: compound);
          },
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F2024).withAlpha(245),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: compound != null
                    ? AppColors.primary.withAlpha(120)
                    : const Color(0xFF1E3A40),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(120),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Change compound pill / icon
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary.withAlpha(60)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.tune_rounded,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'تغيير',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Compound name & hint
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              compoundTitle,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                            size: 16,
                          ),
                        ],
                      ),
                      const Text(
                        'سكوترات المجمع المتاحة',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          color: Color(0xFF6C9199),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Apartment / Compound icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF142B30),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF1E3A40)),
                  ),
                  child: const Icon(
                    Icons.apartment_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// LOCATION FAB
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _LocationFab extends StatelessWidget {
  const _LocationFab({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(23),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF0F2024),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF1E3A40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(80),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.my_location_rounded,
            color: AppColors.primary,
            size: 22,
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// BOTTOM SHEET (PREVIEW UI)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({
    required this.scooters,
    required this.availableCount,
    required this.selected,
    required this.onSelect,
    required this.onDetails,
    required this.onQR,
  });

  final List<ScooterModel> scooters;
  final int availableCount;
  final ScooterModel? selected;
  final ValueChanged<ScooterModel> onSelect;
  final ValueChanged<ScooterModel> onDetails;
  final VoidCallback onQR;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D1E22),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        border: Border(top: BorderSide(color: Color(0xFF1E3A40))),
        boxShadow: [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF2A4A52),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 12),

          // ── Header: Available count in Sohag ─────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                const Spacer(),
                Text(
                  '$availableCount سكوترات متاحة  ',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.electric_scooter_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Horizontal scooter chips ────────────────────────────────────
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: scooters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final s = scooters[i];
                final isSel = selected?.id == s.id;
                final isAvail = s.isAvailable;
                return GestureDetector(
                  onTap: () => onSelect(s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSel
                          ? AppColors.primary.withAlpha(25)
                          : const Color(0xFF122228),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSel
                            ? AppColors.primary
                            : (isAvail
                                  ? const Color(0xFF1E3A40)
                                  : const Color(0xFF3B2020)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.electric_scooter_rounded,
                          color: isSel
                              ? AppColors.primary
                              : (isAvail
                                    ? const Color(0xFF4A7A84)
                                    : const Color(0xFF7E3838)),
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          s.code,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSel
                                ? AppColors.primary
                                : (isAvail ? Colors.white70 : Colors.white38),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // ── Selected scooter preview card ───────────────────────────────
          if (selected != null)
            GestureDetector(
              onTap: () => onDetails(selected!),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF112229),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withAlpha(
                      selected!.isAvailable ? 60 : 30,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Left arrow indicator
                    const Icon(
                      Icons.chevron_left_rounded,
                      color: Color(0xFF4A7A84),
                      size: 22,
                    ),

                    const SizedBox(width: 8),

                    // Scooter details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top row: Battery (left) + Name (right)
                          Row(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _BatteryBar(battery: selected!.battery),
                                  const SizedBox(width: 5),
                                  Text(
                                    selected!.batteryArabicLabel,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 12,
                                      color: _batteryColor(selected!.battery),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  selected!.displayName,
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Bottom row: Status (left) + Distance (right)
                          Row(
                            children: [
                              _StatusChip(status: selected!.status),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${selected!.walkMinutes} · ${selected!.distanceLabel}',
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    color: Color(0xFF4A7A84),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Scooter image thumbnail
                    Container(
                      width: 62,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF071417),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(60),
                        ),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/Neon Green Electric Scooter Icon-3.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.electric_scooter_rounded,
                            color: selected!.isAvailable
                                ? AppColors.primary
                                : const Color(0xFFE67E22),
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 12),

          // ── QR / Scan button ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _QRButton(onTap: onQR),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Color _batteryColor(int b) {
    if (b > 60) return AppColors.primary;
    if (b > 30) return const Color(0xFFE6B020);
    return const Color(0xFFE74C3C);
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// SHARED DETAIL WIDGETS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _BatteryBar extends StatelessWidget {
  const _BatteryBar({required this.battery});
  final int battery;

  Color get _color {
    if (battery > 60) return AppColors.primary;
    if (battery > 30) return const Color(0xFFE6B020);
    return const Color(0xFFE74C3C);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 12,
      decoration: BoxDecoration(
        color: const Color(0xFF1A3038),
        borderRadius: BorderRadius.circular(3),
      ),
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: (battery / 100).clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final ScooterStatus status;

  @override
  Widget build(BuildContext context) {
    final Color c;
    final String label;

    switch (status) {
      case ScooterStatus.available:
        c = AppColors.primary;
        label = 'متاح';
        break;
      case ScooterStatus.reserved:
        c = const Color(0xFFE67E22);
        label = 'محجوز';
        break;
      case ScooterStatus.inUse:
        c = const Color(0xFF3498DB);
        label = 'قيد الاستخدام';
        break;
      case ScooterStatus.maintenance:
        c = const Color(0xFFE74C3C);
        label = 'صيانة';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: c.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.withAlpha(80)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: c,
        ),
      ),
    );
  }
}

class _QRButton extends StatefulWidget {
  const _QRButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_QRButton> createState() => _QRButtonState();
}

class _QRButtonState extends State<_QRButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(90),
                blurRadius: 18,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'امسح QR لبدء الرحلة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF091215),
                ),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.qr_code_scanner_rounded,
                color: Color(0xFF091215),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
