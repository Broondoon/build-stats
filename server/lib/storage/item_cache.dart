import 'dart:convert';

import 'package:Server/entity/item.dart';
import 'package:Server/services/cache_service.dart';
import 'package:mutex/mutex.dart';
import 'package:injector/injector.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/cache.dart';

class ItemCache extends CacheService<Item> {
  final ItemFactory _parser;
  final LocalStorage _cacheLocalStorage;
  final ReadWriteMutex _m;
  ItemCache(this._parser, this._cacheLocalStorage, this._m)
      : super(_parser, _cacheLocalStorage, _m, ID_ItemPrefix);
}
