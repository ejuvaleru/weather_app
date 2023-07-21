import 'package:weather_app/features/forecast/domain/domain.dart';

class CurrentWeather {
  final int tempC;
  final int tempF;
  final double windMph;
  final double windKph;
  final String windDirection;
  final String visibilityKm;
  final String visibilityMiles;
  final int humidity;
  final int feelslikeC;
  final int feelslikeF;
  final double uv;
  final String conditionText;
  final String conditionIconCode;
  final String locationName;
  final String locationCountry;
  final String lastUpdateHour;
  final AstroWeather astro;
  final List<WeatherByHour> weatherByHour;

  CurrentWeather({
    required this.tempC,
    required this.tempF,
    required this.windMph,
    required this.windKph,
    required this.windDirection,
    required this.visibilityKm,
    required this.visibilityMiles,
    required this.humidity,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.uv,
    required this.conditionText,
    required this.conditionIconCode,
    required this.locationName,
    required this.locationCountry,
    required this.lastUpdateHour,
    required this.astro,
    required this.weatherByHour,
  });
}
