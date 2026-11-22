import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract final class MarkerIconGenerator {
  static BitmapDescriptor? _cachedAvailableMarker;
  static BitmapDescriptor? _cachedSelectedMarker;

  /// Returns custom neon-green scooter location pin for Google Maps from assets.
  /// Falls back to [BitmapDescriptor.defaultMarkerWithHue] if loading fails.
  static Future<BitmapDescriptor> getAvailableMarkerIcon({
    bool isSelected = false,
  }) async {
    if (isSelected && _cachedSelectedMarker != null) {
      return _cachedSelectedMarker!;
    }
    if (!isSelected && _cachedAvailableMarker != null) {
      return _cachedAvailableMarker!;
    }

    try {
      final icon = await _loadPinAssetMarker(isSelected: isSelected);
      if (isSelected) {
        _cachedSelectedMarker = icon;
      } else {
        _cachedAvailableMarker = icon;
      }
      return icon;
    } catch (_) {
      // Graceful fallback to default green marker
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
  }

  static Future<BitmapDescriptor> _loadPinAssetMarker({
    required bool isSelected,
  }) async {
    // Compact, sleek pin dimensions for Google Maps (~38px normal, ~50px selected)
    final targetWidth = isSelected ? 50 : 38;
    final ByteData byteData = await rootBundle.load(
      'assets/images/Green Electric Scooter Location Pin-1.png',
    );
    final ui.Codec codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: targetWidth,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? pngBytes = await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (pngBytes == null) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }

    return BitmapDescriptor.bytes(pngBytes.buffer.asUint8List());
  }
}
