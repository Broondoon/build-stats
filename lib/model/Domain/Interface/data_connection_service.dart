import 'dart:core';
import 'dart:collection';
import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:build_stats_flutter/model/Domain/Interface/cachable.dart';
import 'package:build_stats_flutter/model/Domain/Interface/cache_service.dart';

abstract class DataConnectionService<T extends CacheableInterface> {
  Future<String> get(String path, List<String> keys);
  Future<String> post(String path, T value);
  Future<String> put(String path, T value);
  Future<void> delete(String path, String key);
}

class DataConnection<T extends CacheableInterface>
    implements DataConnectionService<T> {
  @override
  Future<void> delete(String path, String key) {
    // TODO: implement delete
    throw HttpException(503, "Service Unavailable");
  }

  @override
  Future<String> get(String path, List<String> keys) {
    //implement throwing 404 error.
    //throw NotFoundException(body)
    // TODO: implement get
    throw HttpException(503, "Service Unavailable");
  }

  @override
  Future<String> post(String path, T value) {
    // TODO: implement post
    throw HttpException(503, "Service Unavailable");
  }

  @override
  Future<String> put(String path, T value) {
    // TODO: implement put
    throw HttpException(503, "Service Unavailable");
  }
}

class EntityReturnDataConnection<T extends Cacheable>
    extends DataConnection<T> {
  Future<Iterable<T>> getEntity(String path, List<String> keys) async {
    String data = await get(path, keys);
    throw UnimplementedError();
  }

  Future<T> postEntity(String path, T value) async {
    String data = await post(path, value);
    throw UnimplementedError();
  }
}
