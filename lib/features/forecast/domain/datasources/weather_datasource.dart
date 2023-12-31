import 'package:weather_app/features/forecast/domain/domain.dart';

abstract class WeatherDatasource {
  Future<CurrentWeather> getCurrentWeather({required String cityNameOrPosition});
}