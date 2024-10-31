import 'dart:collection';

import 'package:shared/src/base_entities/entity/entity.dart';

abstract class CacheInterface<T extends Entity> {
  Future<List<T>?> get(List<String> key, Function(List<String>?) onCacheMiss);
  Future<List<T>?> getAll(Function(List<String>?) onCacheMiss);
  Future<List<T>> storeBulk(List<T> entities);
  Future<T> store(String key, T value);
  Future<void> delete(String key);
  Future<HashMap<String, String>> getCacheCheckStates();
  Future<void> setCacheSyncFlags(HashMap<String, String> serverCheckSums);
}
