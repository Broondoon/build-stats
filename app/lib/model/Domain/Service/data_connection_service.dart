import 'dart:core';
import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:shared/entity.dart';

abstract class DataConnectionService<T extends Entity> {
  Future<String> get(String path);
  Future<String> post(String path, T value);
  Future<String> put(String path, T value);
  Future<void> delete(String path, String key);
}

class DataConnection<T extends Entity> implements DataConnectionService<T> {
  @override
  Future<void> delete(String path, String key) {
    // TODO: implement delete
    throw HttpException(503, "Service Unavailable");
  }

  @override
  Future<String> get(String path) {
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

class EntityReturnDataConnection<T extends Entity> extends DataConnection<T> {
  Future<Iterable<T>> getEntity(String path) async {
    String data = await get(path);
    throw UnimplementedError();
  }

  Future<T> postEntity(String path, T value) async {
    String data = await post(path, value);
    throw UnimplementedError();
  }
}
