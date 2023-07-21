import 'package:weather_app/features/forecast/domain/domain.dart';
import 'package:weather_app/features/forecast/infrastructure/infrastructure.dart';

class CurrentWeatherMapper {
  static CurrentWeather currentToEntity(WeatherApiResponse weatherApiResponse) {
    final current = weatherApiResponse.current;
    final location = weatherApiResponse.location;
    final condition = current.condition;
    final forecastDay = weatherApiResponse.forecast.forecastday[0];
    final byHour = forecastDay.hour
        .map((e) => WeatherByHour(
              imageCode: e.condition.icon.split('64x64/')[1].toString(),
              hour: e.time.split(' ').last,
              tempC: e.tempC.round().toString(),
              tempF: e.tempF.round().toString(),
            ))
        .toList();
    final astro = forecastDay.astro;
    final AstroWeather astroWeather = AstroWeather(
      sunrise: astro.sunrise,
      sunset: astro.sunset,
      moonPhase: astro.moonPhase,
    );

    return CurrentWeather(
      tempC: current.tempC.round(),
      tempF: current.tempF.round(),
      windMph: current.windMph,
      windKph: current.windKph,
      windDirection: current.windDir,
      visibilityKm: current.visKm.toString(),
      visibilityMiles: current.visMiles.toString(),
      humidity: current.humidity,
      feelslikeC: current.feelslikeC.round(),
      feelslikeF: current.feelslikeF.round(),
      uv: current.uv,
      conditionText: condition.text,
      conditionIconCode: condition.icon.split('64x64/').last,
      locationName: location.name,
      locationCountry: location.country,
      lastUpdateHour: current.lastUpdated.split(' ').last,
      astro: astroWeather,
      weatherByHour: byHour,
    );
  }
}
