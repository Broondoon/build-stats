import 'package:build_stats_flutter/model/Domain/ServiceInterface/data_connection_service.dart';

class DataConnection<T> implements DataConnectionService<T> {
  //Check for data sync.
  //just go through all values in the cache, get checksums for each, compare checksums, and then flag the stuff that should be changed.
  //right now, set up a really nasty version that overwrites everything. We'll add proper merging functionality when we add the database.
  //THe idea here is that we don't have a database really. So whatever version is currently in server cache is the most up to date version.
  //So we just overwrite everything with the server cache.

  @override
  Future<bool> delete(String path, String key) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Iterable<T>> get(String path, List<String> keys) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<T> post(String path, T value) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<T> put(String path, T value) {
    // TODO: implement put
    throw UnimplementedError();
  }
}
