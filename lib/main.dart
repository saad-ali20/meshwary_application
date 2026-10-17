import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register all dependencies before the app starts.
  await configureDependencies();

  runApp(const MeshwaryApp());
}
