import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:weather_app/features/forecast/domain/domain.dart';
import 'package:weather_app/features/forecast/presentation/presentation.dart';

final currentWeatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  final getCurrentWeather = ref.watch(weatherRepositoryProvider).getCurrentWeather;
  return WeatherNotifier(callback: getCurrentWeather);
});

typedef WeatherCallback = Future<CurrentWeather> Function({String cityName});

class WeatherNotifier extends StateNotifier<WeatherState> {
  WeatherCallback callback;

  WeatherNotifier({required this.callback}) : super(WeatherState()) {
    loadWeather();
  }

  Future<void> loadWeather() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true
    );
    final weather = await callback(cityName: 'Cancun');
    state = state.copyWith(
      weather: weather,
    );

    await Future.delayed(const Duration(milliseconds: 400));
    state = state.copyWith(isLoading: false);
  }
}

class WeatherState {
  final CurrentWeather? weather;
  final bool isLoading;

  WeatherState({this.weather, this.isLoading = false});

  WeatherState copyWith({
    CurrentWeather? weather,
    bool? isLoading,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
