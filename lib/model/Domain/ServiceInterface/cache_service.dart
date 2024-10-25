import 'dart:collection';
import 'dart:core';

abstract class CacheService<T> {
  Future<T?> getById(String key);
  Future<void> store(String key, T value);
  Future<void> delete(String key);
  Future<T?> load(String key);
  Future<void> save(String key, T value);
  Future<HashMap<String, String>> getCacheCheckSums();
}
