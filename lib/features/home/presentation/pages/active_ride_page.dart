import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/scooter_model.dart';
import '../utils/map_style.dart';
import '../utils/marker_icon_generator.dart';

/// Screen 9: الرحلة النشطة (Active Ride)
/// Step 9 in the user journey:
/// - Top bar: "الرحلة النشطة"
/// - Live trip stats card: الوقت (12:36) | المسافة (3.4) | التكلفة (8 جنيه)
/// - Live Google Map with moving route line and scooter marker
/// - Floating scooter status card: SC-1024 · 78% بطارية
/// - Action buttons:
///   1. "إنهاء الرحلة" (End ride)
///   2. "SOS" emergency button
class ActiveRidePage extends StatefulWidget {
  const ActiveRidePage({super.key, required this.scooter});
  final ScooterModel? scooter;

  @override
  State<ActiveRidePage> createState() => _ActiveRidePageState();
}

class _ActiveRidePageState extends State<ActiveRidePage> {
  // Live ride ticking timer (starts at 12m 36s to match mockup or 00:01)
  int _seconds = 12 * 60 + 36;
  Timer? _timer;
  BitmapDescriptor? _scooterMarkerIcon;

  static const _sohagCenter = LatLng(26.5569, 31.6948);
  static const _routePoints = [
    LatLng(26.5569, 31.6948),
    LatLng(26.5580, 31.6960),
    LatLng(26.5595, 31.6975),
    LatLng(26.5610, 31.6990),
  ];

  @override
  void initState() {
    super.initState();
    _loadMarkerIcon();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  Future<void> _loadMarkerIcon() async {
    final icon = await MarkerIconGenerator.getAvailableMarkerIcon(isSelected: true);
    if (mounted) setState(() => _scooterMarkerIcon = icon);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timeLabel {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get _distanceKm => 3.4 + ((_seconds - (12 * 60 + 36)) * 0.005);

  double get _costEgp =>
      8.0 + ((_seconds - (12 * 60 + 36)) * (widget.scooter?.pricePerMinute ?? 2.5) / 60);

  void _showSosDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF140D0E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF4D4D).withAlpha(30),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFFF4D4D),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'طوارئ مشواري (SOS)',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'في حال حدوث أي عطل أو طارئ، يمكنك التواصل الفوري مع فريق الدعم وسيارات الإسناد في سوهاج على مدار الساعة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: Color(0xFFC79898),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4D4D),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white),
              label: const Text(
                'الاتصال بفريق الطوارئ',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmEndRide() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1E22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'إنهاء الرحلة',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'هل وصلت لوجهتك وتريد قفل السكوتر وإنهاء الرحلة الآن؟',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: Color(0xFF9CB9B2),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF071417),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${_costEgp.toStringAsFixed(1)} جنيه',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    _timeLabel,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'متابعة الرحلة',
              style: TextStyle(fontFamily: 'Cairo', color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.home);
            },
            child: const Text(
              'تأكيد وإنهاء',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w800,
                color: Color(0xFF071214),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final s = widget.scooter;
    final scooterCode = s?.code ?? 'SC-1024';
    final battery = s?.battery ?? 78;

    return Scaffold(
      backgroundColor: const Color(0xFF071214),
      body: Stack(
        children: [
          // ── Map View ────────────────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _sohagCenter,
              zoom: 15.5,
            ),
            style: MeshwaryMapStyle.dark,
            polylines: {
              Polyline(
                polylineId: const PolylineId('active_route'),
                points: _routePoints,
                color: AppColors.primary,
                width: 5,
              ),
            },
            markers: {
              Marker(
                markerId: const MarkerId('current_scooter_position'),
                position: _routePoints.last,
                icon: _scooterMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              ),
            },
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
          ),

          // ── Top Header & Stats Card ─────────────────────────────────────────
          Positioned(
            top: top + 10,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Title Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF071417).withAlpha(220),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF1E3A40)),
                  ),
                  child: const Center(
                    child: Text(
                      'الرحلة النشطة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 3 Stats Card: الوقت | المسافة | التكلفة
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1F24).withAlpha(240),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.primary.withAlpha(70),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(120),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Stat 1: الوقت
                      Expanded(
                        child: _StatMetricItem(
                          label: 'الوقت',
                          value: _timeLabel,
                          icon: Icons.access_time_filled_rounded,
                        ),
                      ),
                      Container(width: 1, height: 32, color: const Color(0xFF1E3A40)),
                      // Stat 2: المسافة
                      Expanded(
                        child: _StatMetricItem(
                          label: 'المسافة',
                          value: _distanceKm.toStringAsFixed(1),
                          unit: 'كم',
                          icon: Icons.place_rounded,
                        ),
                      ),
                      Container(width: 1, height: 32, color: const Color(0xFF1E3A40)),
                      // Stat 3: التكلفة
                      Expanded(
                        child: _StatMetricItem(
                          label: 'التكلفة',
                          value: _costEgp.toStringAsFixed(0),
                          unit: 'جنيه',
                          icon: Icons.payments_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom Panel: Scooter Card + End Ride Button + SOS Button ───────
          Positioned(
            bottom: bottom + 16,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Floating Scooter Status Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF071417).withAlpha(240),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF1E3A40)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Battery pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withAlpha(80)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.battery_charging_full_rounded,
                              color: AppColors.primary,
                              size: 15,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$battery%',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Scooter Code
                      Text(
                        scooterCode,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Action Row: End Ride Button + SOS Button
                Row(
                  children: [
                    // SOS Emergency Button
                    GestureDetector(
                      onTap: _showSosDialog,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF221113),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFFF4D4D),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF4D4D).withAlpha(75),
                              blurRadius: 14,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'SOS',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFF4D4D),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Primary Button: إنهاء الرحلة
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _confirmEndRide,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF57F56D), Color(0xFF38D952)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(80),
                                  blurRadius: 18,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.flag_rounded,
                                  color: Color(0xFF071214),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'إنهاء الرحلة',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF071214),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatMetricItem extends StatelessWidget {
  const _StatMetricItem({
    required this.label,
    required this.value,
    required this.icon,
    this.unit,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: Color(0xFF9CB9B2),
              ),
            ),
            const SizedBox(width: 4),
            Icon(icon, color: AppColors.primary, size: 14),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            if (unit != null) ...[
              const SizedBox(width: 3),
              Text(
                unit!,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A7A84),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
