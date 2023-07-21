import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:weather_app/config/config.dart';
import 'package:weather_app/features/forecast/domain/domain.dart';
import 'package:weather_app/features/forecast/presentation/presentation.dart';

class ForecastScreen extends ConsumerStatefulWidget {
  const ForecastScreen({super.key});

  @override
  ForecastScreenState createState() => ForecastScreenState();
}

class ForecastScreenState extends ConsumerState<ForecastScreen> {
  @override
  Widget build(BuildContext context) {
    final currentWeather = ref.watch(currentWeatherProvider).weather;
    final isLoading = ref.watch(currentWeatherProvider).isLoading;

    return Scaffold(
        body: SafeArea(
      top: false,
      child: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : RefreshIndicator.adaptive(
              onRefresh: () async {
                Future.delayed(
                  const Duration(milliseconds: 100),
                  () {
                    ref.invalidate(currentWeatherProvider);
                  },
                );
              },
              child: CustomScrollView(
                slivers: [
                  _CustomSliverAppBar(currentWeather: currentWeather!),
                  _CustomSliverView(currentWeather: currentWeather),
                ],
              ),
            ),
    ));
  }
}

class _CustomSliverView extends StatelessWidget {
  final CurrentWeather currentWeather;

  const _CustomSliverView({
    required this.currentWeather,
  });

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
                ),
                const SizedBox(height: 24),
                _WeatherDetailsSection(currentWeather: currentWeather),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(currentWeather.astro.sunrise),
                    const SizedBox(width: 24),
                    SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                        customColors: CustomSliderColors(
                          progressBarColors: [
                            // const Color.fromARGB(255, 23, 79, 139),
                            const Color(scaffoldBgColor),
                            const Color(iconsColor),
                          ],
                          trackColor: const Color(secondaryFontColor),
                          dotColor: Colors.transparent
                        ),
                      ),
                      min: 0,
                      max: 24,
                      initialValue: double.parse(currentWeather.lastUpdateHour.split(':').first),
                      onChange: null,
                      innerWidget: (hour) => Center(
                        child: Text(
                          hour.round().toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Text(currentWeather.astro.sunset),
                  ],
                )
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
  const _HourlyForecastList({
    required this.currentWeather,
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
        initialScrollOffset:
            getInitialOffsetHourlyList(widget.currentWeather.lastUpdateHour));
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
            temperature: weatherByHour.tempC,
          );
        },
      ),
    );
  }
}

class _WeatherDetailsSection extends StatelessWidget {
  final CurrentWeather currentWeather;

  const _WeatherDetailsSection({
    required this.currentWeather,
  });

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
              info: '${currentWeather.feelslikeC}°',
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
              info: '${currentWeather.windKph} km/h',
              icon: Icons.air_outlined,
            ),
            WeatherInfoItem(
              label: 'Wind Direction',
              info: currentWeather.windDirection,
              icon: Icons.my_location_outlined,
            ),
            WeatherInfoItem(
              label: 'Visibility',
              info: '${currentWeather.visibilityKm} km/h',
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
  const _CustomSliverAppBar({required this.currentWeather});

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
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.location_on_outlined),
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
            padding: const EdgeInsets.only(right: 24),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(Icons.window_rounded),
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
                  '${currentWeather.tempC}°',
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
