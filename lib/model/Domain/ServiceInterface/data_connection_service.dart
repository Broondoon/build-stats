import 'dart:core';

abstract class DataConnectionService<T> {
  Future<Iterable<T>> get(String path, List<String> keys);
  Future<T> post(String path, T value);
  Future<T> put(String path, T value);
  Future<bool> delete(String path, String key);
}
