import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:weather_app/features/forecast/domain/domain.dart';
import 'package:weather_app/features/forecast/presentation/presentation.dart';
import 'package:weather_app/shared/shared.dart';

final currentWeatherProvider = FutureProvider<CurrentWeather>((ref) async {
  
  final cityNameOrPosition = await ref.watch(currentPositionProvider.notifier).getCurrentPosition();
  final currentWeather = await ref.watch(weatherRepositoryProvider).getCurrentWeather(cityNameOrPosition: (cityNameOrPosition == '') ? 'Mexico City' : cityNameOrPosition);

  return currentWeather;
});