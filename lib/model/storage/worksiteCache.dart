import 'dart:convert';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/storage/FileAccess.dart';
import 'package:build_stats_flutter/model/storage/checklistCache.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';
import 'package:localstorage/localstorage.dart';

class WorksiteCache {
  //final Map<int, Item?> _itemCache = {};
  static Future<Worksite?> GetWorksiteById(String id) async {
    Worksite? worksite;
    String? worksiteJson = localStorage.getItem(id);
    if (worksiteJson != null) {
      worksite = Worksite.fromJson(jsonDecode(worksiteJson));
    } else {
      worksite = await LoadWorksiteById(id);
    }
    if (worksite != null) {
      worksite.checklists = [];
      worksite.checklistIds.forEach((x) => Checklistcache.LoadChecklistById(x)
          .then((checklist) => {worksite?.checklists.add(checklist!)}));
    }
    return worksite;
  }

  //Initially Generated by CHATGPT
  static Future<Worksite?> LoadWorksiteById(String id) async {
    // Get the directory of the application documents
    final file = await FileAccess.getDataFile(
        WorksiteFileString); //TODO: need to change to dependency injection when I know how.

    // Check if the file exists
    if (await file.exists()) {
      // Read the JSON file
      String jsonString = await file.readAsString();

      // Decode the JSON string into a List of dynamic objects
      List<dynamic> jsonData = jsonDecode(jsonString);

      // Convert the dynamic objects into a List of Worksite objects
      List<Worksite> worksites =
          jsonData.map((json) => Worksite.fromJson(json)).toList();

      // Traverse the hierarchy to find the Worksite with the given ID
      for (Worksite worksite in worksites) {
        if (localStorage.getItem(worksite.id) == null) {
          localStorage.setItem(worksite.id, jsonEncode(worksite.toJson()));
        }
        if (worksite.id == id) {
          return worksite;
        }
      }
    }
    // If the item is not found, return null
    return null;
  }

  static Future<Null> StoreWorksite(Worksite worksite) async {
    localStorage.setItem(worksite.id, jsonEncode(worksite.toJson()));
    await SaveWorksite(worksite);
  }

  //Initially Generated by CHATGPT
  static Future<Null> SaveWorksite(Worksite worksite) async {
    // Get the directory of the application documents
    final file = await FileAccess.getDataFile(
        WorksiteFileString); //TODO: need to change to dependency injection when I know how.

    List<Worksite> worksites = [];

    // Check if the file exists
    if (await file.exists()) {
      // Read the JSON file
      String jsonString = await file.readAsString();

      // Decode the JSON string into a List of dynamic objects
      List<dynamic> jsonData = jsonDecode(jsonString);

      // Convert the dynamic objects into a List of Worksite objects
      worksites = jsonData.map((json) => Worksite.fromJson(json)).toList();
    }

    // Flag to check if the worksite was saved
    // Traverse the hierarchy to find where to save the worksite
    int worksiteIndex = worksites.indexWhere((i) => i.id == worksite.id);
    if (worksiteIndex != -1) {
      worksites[worksiteIndex] = worksite;
    } else {
      worksites.add(worksite);
    }
    // Encode the worksites back to JSON and save to the file
    String updatedJson =
        jsonEncode(worksites.map((worksite) => worksite.toJson()).toList());
    await FileAccess.SaveDataFile(WorksiteFileString, updatedJson);
  }
}
