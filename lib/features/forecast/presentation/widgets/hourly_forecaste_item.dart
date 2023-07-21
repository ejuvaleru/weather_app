import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:weather_app/config/config.dart';

class HourlyForecastItem extends StatelessWidget {
  final String hour;
  final String temperature;
  final String imageUrl;

  const HourlyForecastItem({
    super.key,
    required this.hour,
    required this.temperature,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
                borderRadius: BorderRadius.circular(200),
              ),
              child: Image.asset(
                alignment: Alignment.center,
                'assets/images/weather/$imageUrl',
                width: 64,
                cacheWidth: 64,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              hour,
              style: const TextStyle(color: Color(secondaryFontColor)),
            ),
            const SizedBox(height: 12),
            Text(
              '$temperature°',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
