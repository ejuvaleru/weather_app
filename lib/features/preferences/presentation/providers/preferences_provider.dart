import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/shared/shared.dart';

final preferencesProvider =
    StateNotifierProvider<PreferencesNotifier, PreferencesState>((ref) {
  final sharedService = SharedServiceImpl();
  return PreferencesNotifier(sharedService: sharedService);
});

class PreferencesNotifier extends StateNotifier<PreferencesState> {
  final SharedService sharedService;

  PreferencesNotifier({required this.sharedService})
      : super(PreferencesState()) {
    _checkPreferencesStorage();
  }

  void _checkPreferencesStorage() async {
    state = state.copyWith(
      useCelcius: await sharedService.getValue<bool>('CELCIUS') ?? true,
      useKm: await sharedService.getValue<bool>('KM') ?? true,
      useDeviceLang: await sharedService.getValue<bool>('DEVICE_LANG') ?? false,
    );
  }

  void toggleCelcius() {
    state = state.copyWith(useCelcius: !state.useCelcius);
    sharedService.setKeyValue('CELCIUS', state.isUsingCelcius);
  }

  void toggleKm() {
    state = state.copyWith(useKm: !state.useKm);
    sharedService.setKeyValue('KM', state.isUsingKm);
  }

  void checkLocationPermissionStatus() async {
    LocationPermission permission = await Geolocator.checkPermission();
    state = state.copyWith(
      locationPermission: permission,
    );
  }

  void requestLocationPermission() async {
    if(state.isLocationPermissionGranted) {
      await Geolocator.openAppSettings();
      return;
    }
    LocationPermission permission = await Geolocator.requestPermission();
    state = state.copyWith(locationPermission: permission);
    _checkPermanentlyDenied(permission);
  }

  void toggleUseDeviceLang() {
    state = state.copyWith(useDeviceLang: !state.useDeviceLang);
    sharedService.setKeyValue('DEVICE_LANG', state.useDeviceLang);
  }

  _checkPermanentlyDenied(LocationPermission status) async {
    if (status == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    }
  }
}

class PreferencesState {
  final bool useCelcius;
  final bool useKm;
  final bool useDeviceLang;
  final LocationPermission locationPermission;

  PreferencesState({
    this.useCelcius = true,
    this.useKm = true,
    this.useDeviceLang = false,
    this.locationPermission = LocationPermission.denied,
  });

  PreferencesState copyWith({
    bool? useCelcius,
    bool? useKm,
    bool? useDeviceLang,
    LocationPermission? locationPermission,
  }) =>
      PreferencesState(
          useCelcius: useCelcius ?? this.useCelcius,
          useKm: useKm ?? this.useKm,
          useDeviceLang: useDeviceLang ?? this.useDeviceLang,
          locationPermission: locationPermission ?? this.locationPermission);

  bool get isUsingCelcius => useCelcius;
  bool get isUsingKm => useKm;
  bool get isLocationPermissionGranted =>
      locationPermission == LocationPermission.always ||
      locationPermission == LocationPermission.whileInUse;
  bool get isUsingDeviceLang => useDeviceLang;
}
