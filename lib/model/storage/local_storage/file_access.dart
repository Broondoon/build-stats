import 'dart:io';
import 'package:build_stats_flutter/model/Domain/ServiceInterface/file_IO_service.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';

class FileAccess implements FileIOService {
  //Made this it's own file so that it can be easily modified app wide later on if neccessary.
  Future<File> _getDataFile(String path) async {
    final directory = DataDirectoryPath;
    final file = File('$directory\\$path');
    return file;
  }

  Future<String> ReadJsonDataFile(String path) async {
    final file = await _getDataFile(path);
    String jsonString = "";
    if (await file.exists()) {
      // Read the JSON file
      jsonString = await file.readAsString();
    }
    return jsonString;
  }

  Future<bool> SaveDataFile(String path, String data) async {
    final file = await _getDataFile(path);
    if (await file.exists()) {
      await file.writeAsString(data);
    } else {
      await file.create();
      await file.writeAsString(data);
    }
    return true;
  }

  Future<bool> DeleteDataFile(String path) async {
    final file = await _getDataFile(path);
    if (await file.exists()) {
      await file.delete();
    }
    return true;
  }
}
