import 'dart:io';
import 'package:build_stats_flutter/model/Domain/Interface/cachable.dart';
import 'package:build_stats_flutter/model/Domain/Interface/file_IO_service.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';
import 'package:mutex/mutex.dart';

class JsonFileAccess<T extends CacheableInterface> implements FileIOService {
  final m = ReadWriteMutex();

  //Made this it's own file so that it can be easily modified app wide later on if neccessary.
  Future<File> _getDataFile(String path) async {
    final file = File(path);
    return file;
  }

  @override
  Future<String> readDataFile(String path) async {
    final file = await _getDataFile(path);
    String jsonString = "";
    if (await file.exists()) {
      // Read the JSON file
      jsonString = await file.readAsString();
    }
    return jsonString;
  }

  @override
  Future<bool> saveDataFile(String path, String data) async {
    final file = await _getDataFile(path);
    if (await file.exists()) {
      await file.writeAsString(data);
    } else {
      await file.create();
      await file.writeAsString(data);
    }
    return true;
  }

  @override
  Future<bool> deleteDataFile(String path) async {
    final file = await _getDataFile(path);
    if (await file.exists()) {
      await file.delete();
    }
    return true;
  }

  @override
  Future<bool> deleteFromDataFile(String path, List<String> keys) {
    // TODO: implement deleteFromDataFile
    throw UnimplementedError();
  }
}
