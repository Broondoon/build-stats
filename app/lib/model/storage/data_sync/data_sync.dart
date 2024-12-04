import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:build_stats_flutter/model/entity/user.dart';
import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
import 'package:build_stats_flutter/model/storage/item_cache.dart';
import 'package:build_stats_flutter/model/storage/unit_cache.dart';
import 'package:build_stats_flutter/model/storage/worksite_cache.dart';
import 'package:http/http.dart' as http;
import 'package:shared/app_strings.dart';
import 'package:build_stats_flutter/model/storage/data_sync/data_sync_timer.dart';
class DataSync {
  final WorksiteCache _worksiteCache;
  final ChecklistCache _checklistCache;
  final ChecklistDayCache _checklistDayCache;
  final ItemCache _itemCache;
  final UnitCache _unitCache;
  final http.Client client;

  DataSync(this._worksiteCache, this._checklistCache, this._checklistDayCache,
      this._itemCache, this._unitCache, http.Client? client)
      : client = client ?? http.Client();

  void startDataSyncTimer() async{
    DataSyncTimer().startDataSyncTimer();
  }
  
  //default expect that if we send an ID to the server, and the server doesnt have that ID in Cache, we're immediatly flagging that ID for refresh, as it implies that the server went down, and we need to ensure that the server cache is up to date.

  //on server side, we're pretty much just gonna have copies of our cache setups.
  //Data sync just checks the cache states of the server by their checksum, and if the server has a different state than the client, we're gonna send the client the updated data. We assume server has most up to date stuff right now.
  Future<void> checkCacheSync(User user) async {
    try {
      dynamic serverSendObject = {
        API_DataObject_UserId: user.id,
        API_DataObject_CompanyId: user.companyId,
        API_DataObject_ChecklistStateList:
            (await _checklistCache.getCacheCheckStates()).keys.toList(),
        API_DataObject_ChecklistDayStateList:
            (await _checklistDayCache.getCacheCheckStates()).keys.toList(),
        API_DataObject_ItemStateList:
            (await _itemCache.getCacheCheckStates()).keys.toList(),
       // API_DataObject_UnitStateList:
           // (await _unitCache.getCacheCheckStates()).keys.toList(),
      };

      //send our cache states to the server
      try {
        print("Data Sync: " + API_DataSyncPath);
        http.Response response = await client.post(Uri.parse(API_DataSyncPath),
            body: jsonEncode(serverSendObject),
            headers: {
              'content-type': 'application/json',
            });
        dynamic serverResponseJson = jsonDecode(response.body);
        if (response.statusCode == 200) {
          await _worksiteCache.setCacheSyncFlags(
            HashMap<String,String>.from(serverResponseJson[API_DataObject_WorksiteStateList]));
          await _checklistCache.setCacheSyncFlags( 
            HashMap<String,String>.from(serverResponseJson[API_DataObject_ChecklistStateList]));
          await _checklistDayCache.setCacheSyncFlags(
            HashMap<String,String>.from(serverResponseJson[API_DataObject_ChecklistDayStateList]));
          await _itemCache.setCacheSyncFlags(
            HashMap<String,String>.from(serverResponseJson[API_DataObject_ItemStateList]));
          //await _unitCache.setCacheSyncFlags(
          //  HashMap<String,String>.from(serverResponseJson[API_DataObject_UnitStateList]));
        } else {
          throw HttpException(response.statusCode, response.body);
        }
      } on HttpException {
        rethrow;
      } catch (e) {
        throw HttpException(503, "Service Unavailable");
      }

      //update our cache flags
    } catch (e) {
      rethrow;
    }
  }
}
