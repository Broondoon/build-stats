import 'package:Server/entity/checklist.dart';
import 'package:Server/services/cache_service.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';
import 'package:injector/injector.dart';
import 'package:shared/app_strings.dart';

class ChecklistDayCache extends CacheService<ChecklistDay> {
  final ChecklistDayFactory _parser;
  final LocalStorage _cacheLocalStorage;
  final ReadWriteMutex _m;

  ChecklistDayCache(this._parser, this._cacheLocalStorage, this._m)
      : super(_parser, _cacheLocalStorage, _m) {
    Checklist test = Checklist(
        id: ID_ChecklistPrefix + "1",
        worksiteId: ID_WorksitePrefix + "1",
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now());
    test.addChecklistDay(null, DateTime.now(), ID_ChecklistDayPrefix + "1");
    testDeepCache[test.id] = test.toJson();
  }
}

class ChecklistCache extends CacheService<Checklist> {
  final ChecklistFactory _parser;
  final LocalStorage _cacheLocalStorage;
  final ReadWriteMutex _m;
  ChecklistCache(this._parser, this._cacheLocalStorage, this._m)
      : super(_parser, _cacheLocalStorage, _m) {
    ChecklistDay test = ChecklistDay(
        id: ID_ChecklistDayPrefix + "1",
        checklistId: ID_ChecklistPrefix + "1",
        date: DateTime.now(),
        comment: 'test',
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now());
    test.addItemId('Test', ID_ItemPrefix + "1");
    testDeepCache[test.id] = test.toJson();
  }
}
