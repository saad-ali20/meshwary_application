import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di/injection.dart';
import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/scooter_model.dart';
import '../../data/repositories/scooter_repository.dart';
import '../widgets/scooter_hero_view.dart';

/// Screen 2: تفاصيل السكوتر
/// Displays full details for the selected scooter:
/// - Code, battery %, status, rideability
/// - Dynamic Compound info (e.g. الشيخ زايد)
/// - Fetches live data via GET /api/mobile/scooters/by-code/{code}
/// - Action buttons to Reserve or Start Ride
class ScooterDetailsPage extends StatefulWidget {
  const ScooterDetailsPage({
    super.key,
    this.scooter,
    this.code,
  });

  final ScooterModel? scooter;
  final String? code;

  const ScooterDetailsPage.fromCode({
    super.key,
    required this.code,
  }) : scooter = null;

  @override
  State<ScooterDetailsPage> createState() => _ScooterDetailsPageState();
}

class _ScooterDetailsPageState extends State<ScooterDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  ScooterModel? _scooter;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _scooter = widget.scooter;

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _loadLiveDetails();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _loadLiveDetails() async {
    final codeToFetch = widget.scooter?.code ?? widget.code;
    if (codeToFetch == null || codeToFetch.isEmpty) return;

    if (_scooter == null) {
      setState(() => _isLoading = true);
    }

    try {
      final repo = getIt<ScooterRepository>();
      final fresh = await repo.getScooterByCode(codeToFetch);
      if (mounted) {
        setState(() {
          _scooter = fresh;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (_scooter == null) {
            _errorMessage = 'تعذر تحميل بيانات السكوتر ($codeToFetch)';
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final bottom = MediaQuery.paddingOf(context).bottom;

    if (_isLoading && _scooter == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF071214),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_errorMessage != null && _scooter == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF071214),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: AppColors.error, size: 48),
                  const SizedBox(height: 14),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: _loadLiveDetails,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('إعادة المحاولة',
                        style: TextStyle(fontFamily: 'Cairo')),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('رجوع',
                        style: TextStyle(
                            fontFamily: 'Cairo', color: Colors.white70)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final s = _scooter!;
    final compoundName = s.compound?.name ?? 'الشيخ زايد';

    return Scaffold(
      backgroundColor: const Color(0xFF071214),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Top Bar ──────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      _RoundIconButton(
                        icon: Icons.chevron_left_rounded,
                        onTap: () => context.pop(),
                      ),
                      // Title
                      const Text(
                        'تفاصيل السكوتر',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      // Favorite Toggle
                      _RoundIconButton(
                        icon: _isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: _isFavorite ? AppColors.primary : Colors.white,
                        onTap: () {
                          setState(() => _isFavorite = !_isFavorite);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isFavorite
                                    ? 'تمت إضافة السكوتر إلى المفضلة'
                                    : 'تمت إزالة السكوتر من المفضلة',
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              duration: const Duration(seconds: 1),
                              backgroundColor: const Color(0xFF0F262B),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // ── Scrollable Body ──────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 6),

                        // ── Scooter Hero Visual ──────────────────────────────
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const RadialGradient(
                              center: Alignment(0, 0.2),
                              radius: 0.9,
                              colors: [Color(0xFF0E2A2E), Color(0xFF071417)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.primary.withAlpha(45),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: (s.mainImageUrl != null &&
                                  s.mainImageUrl!.isNotEmpty)
                              ? Image.network(
                                  s.mainImageUrl!,
                                  height: (sh * 0.27).clamp(190.0, 240.0),
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, error, stackTrace) => ScooterHeroView(
                                    height: (sh * 0.27).clamp(190.0, 240.0),
                                    imagePath:
                                        'assets/images/Neon Green Electric Scooter Icon-3.png',
                                  ),
                                )
                              : ScooterHeroView(
                                  height: (sh * 0.27).clamp(190.0, 240.0),
                                  imagePath:
                                      'assets/images/Neon Green Electric Scooter Icon-3.png',
                                ),
                        ),

                        const SizedBox(height: 18),

                        // ── Rideability Warning (if not rideable) ─────────────
                        if (!s.isRideable) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF381515),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF8A2E2E),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded,
                                    color: Color(0xFFFF6B6B), size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    s.notRideableReason ??
                                        'السكوتر غير متاح للركوب حالياً.',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFFB3B3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // ── Scooter Code & Battery Row ───────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              s.code,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Battery pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(25),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.primary.withAlpha(120),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.battery_charging_full_rounded,
                                    color: AppColors.primary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${s.battery}%',
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // ── 3 Stat Cards in a Single Row ─────────────────────
                        Row(
                          children: [
                            // Card 1: متاح
                            Expanded(
                              child: _StatPillCard(
                                icon: s.isRideable
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                title: s.statusArabicText,
                                subtitle: 'الحالة',
                                iconColor: s.isRideable
                                    ? AppColors.primary
                                    : const Color(0xFFFF6B6B),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Card 2: سعر الرحلة
                            Expanded(
                              child: _StatPillCard(
                                icon: Icons.confirmation_number_rounded,
                                title:
                                    '${s.pricePerMinute.toStringAsFixed(1)} ج.م/د',
                                subtitle: 'سعر الرحلة',
                                iconColor: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Card 3: المسافة
                            Expanded(
                              child: _StatPillCard(
                                icon: Icons.near_me_rounded,
                                title: s.distanceLabel,
                                subtitle: 'المسافة',
                                iconColor: AppColors.primary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ── Compound & Specifications Card ───────────────────
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0C1B1F),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFF173038)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withAlpha(20),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color:
                                              AppColors.primary.withAlpha(60),
                                        ),
                                      ),
                                      child: Text(
                                        compoundName,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Flexible(
                                    child: Text(
                                      'المجمع ومواصفات السكوتر',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Row(
                                children: [
                                  Expanded(
                                    child: _SpecChip(
                                      icon: Icons.sports_motorsports_rounded,
                                      label: 'خوذة أمان مجانية',
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: _SpecChip(
                                      icon: Icons.lightbulb_rounded,
                                      label: 'إضاءة LED متطورة',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Row(
                                children: [
                                  Expanded(
                                    child: _SpecChip(
                                      icon: Icons.speed_rounded,
                                      label: 'السرعة: 25 كم/س',
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: _SpecChip(
                                      icon: Icons.gps_fixed_rounded,
                                      label: 'تتبع GPS ذكي',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),

                // ── Bottom Action Buttons ────────────────────────────────────
                Container(
                  padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + bottom),
                  decoration: const BoxDecoration(
                    color: Color(0xFF091417),
                    border: Border(top: BorderSide(color: Color(0xFF162D33))),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Button 1: Primary "حجز السكوتر"
                      _HeroActionButton(
                        isPrimary: true,
                        enabled: s.isRideable,
                        label: 'حجز السكوتر',
                        icon: Icons.calendar_today_rounded,
                        onTap: () {
                          context.push(AppRoutes.bookScooter, extra: s);
                        },
                      ),
                      const SizedBox(height: 10),
                      // Button 2: Secondary "بدء الرحلة مباشرة"
                      _HeroActionButton(
                        isPrimary: false,
                        enabled: s.isRideable,
                        label: 'بدء الرحلة مباشرة',
                        icon: Icons.qr_code_scanner_rounded,
                        onTap: () {
                          context.push(AppRoutes.qrScan, extra: s);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// STAT PILL CARD
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _StatPillCard extends StatelessWidget {
  const _StatPillCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0E2226),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1B3840)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              color: Color(0xFF4A7A84),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF12272D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                color: Color(0xFF9CB9B2),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Icon(icon, color: AppColors.primary, size: 16),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// HERO ACTION BUTTONS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
    required this.isPrimary,
    required this.label,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final bool isPrimary;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final opacity = enabled ? 1.0 : 0.45;

    return Opacity(
      opacity: opacity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              gradient: isPrimary
                  ? const LinearGradient(
                      colors: [Color(0xFF57F56D), Color(0xFF38D952)],
                    )
                  : null,
              color: isPrimary ? null : const Color(0xFF0F262B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isPrimary
                    ? const Color(0xFF57F56D)
                    : AppColors.primary.withAlpha(90),
                width: 1.5,
              ),
              boxShadow: isPrimary && enabled
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(75),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color:
                      isPrimary ? const Color(0xFF071214) : AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isPrimary ? const Color(0xFF071214) : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.color = Colors.white,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

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
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
