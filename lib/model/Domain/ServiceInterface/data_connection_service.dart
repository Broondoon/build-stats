import 'dart:core';

abstract class DataConnectionService<T> {
  Future<Iterable<T>> get(List<String> keys);
  Future<T> post(T value);
  Future<T> put(T value);
  Future<bool> delete(String key);
}
