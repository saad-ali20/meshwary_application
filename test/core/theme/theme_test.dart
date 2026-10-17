import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwary_app/core/theme/app_colors.dart';
import 'package:meshwary_app/core/theme/app_radius.dart';
import 'package:meshwary_app/core/theme/app_spacing.dart';
import 'package:meshwary_app/core/theme/app_theme.dart';

void main() {
  group('AppColors', () {
    test('primary is the correct neon-green hex', () {
      expect(
        AppColors.primary.toARGB32(),
        equals(const Color(0xFF57F56D).toARGB32()),
      );
    });

    test('background is near-black', () {
      expect(
        AppColors.background.toARGB32(),
        equals(const Color(0xFF091112).toARGB32()),
      );
    });

    test('textOnPrimary contrasts with primary', () {
      // textOnPrimary should be dark to be legible on the neon-green primary.
      final luminance = AppColors.textOnPrimary.computeLuminance();
      expect(luminance, lessThan(0.2));
    });

    test('error color is defined', () {
      expect(AppColors.error, isNotNull);
    });
  });

  group('AppSpacing', () {
    test('all values are multiples of 4', () {
      final values = [
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xxxl,
      ];
      for (final v in values) {
        expect(v % 4, equals(0.0), reason: '$v is not a multiple of 4');
      }
    });

    test('buttonHeight meets minimum touch target', () {
      expect(AppSpacing.buttonHeight, greaterThanOrEqualTo(44.0));
    });
  });

  group('AppRadius', () {
    test('pill radius is large enough to be fully rounded', () {
      expect(AppRadius.pill, greaterThanOrEqualTo(50.0));
    });
  });

  group('AppTheme', () {
    test('dark theme uses Material 3', () {
      expect(AppTheme.dark.useMaterial3, isTrue);
    });

    test('dark theme brightness is dark', () {
      expect(AppTheme.dark.brightness, equals(Brightness.dark));
    });

    test('primary color matches AppColors.primary', () {
      expect(
        AppTheme.dark.colorScheme.primary.toARGB32(),
        equals(AppColors.primary.toARGB32()),
      );
    });

    test('scaffold background matches AppColors.background', () {
      expect(
        AppTheme.dark.scaffoldBackgroundColor.toARGB32(),
        equals(AppColors.background.toARGB32()),
      );
    });
  });
}
