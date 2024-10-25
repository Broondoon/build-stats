import 'dart:core';

abstract class FileIOService {
  Future<String> ReadJsonDataFile(String path);
  Future<bool> SaveDataFile(String path, String data);
  Future<bool> DeleteDataFile(String path);
}
