import 'dart:collection';
import 'dart:convert';

import 'package:Server/storage/checklist_cache.dart';
import 'package:Server/storage/item_cache.dart';
import 'package:Server/storage/unit_cache.dart';
import 'package:Server/storage/worksite_cache.dart';
import 'package:shared/app_strings.dart';
import 'package:shelf/shelf.dart';

class DataSync {
  final WorksiteCache _worksiteCache;
  final ChecklistCache _checklistCache;
  final ChecklistDayCache _checklistDayCache;
  final ItemCache _itemCache;
  final UnitCache _unitCache;

  DataSync(this._worksiteCache, this._checklistCache, this._checklistDayCache,
      this._itemCache, this._unitCache);

  final jsonHeaders = {
    'content-type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type',
  };

  Future<Response> handleCheckCacheSync(Request request) async {
    try {
      dynamic json = jsonDecode(await request.readAsString());
      List<String> jsonWorksiteIds =
          json[API_DataObject_WorksiteStateList]?.cast<String>() ?? [];
      List<String> jsonChecklistIds =
          json[API_DataObject_ChecklistStateList]?.cast<String>() ?? [];
      List<String> jsonChecklistDayIds =
          json[API_DataObject_ChecklistDayStateList]?.cast<String>() ?? [];
      List<String> jsonItemIds =
          json[API_DataObject_ItemStateList]?.cast<String>() ?? [];
      List<String> jsonUnitIds =
          json[API_DataObject_UnitStateList]?.cast<String>() ?? [];
      String userId = json[API_DataObject_UserId];
      String companyId = json[API_DataObject_CompanyId];

      Map<String, String> worksiteCheckSums =
          await _worksiteCache.getCacheCheckStates();
      worksiteCheckSums
          .removeWhere((key, value) => !jsonWorksiteIds.contains(key));

      Map<String, String> checklistCheckSums =
          await _checklistCache.getCacheCheckStates();
      checklistCheckSums
          .removeWhere((key, value) => !jsonChecklistIds.contains(key));

      Map<String, String> checklistDayCheckSums =
          await _checklistDayCache.getCacheCheckStates();
      checklistDayCheckSums
          .removeWhere((key, value) => !jsonChecklistDayIds.contains(key));

      Map<String, String> itemCheckSums =
          await _itemCache.getCacheCheckStates();
      itemCheckSums.removeWhere((key, value) => !jsonItemIds.contains(key));

      Map<String, String> unitCheckSums =
          await _unitCache.getCacheCheckStates();
      unitCheckSums.removeWhere((key, value) => !jsonUnitIds.contains(key));

      dynamic returnData = {
        API_DataObject_WorksiteStateList: worksiteCheckSums,
        API_DataObject_ChecklistStateList: checklistCheckSums,
        API_DataObject_ChecklistDayStateList: checklistDayCheckSums,
        API_DataObject_ItemStateList: itemCheckSums,
        API_DataObject_UnitStateList: unitCheckSums,
      };

      return Response.ok(jsonEncode(returnData), headers: {...jsonHeaders});
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }
}
