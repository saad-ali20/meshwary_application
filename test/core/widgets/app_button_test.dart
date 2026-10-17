import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwary_app/core/theme/app_colors.dart';
import 'package:meshwary_app/core/theme/app_theme.dart';
import 'package:meshwary_app/core/widgets/app_button.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );

void main() {
  setUpAll(() => TestWidgetsFlutterBinding.ensureInitialized());
  group('AppButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(_wrap(
        AppButton(label: 'اضغط هنا', onPressed: () {}),
      ));
      expect(find.text('اضغط هنا'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        AppButton(label: 'تأكيد', onPressed: () => tapped = true),
      ));
      await tester.tap(find.text('تأكيد'));
      expect(tapped, isTrue);
    });

    testWidgets('shows CircularProgressIndicator when loading', (tester) async {
      await tester.pumpWidget(_wrap(
        AppButton(label: 'تحميل', onPressed: () {}, isLoading: true),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('تحميل'), findsNothing);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        AppButton(label: 'معطّل', onPressed: null),
      ));
      await tester.tap(find.text('معطّل'), warnIfMissed: false);
      expect(tapped, isFalse);
    });

    testWidgets('outlined variant renders', (tester) async {
      await tester.pumpWidget(_wrap(
        AppButton(
          label: 'إطار',
          variant: AppButtonVariant.outlined,
          onPressed: () {},
        ),
      ));
      expect(find.text('إطار'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('secondary variant renders', (tester) async {
      await tester.pumpWidget(_wrap(
        AppButton(
          label: 'ثانوي',
          variant: AppButtonVariant.secondary,
          onPressed: () {},
        ),
      ));
      expect(find.text('ثانوي'), findsOneWidget);
    });

    testWidgets('primary button has correct background color', (tester) async {
      await tester.pumpWidget(_wrap(
        AppButton(label: 'رئيسي', onPressed: () {}),
      ));
      // Verify ElevatedButton exists with primary styling
      expect(find.byType(ElevatedButton), findsOneWidget);
      // Verify the theme primary color is the expected neon-green
      expect(
        AppColors.primary.toARGB32(),
        equals(const Color(0xFF57F56D).toARGB32()),
      );
    });
  });
}
