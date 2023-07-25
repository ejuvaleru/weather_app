import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/shared/infrastructure/services/services.dart';

class SharedServiceImpl implements SharedService {
  Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPreferences();
    switch(T) {
      case bool:
        return prefs.getBool(key) as T?;
      case String:
        return prefs.getString(key) as T?;
      default:
        throw UnimplementedError('Get not implemented yet for type ${T.runtimeType}');

    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPreferences();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPreferences();
    switch(T) {
      case bool:
        prefs.setBool(key, value as bool);
        break;
      case String:
        prefs.setString(key, value as String);
        break;
      default:
        throw UnimplementedError('Set not implemented for type ${T.runtimeType}');
    }
  }
}