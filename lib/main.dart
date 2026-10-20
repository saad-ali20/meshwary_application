import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/app.dart';
import 'app/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent google_fonts from fetching fonts over the network.
  // Fonts must be bundled locally in assets/fonts/ or already cached.
  GoogleFonts.config.allowRuntimeFetching = false;

  // Register all dependencies before the app starts.
  await configureDependencies();

  runApp(const MeshwaryApp());
}
