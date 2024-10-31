import 'dart:collection';
import 'dart:convert';

import 'package:Server/storage/checklist_cache.dart';
import 'package:Server/storage/item_cache.dart';
import 'package:Server/storage/worksite_cache.dart';
import 'package:shared/app_strings.dart';
import 'package:shelf/shelf.dart';

class DataSync {
  final WorksiteCache _worksiteCache;
  final ChecklistCache _checklistCache;
  final ChecklistDayCache _checklistDayCache;
  final ItemCache _itemCache;

  DataSync(this._worksiteCache, this._checklistCache, this._checklistDayCache,
      this._itemCache);

  final jsonHeaders = {
    'content-type': 'application/json',
  };
  //default expect that if we send an ID to the server, and the server doesnt have that ID in Cache, we're immediatly flagging that ID for refresh, as it implies that the server went down, and we need to ensure that the server cache is up to date.

  //on server side, we're pretty much just gonna have copies of our cache setups.
  Future<Response> handleCheckCacheSync(Response response) async {
    try {
      dynamic json = jsonDecode(await response.readAsString());
      List<String> jsonChecklistIds = json[API_DataObject_ChecklistStateList];
      List<String> jsonChecklistDayIds =
          json[API_DataObject_ChecklistDayStateList];
      List<String> jsonItemIds = json[API_DataObject_ItemStateList];
      String userId = json[API_DataObject_UserId];
      String companyId = json[API_DataObject_CompanyId];

      HashMap<String, String> worksiteCheckSums =
          await _worksiteCache.getCacheCheckStates();
      worksiteCheckSums.removeWhere((key, value) => !jsonChecklistIds.contains(
          key)); //This doesnot filter for worksties the user SHOULDn't have.
      HashMap<String, String> checklistCheckSums =
          await _checklistCache.getCacheCheckStates();
      checklistCheckSums
          .removeWhere((key, value) => !jsonChecklistIds.contains(key));
      HashMap<String, String> checklistDayCheckSums =
          await _checklistDayCache.getCacheCheckStates();
      checklistDayCheckSums
          .removeWhere((key, value) => !jsonChecklistDayIds.contains(key));
      HashMap<String, String> itemCheckSums =
          await _itemCache.getCacheCheckStates();
      itemCheckSums.removeWhere((key, value) => !jsonItemIds.contains(key));

      dynamic returnData = {
        API_DataObject_WorksiteStateList: worksiteCheckSums,
        API_DataObject_ChecklistStateList: checklistCheckSums,
        API_DataObject_ChecklistDayStateList: checklistDayCheckSums,
        API_DataObject_ItemStateList: itemCheckSums
      };

      return Response.ok(jsonEncode(returnData), headers: {...jsonHeaders});
    } catch (e) {
      rethrow;
    }
  }
}
