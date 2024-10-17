import 'dart:convert';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/storage/FileAccess.dart';
import 'package:build_stats_flutter/model/storage/checklistCache.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';
import 'package:localstorage/localstorage.dart';

class ItemCache {
  //final Map<int, Item?> _itemCache = {};
  static Future<Item?> GetItemById(String id) async {
    Item? item;
    String? itemJson = localStorage.getItem(id);
    if (itemJson != null) {
      item = Item.fromJson(jsonDecode(itemJson));
    } else {
      item = await LoadItemById(id);
    }
    return item;
  }

  //Initially Generated by CHATGPT
  static Future<Item?> LoadItemById(String id) async {
    // Get the directory of the application documents
    final file = await FileAccess.getDataFile(
        ItemFileString); //TODO: need to change to dependency injection when I know how.

    // Check if the file exists
    if (await file.exists()) {
      // Read the JSON file
      String jsonString = await file.readAsString();

      // Decode the JSON string into a List of dynamic objects
      List<dynamic> jsonData = jsonDecode(jsonString);

      // Convert the dynamic objects into a List of Item objects
      List<Item> items = jsonData.map((json) => Item.fromJson(json)).toList();

      // Traverse the hierarchy to find the Item with the given ID
      for (Item item in items) {
        if (localStorage.getItem(item.id) == null) {
          localStorage.setItem(item.id, jsonEncode(item.toJson()));
        }
        if (item.id == id) {
          return item;
        }
      }
    }
    // If the item is not found, return null
    return null;
  }

  static Future<Null> StoreItem(Item item) async {
    localStorage.setItem(item.id, jsonEncode(item.toJson()));
    await SaveItem(item);
  }

  //Initially Generated by CHATGPT
  static Future<Null> SaveItem(Item item) async {
    // Get the directory of the application documents
    final file = await FileAccess.getDataFile(
        ItemFileString); //TODO: need to change to dependency injection when I know how.

    List<Item> items = [];

    // Check if the file exists
    if (await file.exists()) {
      // Read the JSON file
      String jsonString = await file.readAsString();

      // Decode the JSON string into a List of dynamic objects
      List<dynamic> jsonData = jsonDecode(jsonString);

      // Convert the dynamic objects into a List of Item objects
      items = jsonData.map((json) => Item.fromJson(json)).toList();
    }

    // Flag to check if the item was saved
    // Traverse the hierarchy to find where to save the item
    int itemIndex = items.indexWhere((i) => i.id == item.id);
    if (itemIndex != -1) {
      items[itemIndex] = item;
    } else {
      items.add(item);
    }
    // Encode the items back to JSON and save to the file
    String updatedJson =
        jsonEncode(items.map((item) => item.toJson()).toList());
    await FileAccess.SaveDataFile(ItemFileString, updatedJson);
  }
}
