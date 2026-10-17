import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

/// Root application widget.
/// Configures theme, localization (RTL Arabic-first) and navigation.
class MeshwaryApp extends StatelessWidget {
  const MeshwaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // ── Identity ────────────────────────────────────────────────────────────
      title: 'مشواري',
      debugShowCheckedModeBanner: false,

      // ── Theme ───────────────────────────────────────────────────────────────
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,

      // ── Routing ─────────────────────────────────────────────────────────────
      routerConfig: appRouter,

      // ── Localization ─────────────────────────────────────────────────────────
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ── Directionality ───────────────────────────────────────────────────────
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );
  }
}
