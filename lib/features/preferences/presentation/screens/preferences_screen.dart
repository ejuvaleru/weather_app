import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/preferences/preferences.dart';

class PreferencesScreen extends ConsumerStatefulWidget {
  const PreferencesScreen({super.key});

  @override
  PreferencesScreenState createState() => PreferencesScreenState();
}

class PreferencesScreenState extends ConsumerState<PreferencesScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
   if(state == AppLifecycleState.resumed) {
    ref.read(preferencesProvider.notifier).checkLocationPermissionStatus();
   }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(preferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Text(
              'UNITS OF MESURE',
              // style: TextStyle(fontSize: ),
            ),
          ),
          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  title: const Text('Use Celcius'),
                  subtitle: const Text('Set degree Celsius as default'),
                  value: preferences.isUsingCelcius,
                  onChanged: (value) =>
                      ref.read(preferencesProvider.notifier).toggleCelcius(),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(),
                ),
                SwitchListTile.adaptive(
                  title: const Text('Use KM'),
                  subtitle: const Text('Set Kilometers as default'),
                  value: preferences.isUsingKm,
                  onChanged: (value) =>
                      ref.read(preferencesProvider.notifier).toggleKm(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Text(
              'LOCATION SERVICE',
              // style: TextStyle(fontSize: ),
            ),
          ),
          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  title: const Text('Enable location'),
                  subtitle: const Text('Provide access to device Location'),
                  value: preferences.isLocationPermissionGranted,
                  onChanged: (value) => ref.read(preferencesProvider.notifier).requestLocationPermission(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Text(
              'LANGUAGE OPTIONS',
              // style: TextStyle(fontSize: ),
            ),
          ),
          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  title: const Text('Set device lang'),
                  subtitle: const Text('Use device language as default'),
                  value: preferences.isUsingDeviceLang,
                  onChanged: (value) => ref.read(preferencesProvider.notifier).toggleUseDeviceLang(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}