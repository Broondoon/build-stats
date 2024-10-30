import 'dart:core';
import 'package:shared/entity.dart';

abstract class FileIOService<T extends Entity> {
  Future<List<T>?> readDataFile(String path);
  Future<T?> readDataFileByKey(String path, String key);
  Future<bool> saveDataFile(String path, List<T> data);
  Future<bool> deleteDataFile(String path);
  Future<bool> deleteFromDataFile(String path, List<String> key);
}
