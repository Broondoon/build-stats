import 'package:Server/entity/item.dart';
import 'package:Server/services/cache_service.dart';
import 'package:mutex/mutex.dart';
import 'package:localstorage/localstorage.dart';

class ItemCache extends CacheService<Item> {
  ItemCache() : super(ItemFactory(), localStorage, ReadWriteMutex());
}
