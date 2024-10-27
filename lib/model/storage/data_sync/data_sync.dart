import 'dart:collection';

import 'package:build_stats_flutter/model/Domain/Interface/cache_service.dart';
import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
import 'package:build_stats_flutter/model/storage/item_cache.dart';
import 'package:build_stats_flutter/model/storage/worksite_cache.dart';

class DataSync {
  final WorksiteCache _worksiteCache;
  final ChecklistCache _checklistCache;
  final ItemCache _itemCache;

  DataSync(this._worksiteCache, this._checklistCache, this._itemCache);

  //default expect that if we send an ID to the server, and the server doesnt have that ID in Cache, we're immediatly flagging that ID for refresh, as it implies that the server went down, and we need to ensure that the server cache is up to date.

  //on server side, we're pretty much just gonna have copies of our cache setups.
  Future<void> checkCacheSync() async {
    //Get server checksums

    //compare server Checksums to our current caches.

    //Check for data sync.
    //just go through all values in the cache, get checksums for each, compare checksums, and then flag the stuff that should be changed.
    //right now, set up a really nasty version that overwrites everything. We'll add proper merging functionality when we add the database.
    //THe idea here is that we don't have a database really. So whatever version is currently in server cache is the most up to date version.
    //So we just overwrite everything with the server cache.

    throw UnimplementedError();
  }
}
