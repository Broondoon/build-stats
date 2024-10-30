import 'package:Server/storage/checklist_cache.dart';
import 'package:Server/storage/item_cache.dart';
import 'package:Server/storage/worksite_cache.dart';
import 'package:shared/app_strings.dart';

class DataSync {
  final WorksiteCache _worksiteCache;
  final ChecklistCache _checklistCache;
  final ChecklistDayCache _checklistDayCache;
  final ItemCache _itemCache;

  DataSync(this._worksiteCache, this._checklistCache, this._checklistDayCache,
      this._itemCache);

  //default expect that if we send an ID to the server, and the server doesnt have that ID in Cache, we're immediatly flagging that ID for refresh, as it implies that the server went down, and we need to ensure that the server cache is up to date.

  //on server side, we're pretty much just gonna have copies of our cache setups.
  Future<void> checkCacheSync() async {
    try {
      dynamic serverSendObject = {
        API_DataObject_ChecklistStateList:
            (await _checklistCache.getCacheCheckStates()).keys.toList(),
        API_DataObject_ChecklistDayStateList:
            (await _checklistDayCache.getCacheCheckStates()).keys.toList(),
        API_DataObject_ItemStateList:
            (await _itemCache.getCacheCheckStates()).keys.toList()
      };

      //get Server responses
      //Temp implementation until the proper Server is setup.
      dynamic serverResponseJson = {
        API_DataObject_WorksiteStateList:
            await _worksiteCache.getCacheCheckStates(),
        API_DataObject_ChecklistStateList:
            await _checklistCache.getCacheCheckStates(),
        API_DataObject_ChecklistDayStateList:
            await _checklistDayCache.getCacheCheckStates(),
        API_DataObject_ItemStateList: await _itemCache.getCacheCheckStates()
      };

      //update our cache flags
      await _worksiteCache.setCacheSyncFlags(
          serverResponseJson[API_DataObject_WorksiteStateList]);
      await _checklistCache.setCacheSyncFlags(
          serverResponseJson[API_DataObject_ChecklistStateList]);
      await _checklistDayCache.setCacheSyncFlags(
          serverResponseJson[API_DataObject_ChecklistDayStateList]);
      await _itemCache
          .setCacheSyncFlags(serverResponseJson[API_DataObject_ItemStateList]);
    } catch (e) {
      rethrow;
    }
  }
}
