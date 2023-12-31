import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/config/config.dart';

void main() async {
  await EnvPlugin.load();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Weather',
      theme: AppTheme().getTheme(),
      routerConfig: AppRouter().router,
    );
  }
}
