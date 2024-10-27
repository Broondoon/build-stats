abstract class CacheableInterface {
  toJson();
  getChecksum();
}

abstract class Cacheable implements CacheableInterface {
  String id;
  Cacheable({required this.id});
  @override
  toJson() => throw UnimplementedError();
  @override
  getChecksum() => throw UnimplementedError();
}

abstract class CacheableFactory<T extends Cacheable> {
  T fromJson(Map<String, dynamic> json) => throw UnimplementedError();
}
