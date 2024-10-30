import 'package:Server/entity/checklist.dart';
import 'package:Server/services/cache_service.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';

class ChecklistDayCache extends CacheService<ChecklistDay> {
  ChecklistDayCache()
      : super(ChecklistDayFactory(), localStorage, ReadWriteMutex());
}

class ChecklistCache extends CacheService<Checklist> {
  ChecklistCache() : super(ChecklistFactory(), localStorage, ReadWriteMutex());
}
