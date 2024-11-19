import 'dart:convert';

import 'package:Server/entity/checklist.dart';
import 'package:Server/services/cache_service.dart';
import 'package:mutex/mutex.dart';
import 'package:injector/injector.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/cache.dart';

class ChecklistDayCache extends CacheService<ChecklistDay> {
  final ChecklistDayFactory _parser;
  final LocalStorage _cacheLocalStorage;
  final ReadWriteMutex _m;

  ChecklistDayCache(this._parser, this._cacheLocalStorage, this._m)
      : super(_parser, _cacheLocalStorage, _m);
}

class ChecklistCache extends CacheService<Checklist> {
  final ChecklistFactory _parser;
  final LocalStorage _cacheLocalStorage;
  final ReadWriteMutex _m;
  ChecklistCache(this._parser, this._cacheLocalStorage, this._m)
      : super(_parser, _cacheLocalStorage, _m);
}
