import 'package:weather_app/features/forecast/domain/domain.dart';

abstract class WeatherRepository {
  Future<CurrentWeather> getCurrentWeather({required String cityNameOrPosition});
}
