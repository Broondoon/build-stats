import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/Domain/Service/cache_service.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:mutex/mutex.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared/app_strings.dart';

class ItemCache extends CacheService<Item> {
  ItemCache(DataConnectionService<Item> dataConnectionService,
      JsonFileAccess<Item> fileIOService)
      : super(dataConnectionService, fileIOService, ItemFactory(), API_ItemPath,
            Dir_ItemFileString, localStorage, ReadWriteMutex());

  Future<List<Item>?> EnsureChecklistItemsLoaded(String checklistId) async {}
}
