import 'package:dio/dio.dart';
import 'package:weather_app/config/config.dart';
import 'package:weather_app/features/forecast/domain/domain.dart';
import 'package:weather_app/features/forecast/infrastructure/infrastructure.dart';

class WeatherApiDatasourceImpl implements WeatherDatasource {
  late final Dio _dio;

  WeatherApiDatasourceImpl() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.weatherapi.com/v1/',
        queryParameters: {
          'aqi': 'no',
          'key': EnvPlugin.get('WEATHER_API_KEY'),
          'days': '1',
          'alerts': 'no',
          'lang': 'en'
        },
      ),
    );
  }

  @override
  Future<CurrentWeather> getCurrentWeather({required String cityNameOrPosition}) async {
    try {
      print('-------------------- API CALLED $cityNameOrPosition');
      final resp = await _dio.get('forecast.json', queryParameters: {'q': cityNameOrPosition});
      final weatherApiResponse = WeatherApiResponse.fromJson(resp.data);

      return CurrentWeatherMapper.currentToEntity(weatherApiResponse);
    } catch (e) {
      throw Exception(e);
    }
  }
}
