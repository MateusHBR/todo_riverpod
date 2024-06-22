import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_riverpod/service/local_storage/local_storage.dart';

final class SharedPreferencesLocalStorage implements LocalStorage {
  @override
  Future<String?> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    return data;
  }

  @override
  Future<void> save({
    required String key,
    required String data,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
  }

  @override
  Future<void> delete(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
