import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/shared/shared.dart';

final preferencesProvider = StateNotifierProvider<PreferencesNotifier, PreferencesState>((ref) {
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
      enableLocation: await sharedService.getValue<bool>('LOCATION') ?? false,
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

  void toggleLocationService() {
    state = state.copyWith(enableLocation: !state.enableLocation);
    sharedService.setKeyValue('LOCATION', state.enableLocation);
  }

  void toggleUseDeviceLang() {
    state = state.copyWith(useDeviceLang: !state.useDeviceLang);
    sharedService.setKeyValue('DEVICE_LANG', state.useDeviceLang);
  }
}

class PreferencesState {
  final bool useCelcius;
  final bool useKm;
  final bool enableLocation;
  final bool useDeviceLang;

  PreferencesState({
    this.useCelcius = true,
    this.useKm = true,
    this.enableLocation = false,
    this.useDeviceLang = false,
  });

  PreferencesState copyWith({
    bool? useCelcius,
    bool? useKm,
    bool? enableLocation,
    bool? useDeviceLang,
  }) =>
      PreferencesState(
        useCelcius: useCelcius ?? this.useCelcius,
        useKm: useKm ?? this.useKm,
        enableLocation: enableLocation ?? this.enableLocation,
        useDeviceLang: useDeviceLang ?? this.useDeviceLang,
      );

  bool get isUsingCelcius => useCelcius;
  bool get isUsingKm => useKm;
  bool get isLocationServiceGranted => enableLocation;
  bool get isUsingDeviceLang => useDeviceLang;
}
