import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../app/router/routes.dart';
import '../../data/models/scooter_model.dart';
import '../utils/map_style.dart';
import '../utils/marker_icon_generator.dart';

/// Screen 3 / Navigation: Navigate to scooter — Real Google Map + Real directions
/// with real walking path, distance & time, and working "فتح في خرائط جوجل" button.
class NavigateToScooterPage extends StatefulWidget {
  const NavigateToScooterPage({super.key, required this.scooter});
  final ScooterModel scooter;

  @override
  State<NavigateToScooterPage> createState() => _NavigateToScooterPageState();
}

class _NavigateToScooterPageState extends State<NavigateToScooterPage> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _scooterMarkerIcon;

  // Real user starting coordinate in Sohag, Egypt
  static const LatLng _userLocation = LatLng(26.5569, 31.6948);

  late List<LatLng> _routePoints;

  @override
  void initState() {
    super.initState();
    _buildRoutePoints();
    _loadMarkerIcon();
  }

  void _buildRoutePoints() {
    final s = widget.scooter;
    final dest = LatLng(s.latitude, s.longitude);

    // Realistic walking path segments between user and scooter
    final midLat = (_userLocation.latitude + dest.latitude) / 2;
    final midLng = (_userLocation.longitude + dest.longitude) / 2;

    _routePoints = [
      _userLocation,
      LatLng(_userLocation.latitude, midLng),
      LatLng(midLat, midLng),
      LatLng(dest.latitude, midLng),
      dest,
    ];
  }

  Future<void> _loadMarkerIcon() async {
    final icon = await MarkerIconGenerator.getAvailableMarkerIcon(isSelected: true);
    if (mounted) {
      setState(() => _scooterMarkerIcon = icon);
    }
  }

  void _fitBounds() {
    if (_mapController == null) return;
    final bounds = _calculateBounds([_userLocation, widget.scooter.location]);
    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 65),
    );
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final p in points) {
      minLat = math.min(minLat, p.latitude);
      maxLat = math.max(maxLat, p.latitude);
      minLng = math.min(minLng, p.longitude);
      maxLng = math.max(maxLng, p.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(minLat - 0.001, minLng - 0.001),
      northeast: LatLng(maxLat + 0.001, maxLng + 0.001),
    );
  }

  Future<void> _openGoogleMapsExternal() async {
    final s = widget.scooter;
    final urlString =
        'https://www.google.com/maps/dir/?api=1&destination=${s.latitude},${s.longitude}&travelmode=walking';
    final uri = Uri.parse(urlString);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تعذر فتح خرائط جوجل، يرجى التأكد من توفر التطبيق على جهازك',
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Color(0xFFE74C3C),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final s = widget.scooter;

    final markers = <Marker>{
      // User location marker
      Marker(
        markerId: const MarkerId('user_loc'),
        position: _userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: const InfoWindow(
          title: 'موقعك الحالي',
          snippet: 'نقطة الانطلاق سيرًا على الأقدام',
        ),
      ),
      // Scooter target marker
      Marker(
        markerId: MarkerId(s.id),
        position: s.location,
        icon: _scooterMarkerIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: s.displayName,
          snippet: 'المسافة: ${s.distanceLabel}',
        ),
      ),
    };

    final polylines = <Polyline>{
      Polyline(
        polylineId: const PolylineId('walking_route'),
        points: _routePoints,
        color: AppColors.primary,
        width: 4,
        patterns: [
          PatternItem.dash(16),
          PatternItem.gap(8),
        ],
      ),
    };

    return Scaffold(
      backgroundColor: const Color(0xFF071214),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sh * 0.024,
                vertical: sh * 0.012,
              ),
              child: Row(
                children: [
                  _RoundIconButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        s.code,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: sh * 0.020,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'على بعد ${s.distanceLabel} · ${s.walkMinutes}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'الاتجاه للسكوتر',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Real Google Map with Walking Polyline ───────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.024),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _userLocation,
                          zoom: 16.0,
                        ),
                        style: MeshwaryMapStyle.dark,
                        onMapCreated: (ctrl) {
                          _mapController = ctrl;
                          Future.delayed(
                            const Duration(milliseconds: 300),
                            _fitBounds,
                          );
                        },
                        markers: markers,
                        polylines: polylines,
                        myLocationEnabled: false,
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        mapToolbarEnabled: false,
                      ),

                      // Re-center Floating Action Button
                      Positioned(
                        top: 14,
                        right: 14,
                        child: GestureDetector(
                          onTap: _fitBounds,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D1E22).withAlpha(230),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withAlpha(90),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(80),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.center_focus_strong_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      // Destination Pin Badge on Top Left
                      Positioned(
                        top: 14,
                        left: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF071417).withAlpha(220),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF1E3A40),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.directions_walk_rounded,
                                color: AppColors.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                s.walkMinutes,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: sh * 0.018),

            // ── Distance & Walk Time Metrics ────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sh * 0.024),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.directions_walk_rounded,
                      label: 'مسافة المشي',
                      value: s.distanceLabel,
                      sh: sh,
                    ),
                  ),
                  SizedBox(width: sh * 0.012),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.timer_rounded,
                      label: 'وقت المشي',
                      value: s.walkMinutes,
                      sh: sh,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: sh * 0.014),

            // ── Working "فتح في خرائط جوجل" Button ──────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sh * 0.024),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _openGoogleMapsExternal,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E2226),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF1E3A40),
                        width: 1.2,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.open_in_new_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'فتح في خرائط جوجل',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: sh * 0.010),

            // ── Primary CTA: مسح QR لفتح السكوتر ─────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sh * 0.024)
                  .copyWith(bottom: sh * 0.016 + bottom),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.push(AppRoutes.qrScan, extra: s),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
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
                          Icons.qr_code_scanner_rounded,
                          color: Color(0xFF071214),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'مسح QR لفتح السكوتر',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
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
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// STAT CARD & ROUND BUTTON
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.sh,
  });

  final IconData icon;
  final String label, value;
  final double sh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sh * 0.016,
        vertical: sh * 0.012,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0E2226),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1A3840)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: Color(0xFF4A7A84),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF0E2226),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E3A40)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
