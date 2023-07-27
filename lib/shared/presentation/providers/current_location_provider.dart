import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/config/config.dart';

final currentPositionProvider = StateNotifierProvider<CurrentPositionNotifier, String>((ref) {
  return CurrentPositionNotifier();
});

class CurrentPositionNotifier extends StateNotifier<String> {
  CurrentPositionNotifier() : super('') {
    getCurrentPosition();
  }

  Future<String> getCurrentPosition() async {
    final hasPermission = await _hasLocationPermission();
    if (!hasPermission) return '';

    final serviceEnabled = await _hasServiceEnabled();
    if (!serviceEnabled) return '';

    return await GeolocatorPlugin.getCurrentPosition();
  }

  Future<bool> _hasLocationPermission() async {
    return await GeolocatorPlugin.hasLocationPermission();
  }

  Future<bool> _hasServiceEnabled() async {
     return await GeolocatorPlugin.isLocationServiceEnabled();
  }
}
