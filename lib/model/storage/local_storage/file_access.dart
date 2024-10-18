import 'dart:io';
import 'package:build_stats_flutter/resources/app_strings.dart';

class FileAccess {
  //Made this it's own file so that it can be easily modified app wide later on if neccessary.
  static Future<File> getDataFile(String path) async {
    final directory = DataDirectoryPath;
    final file = File('$directory/$path');
    return file;
  }

  static Future<Null> SaveDataFile(String path, String data) async {
    final file = await getDataFile(path);
    if (await file.exists()) {
      await file.writeAsString(data);
    } else {
      await file.create();
      await file.writeAsString(data);
    }
  }
}
