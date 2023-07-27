import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

import 'package:weather_app/config/config.dart';
import 'package:weather_app/features/forecast/domain/domain.dart';
import 'package:weather_app/features/forecast/presentation/presentation.dart';
import 'package:weather_app/features/preferences/preferences.dart';
import 'package:weather_app/shared/shared.dart';

class ForecastScreen extends ConsumerStatefulWidget {
  const ForecastScreen({super.key});

  @override
  ForecastScreenState createState() => ForecastScreenState();
}

class ForecastScreenState extends ConsumerState<ForecastScreen> {

  @override
  Widget build(BuildContext context) {
    final currentWeatherAsync = ref.watch(currentWeatherProvider);
    final preferences = ref.watch(preferencesProvider);

    return currentWeatherAsync.when(
      data: (currentWeather) => Scaffold(
        body: SafeArea(
          top: false,
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              ref.invalidate(currentWeatherProvider);
              Future.delayed(const Duration(milliseconds: 500));
              ref.read(currentWeatherProvider);
            },
            child: CustomScrollView(
              slivers: [
                _CustomSliverAppBar(
                  currentWeather: currentWeather,
                  preferences: preferences,
                ),
                _CustomSliverView(
                  currentWeather: currentWeather,
                  preferences: preferences,
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () => const LoadingScreen(),
      error: (error, stackTrace) => Center(child: Text('ERROR $error')),
    );
  }
}

class _CustomSliverView extends StatelessWidget {
  final CurrentWeather currentWeather;
  final PreferencesState preferences;

  const _CustomSliverView(
      {required this.currentWeather, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _HourlyForecastList(
                  currentWeather: currentWeather,
                  preferences: preferences,
                ),
                const SizedBox(height: 24),
                _WeatherDetailsSection(
                  currentWeather: currentWeather,
                  preferences: preferences,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('☀️ ${currentWeather.astro.sunrise}'),
                    const SizedBox(width: 48),
                    Text('${currentWeather.astro.sunset} 🌕'),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HourlyForecastList extends StatefulWidget {
  final CurrentWeather currentWeather;
  final PreferencesState preferences;

  const _HourlyForecastList({
    required this.currentWeather,
    required this.preferences,
  });

  @override
  State<_HourlyForecastList> createState() => _HourlyForecastListState();
}

class _HourlyForecastListState extends State<_HourlyForecastList> {
  late ScrollController _hourlyForecastScrollController;

  @override
  void initState() {
    super.initState();
    _hourlyForecastScrollController = ScrollController(
      initialScrollOffset: getInitialOffsetHourlyList(widget.currentWeather.lastUpdateHour),
    );
  }

  @override
  void dispose() {
    _hourlyForecastScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        controller: _hourlyForecastScrollController,
        itemExtent: 80,
        scrollDirection: Axis.horizontal,
        itemCount: widget.currentWeather.weatherByHour.length,
        itemBuilder: (context, index) {
          final weatherByHour = widget.currentWeather.weatherByHour[index];

          return HourlyForecastItem(
            hour: weatherByHour.hour,
            imageUrl: weatherByHour.imageCode,
            temperature: widget.preferences.isUsingCelcius
                ? weatherByHour.tempC
                : weatherByHour.tempF,
          );
        },
      ),
    );
  }
}

class _WeatherDetailsSection extends StatelessWidget {
  final CurrentWeather currentWeather;
  final PreferencesState preferences;

  const _WeatherDetailsSection(
      {required this.currentWeather, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // WeatherInfoItem
            WeatherInfoItem(
              label: 'Feel like',
              info:
                  '${preferences.isUsingCelcius ? currentWeather.feelslikeC : currentWeather.feelslikeF}°',
              icon: Icons.thermostat_outlined,
            ),
            WeatherInfoItem(
              info: '${currentWeather.uv}',
              label: 'UV Index',
              icon: Icons.wb_sunny_outlined,
            ),
            WeatherInfoItem(
              label: 'Humidity',
              info: '${currentWeather.humidity}%',
              icon: Icons.water_drop_outlined,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WeatherInfoItem(
              label: 'Wind',
              info: preferences.isUsingKm
                  ? '${currentWeather.windKph} km/h'
                  : '${currentWeather.windMph} mi/h',
              icon: Icons.air_outlined,
            ),
            WeatherInfoItem(
              label: 'Wind Direction',
              info: currentWeather.windDirection,
              icon: Icons.my_location_outlined,
            ),
            WeatherInfoItem(
              label: 'Visibility',
              info: preferences.isUsingKm
                  ? '${currentWeather.visibilityKm} km'
                  : '${currentWeather.visibilityMiles} mi',
              icon: Icons.air_outlined,
            ),
          ],
        )
      ],
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final CurrentWeather currentWeather;
  final PreferencesState preferences;

  const _CustomSliverAppBar({
    required this.currentWeather,
    required this.preferences,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 12),
      sliver: SliverAppBar(
        pinned: true,
        elevation: 0,
        leadingWidth: double.maxFinite,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today ${getTodayDate()}',
                style: const TextStyle(fontSize: 16),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      child: const Icon(Icons.location_on_outlined),
                    ),
                  ),
                  Text(
                    '${currentWeather.locationName.toUpperCase()}, ${currentWeather.locationCountry}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => context.push('/preferences'),
              icon: const Icon(Icons.window_rounded),
            ),
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: FadeIn(
            duration: const Duration(milliseconds: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Current Temp
                const SizedBox(height: 80),
                Image.asset(
                  'assets/images/weather/${currentWeather.conditionIconCode}',
                  width: 250,
                ),
                Text(
                  currentWeather.conditionText,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Text(
                  '${preferences.isUsingCelcius ? currentWeather.tempC : currentWeather.tempF}°',
                  style: const TextStyle(
                    fontSize: 110,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Last Update ${currentWeather.lastUpdateHour}')
              ],
            ),
          ),
        ),
        expandedHeight: 550,
      ),
    );
  }
}
