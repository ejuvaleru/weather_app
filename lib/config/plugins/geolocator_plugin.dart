import 'package:geolocator/geolocator.dart';

class GeolocatorPlugin {
  static Future<String> getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    return '${position.latitude},${position.longitude}';
  }

  static Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) return false;
        
    return true;
  }

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  static Future<bool> requestPermission() async {
    await Geolocator.requestPermission();

    return hasLocationPermission();
  }

  static Future<bool> isPermanentlyDenied() async {
    final permission = await Geolocator.checkPermission();

    return permission == LocationPermission.deniedForever; 
  }
}
