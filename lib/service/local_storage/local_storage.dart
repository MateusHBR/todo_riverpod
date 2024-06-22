import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_local_storage.dart';

final localStorageServiceProvider = Provider<LocalStorage>(
  (_) => SharedPreferencesLocalStorage(),
);

abstract interface class LocalStorage {
  Future<String?> get(
    String key,
  );

  Future<void> save({
    required String key,
    required String data,
  });

  Future<void> delete(String key);
}
