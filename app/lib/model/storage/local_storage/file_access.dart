import 'dart:convert';
import 'dart:io';
import 'package:build_stats_flutter/model/Domain/Service/file_IO_service.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/entity.dart';

class JsonFileAccess<T extends Entity> implements FileIOService<T> {
  final EntityFactory<T> _parser;
  JsonFileAccess(this._parser);

  final m = ReadWriteMutex();

  //Made this it's own file so that it can be easily modified app wide later on if neccessary.
  Future<File> _getDataFile(String path) async {
    final file = File(path);
    return file;
  }

  @override
  Future<List<T>?> readDataFile(String path) async {
    try {
      // Read the JSON string from the file
      String jsonString = await m.protectRead(() async {
        final file = await _getDataFile(path);
        if (await file.exists()) {
          return await file.readAsString();
        }
        return "";
      });

      // If the JSON string is empty, return null
      if (jsonString.isEmpty) {
        return null;
      }

      // Decode the JSON string into a dynamic list
      final List<dynamic> decodedJson = jsonDecode(jsonString);

      // Transform each JSON object into an instance of T using the parser
      final List<T> entities =
          decodedJson.map((json) => _parser.fromJson(json) as T).toList();

      return entities;
    } catch (e) {
      // Handle exceptions as needed (e.g., logging)
      // For now, return null to indicate failure
      return null;
    }
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
    String? jsonString;

    if (await file.exists()) {
      jsonString = await file.readAsString();
      if (jsonString.isNotEmpty) {
        final List<dynamic> decodedJson = jsonDecode(jsonString);
        final List<T> entities =
            decodedJson.map((json) => _parser.fromJson(json) as T).toList();
        return entities;
      }
    }
    return [];
  }

  @override
  Future<T?> readDataFileByKey(String path, String key) async {
    final entities = await readDataFile(path);
    if (entities == null || entities.isEmpty) {
      return null;
    }
    try {
      return entities.firstWhere((element) => element.id == key, orElse: () {
        throw Exception("Element not found");
      });
    } catch (e) {
      // If no element is found, return null
      return null;
    }
  }
}
