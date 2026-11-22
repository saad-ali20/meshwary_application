import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di/injection.dart';

void main() {
  // 1. Ensure Flutter engine bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Launch dependencies initialization in background
  ensureDependenciesInitialized();

  // 3. Launch Flutter app immediately so frame 1 renders right away.
  // This removes the Android native launch screen without any delay.
  runApp(const MeshwaryApp());
}
