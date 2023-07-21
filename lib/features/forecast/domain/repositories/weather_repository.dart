import 'package:weather_app/features/forecast/domain/domain.dart';

abstract class WeatherRepository {
  Future<CurrentWeather> getCurrentWeather({String cityName = 'Cancun'});
}
