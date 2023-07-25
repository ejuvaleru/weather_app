import 'package:flutter_riverpod/flutter_riverpod.dart';

final preferencesProvider = StateNotifierProvider<PreferencesNotifier, PreferencesState>((ref) {
  return PreferencesNotifier();
});

class PreferencesNotifier extends StateNotifier<PreferencesState> {
  PreferencesNotifier(): super(PreferencesState());
  
  void toggleCelcius() {
    state = state.copyWith(useCelcius: !state.useCelcius);
  }
  void toggleKm() {
    state = state.copyWith(useKm: !state.useKm);
  }
}

class PreferencesState {
  final bool useCelcius;
  final bool useKm;

  PreferencesState({this.useCelcius = true, this.useKm = true});

  PreferencesState copyWith ({
    bool? useCelcius,
    bool? useKm
  }) => PreferencesState(
    useCelcius: useCelcius ?? this.useCelcius,
    useKm: useKm ?? this.useKm,
  );
  
  bool get isUsingCelcius => useCelcius;
  bool get isUsingKm => useKm;
}