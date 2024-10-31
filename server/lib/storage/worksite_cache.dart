import 'package:Server/entity/worksite.dart';
import 'package:Server/services/cache_service.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';
import 'package:injector/injector.dart';
import 'package:shared/app_strings.dart';

class WorksiteCache extends CacheService<Worksite> {
  final WorksiteFactory _parser;
  final LocalStorage _cacheLocalStorage;
  final ReadWriteMutex _m;

  WorksiteCache(this._parser, this._cacheLocalStorage, this._m)
      : super(_parser, _cacheLocalStorage, _m) {
    Worksite test = Worksite(
        id: ID_WorksitePrefix + "1",
        companyId: ID_CompanyPrefix + "1",
        ownerId: ID_UserPrefix + "1",
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now());
    test.checklistIds = [ID_ChecklistPrefix + "1"];
    testDeepCache[test.id] = test.toJson();
  }
}
