import 'package:build_stats_flutter/model/Domain/Service/file_IO_service.dart';
import 'package:shared/entity.dart';

//For now, not implementing local file storage for web.
class JsonFileAccess<T extends Entity> implements FileIOService<T> {
  @override
  Future<bool> deleteDataFile(String path) async => true;

  @override
  Future<bool> deleteFromDataFile(String path, List<String> key) async => true;

  @override
  Future<List<T>?> readDataFile(String path) async => null;

  @override
  Future<T?> readDataFileByKey(String path, String key) async => null;

  @override
  Future<bool> saveDataFile(String path, List data) async => true;
}
