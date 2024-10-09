
import 'dart:io';
import 'package:build_stats_flutter/resources/app_strings.dart';

class FileAccess {

  Future<File> getDataFile(String path) async {
    final directory = DataDirectoryPath;
    final file = File('${directory}/${path}');
    return file;
}
