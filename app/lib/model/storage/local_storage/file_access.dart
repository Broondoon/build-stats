import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:build_stats_flutter/model/Domain/Interface/cachable.dart';
import 'package:build_stats_flutter/model/Domain/Interface/file_IO_service.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';
import 'package:mutex/mutex.dart';

class JsonFileAccess<T extends Cacheable> implements FileIOService<T> {
  final CacheableFactory<T> _parser;
  JsonFileAccess(this._parser);

  final m = ReadWriteMutex();

  //Made this it's own file so that it can be easily modified app wide later on if neccessary.
  Future<File> _getDataFile(String path) async {
    final file = File(path);
    return file;
  }

  @override
  Future<List<T>?> readDataFile(String path) async {
    String jsonString = await m.protectRead(() async {
      final file = await _getDataFile(path);
      String jsonString = "";
      if (await file.exists()) {
        // Read the JSON file
        jsonString = await file.readAsString();
      }
      return jsonString;
    });
    return jsonString.isNotEmpty
        ? jsonDecode(jsonString).map((json) => _parser.fromJson(json)).toList()
        : null;
  }

  @override
  Future<bool> saveDataFile(String path, List<T> data) async {
    return await m.protectWrite(() async {
      try {
        List<T> entities = [];
        final file = await _getDataFile(path);
        if (!await file.exists()) {
          await file.create(recursive: true);
        } else {
          entities = await _parseExistingData(file);
        }
        //for each entity in data, either update the value in entites, or add to entites
        for (var element in data) {
          final index = entities.indexWhere((e) => e.id == element.id);
          if (index != -1) {
            entities[index] = element;
          } else {
            entities.add(element);
          }
        }
        await file.writeAsString(
            jsonEncode(entities.map((e) => e.toJson()).toList()));
        return true;
      } catch (e) {
        return false;
      }
    });
  }

  @override
  Future<bool> deleteDataFile(String path) async {
    return await m.protectWrite(() async {
      final file = await _getDataFile(path);
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    });
  }

  @override
  Future<bool> deleteFromDataFile(String path, List<String> keys) async {
    return await m.protectWrite(() async {
      try {
        List<T> entities = [];
        final file = await _getDataFile(path);
        if (!await file.exists()) {
          await file.create(recursive: true);
        } else {
          entities = await _parseExistingData(file);
        }
        //for each entity in data, either update the value in entites, or add to entites
        for (var key in keys) {
          final index = entities.indexWhere((e) => e.id == key);
          if (index != -1) {
            entities.removeAt(index);
          }
        }
        await file.writeAsString(
            jsonEncode(entities.map((e) => e.toJson()).toList()));
        return true;
      } catch (e) {
        return false;
      }
    });
  }

  Future<List<T>> _parseExistingData(File file) async {
    if (!(m.isReadLocked || m.isWriteLocked)) {
      throw Exception("Mutex is not locked for reading or writing");
    }
    // Parse the JSON file
    return jsonDecode(await file.readAsString())
        .map((json) => _parser.fromJson(json))
        .toList();
  }

  @override
  Future<T?> readDataFileByKey(String path, String key) async {
    return (await readDataFile(path))
        ?.firstWhere((element) => element.id == key);
  }
}
