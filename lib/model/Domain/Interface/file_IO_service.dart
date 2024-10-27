import 'dart:core';

abstract class FileIOService {
  Future<String> readDataFile(String path);
  Future<bool> saveDataFile(String path, String data);
  Future<bool> deleteDataFile(String path);
  Future<bool> deleteFromDataFile(String path, List<String> key);
}
