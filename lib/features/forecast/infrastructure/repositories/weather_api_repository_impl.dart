import 'package:weather_app/features/forecast/domain/domain.dart';
import 'package:weather_app/features/forecast/infrastructure/infrastructure.dart';

class WeatherApiRepositoryImpl implements WeatherRepository {

  final WeatherDatasource _datasource;

  WeatherApiRepositoryImpl({WeatherDatasource? datasource}) : _datasource = datasource ?? WeatherApiDatasourceImpl();

  @override
  Future<CurrentWeather> getCurrentWeather({String cityNameOrPosition = ''}) async {
    return _datasource.getCurrentWeather(cityNameOrPosition: cityNameOrPosition);
  }
}