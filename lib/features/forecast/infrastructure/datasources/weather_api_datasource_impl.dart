import 'package:dio/dio.dart';
import 'package:weather_app/features/forecast/domain/domain.dart';
import 'package:weather_app/features/forecast/infrastructure/infrastructure.dart';

class WeatherApiDatasourceImpl implements WeatherDatasource {
  late final Dio _dio;

  WeatherApiDatasourceImpl() {
    _dio = Dio(BaseOptions(
        baseUrl: 'https://api.weatherapi.com/v1/',
        queryParameters: {
          'aqi': 'no',
          'key': 'API_KEY',
          'days': '1',
          'alerts': 'no',
          'lang': 'no'
        }));
  }

  @override
  Future<CurrentWeather> getCurrentWeather({String cityName = 'Cancun'}) async {
    try {
      final resp = await _dio.get('forecast.json', queryParameters: {'q': cityName});
      final weatherApiResponse = WeatherApiResponse.fromJson(resp.data);

      return CurrentWeatherMapper.currentToEntity(weatherApiResponse);
    } catch (e) {
      throw Exception(e);
    }
  }
}
