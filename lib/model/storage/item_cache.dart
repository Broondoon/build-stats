import 'package:build_stats_flutter/model/Domain/Interface/data_connection_service.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/Domain/Interface/cache_service.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';
import 'package:localstorage/localstorage.dart';

class ItemCache extends CacheService<Item> {
  ItemCache(DataConnectionService<Item> dataConnectionService,
      JsonFileAccess fileIOService)
      : super(dataConnectionService, fileIOService, ItemFactory(),
            API_WorksitePath, WorksiteFileString, localStorage);
}
