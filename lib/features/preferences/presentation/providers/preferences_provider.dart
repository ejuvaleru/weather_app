import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/config/config.dart';
import 'package:weather_app/shared/shared.dart';

const useCelciusCode = 'CELSIUS';
const useKmCode = 'KM';
const useDeviceLang = 'DEVICE_LANG';
const hasLocationPermissionCode = 'LOCATION_PERMISSION';

final preferencesProvider = StateNotifierProvider<PreferencesNotifier, PreferencesState>((ref) {
  final sharedService = SharedServiceImpl();
  return PreferencesNotifier(sharedService: sharedService);
});

class PreferencesNotifier extends StateNotifier<PreferencesState> {
  final SharedService sharedService;

  PreferencesNotifier({required this.sharedService}): super(PreferencesState()) {
    _checkPreferencesStorage();
  }

  void _checkPreferencesStorage() async {
    state = state.copyWith(
      useCelcius: await sharedService.getValue<bool>(useCelciusCode) ?? true,
      useKm: await sharedService.getValue<bool>(useKmCode) ?? true,
      useDeviceLang: await sharedService.getValue<bool>(useDeviceLang) ?? false,
      hasLocationPermission: await sharedService.getValue<bool>(hasLocationPermissionCode) ?? false,
    );
  }

  void toggleCelcius() {
    state = state.copyWith(useCelcius: !state.useCelcius);
    sharedService.setKeyValue(useCelciusCode, state.isUsingCelcius);
  }

  void toggleKm() {
    state = state.copyWith(useKm: !state.useKm);
    sharedService.setKeyValue(useKmCode, state.isUsingKm);
  }

  void checkLocationPermissionStatus() async {
    final hasPermission = await GeolocatorPlugin.hasLocationPermission();
    state = state.copyWith(
      hasLocationPermission: hasPermission,
    );
    sharedService.setKeyValue(hasLocationPermissionCode, state.isUsingKm);
  }

  void requestLocationPermission() async {
    if(state.isLocationPermissionGranted) {
      return await GeolocatorPlugin.openAppSettings();
    }
    final hasLocationPermission = await GeolocatorPlugin.requestPermission();

    state = state.copyWith(hasLocationPermission: hasLocationPermission);
    sharedService.setKeyValue(hasLocationPermissionCode, state.isUsingKm);
  }

  void toggleUseDeviceLang() {
    state = state.copyWith(useDeviceLang: !state.useDeviceLang);
    sharedService.setKeyValue(useDeviceLang, state.useDeviceLang);
  }

  // _checkPermanentlyDenied() async {
  //   if(await GeolocatorPlugin.isPermanentlyDenied()) {
  //     return GeolocatorPlugin.openAppSettings();
  //   }
  // }
}

class PreferencesState {
  final bool useCelcius;
  final bool useKm;
  final bool useDeviceLang;
  final bool hasLocationPermission;

  PreferencesState({
    this.useCelcius = true,
    this.useKm = true,
    this.useDeviceLang = false,
    this.hasLocationPermission = false,
  });

  PreferencesState copyWith({
    bool? useCelcius,
    bool? useKm,
    bool? useDeviceLang,
    bool? hasLocationPermission,
  }) =>
      PreferencesState(
          useCelcius: useCelcius ?? this.useCelcius,
          useKm: useKm ?? this.useKm,
          useDeviceLang: useDeviceLang ?? this.useDeviceLang,
          hasLocationPermission: hasLocationPermission ?? this.hasLocationPermission);

  bool get isUsingCelcius => useCelcius;
  bool get isUsingKm => useKm;
  bool get isLocationPermissionGranted => hasLocationPermission;
  bool get isUsingDeviceLang => useDeviceLang;
}
