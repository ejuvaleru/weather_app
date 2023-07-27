import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/forecast/infrastructure/infrastructure.dart';

final weatherRepositoryProvider = Provider<WeatherApiRepositoryImpl>((ref) {
  return WeatherApiRepositoryImpl();
});