import 'package:go_router/go_router.dart';
import 'package:weather_app/features/features.dart';

class AppRouter {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const ForecastScreen()),
      GoRoute(path: '/preferences', builder: (context, state) => const PreferencesScreen()),
    ],
    initialLocation: '/',
  );
}
