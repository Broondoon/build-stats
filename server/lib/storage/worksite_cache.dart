import 'package:Server/entity/worksite.dart';
import 'package:Server/services/cache_service.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';

class WorksiteCache extends CacheService<Worksite> {
  WorksiteCache() : super(WorksiteFactory(), localStorage, ReadWriteMutex());
}
