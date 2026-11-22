import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum ScooterHeroAngle { frontThreeQuarter, side, back }

/// Displays the illuminated scooter hero image with neon green glows and ground platform.
class ScooterHeroView extends StatelessWidget {
  const ScooterHeroView({
    super.key,
    this.height = 240,
    this.angle = ScooterHeroAngle.frontThreeQuarter,
    this.showGroundRings = true,
    this.imagePath,
  });

  final double height;
  final ScooterHeroAngle angle;
  final bool showGroundRings;
  final String? imagePath;

  String get _assetPath {
    if (imagePath != null) return imagePath!;
    // All angles now use the new neon scooter icon
    return 'assets/images/Neon Green Electric Scooter Icon-3.png';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        children: [
          // ── Radial background glow ──────────────────────────────────────────
          Container(
            width: height * 0.95,
            height: height * 0.95,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withAlpha(55),
                  AppColors.primary.withAlpha(15),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),

          // ── Ground platform rings ───────────────────────────────────────────
          if (showGroundRings)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: height * 1.05,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.elliptical(height * 0.52, 19),
                    ),
                    border: Border.all(
                      color: AppColors.primary.withAlpha(120),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(140),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Real Scooter Image ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Image.asset(
              _assetPath,
              height: height * 0.90,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                Icons.electric_scooter_rounded,
                size: height * 0.5,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
