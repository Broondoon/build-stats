import 'dart:core';

import 'package:build_stats_flutter/model/Domain/Interface/cachable.dart';

abstract class FileIOService<T extends Cacheable> {
  Future<List<T>?> readDataFile(String path);
  Future<T?> readDataFileByKey(String path, String key);
  Future<bool> saveDataFile(String path, List<T> data);
  Future<bool> deleteDataFile(String path);
  Future<bool> deleteFromDataFile(String path, List<String> key);
}
