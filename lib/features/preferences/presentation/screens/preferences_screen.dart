import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/preferences/preferences.dart';

class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            title: const Text('Use Celcius'),
            subtitle: const Text('Set Celcius grades as default'),
            value: preferences.isUsingCelcius,
            onChanged: (value) => ref.read(preferencesProvider.notifier).toggleCelcius(),
          ),
          SwitchListTile.adaptive(
            title: const Text('Use KM'),
            subtitle: const Text('Set Kilometers as default'),
            value: preferences.isUsingKm,
            onChanged: (value) => ref.read(preferencesProvider.notifier).toggleKm(),
          ),
        ],
      ),
    );
  }
}
