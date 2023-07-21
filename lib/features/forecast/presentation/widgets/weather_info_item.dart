import 'package:flutter/material.dart';
import 'package:weather_app/config/config.dart';

class WeatherInfoItem extends StatelessWidget {
  final String info;
  final String label;
  final IconData icon;

  const WeatherInfoItem({
    super.key,
    required this.label,
    required this.info,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(color: Color(secondaryFontColor)),
          ),
          Text(info),
        ],
      ),
    );
  }
}
