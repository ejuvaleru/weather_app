import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/config/config.dart';

class AppTheme {

  final _fontFamilySmall = GoogleFonts.jost(color: const Color(primaryFontColor));
  final _fontFamilyMedium = GoogleFonts.jost(color: const Color(primaryFontColor));
  final _fontFamilyLarge = GoogleFonts.jost(color: const Color(primaryFontColor));

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(scaffoldBgColor),
    textTheme: const TextTheme().copyWith(
      bodySmall: _fontFamilySmall,
      bodyMedium: _fontFamilyMedium,
      bodyLarge: _fontFamilyLarge,
      titleSmall: _fontFamilySmall,
      titleMedium: _fontFamilyMedium,
      titleLarge: _fontFamilyLarge,
    ),
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: const Color(scaffoldBgColor),
    ),
  );
}