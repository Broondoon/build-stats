import 'package:shared/entity.dart';

class Cacheable extends Entity {
  Cacheable(
      {required super.id,
      required super.dateCreated,
      required super.dateUpdated,
      super.flagForDeletion = false});
}

class CacheableFactory<T extends Cacheable> extends EntityFactory<T> {}
