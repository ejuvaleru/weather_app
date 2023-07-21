import 'package:weather_app/config/config.dart';

String getTodayDate() {
  final today = DateTime.now();
  return '${today.day}, ${getMonthName(today.month-1)} ${today.year}';
}