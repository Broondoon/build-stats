import 'dart:convert';

import 'package:Server/services/cache_service.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/cache.dart';
import 'package:shared/entity.dart';
import 'package:shelf/shelf.dart';

abstract class HandlerInterface<T extends Entity> {
  Future<Response> handleGet(Request request, String id);
  Future<Response> handlePost(Request request);
  Future<Response> handlePut(Request request);
  Future<Response> handleDelete(Request request);
}

class RequestHandler<T extends Entity> implements HandlerInterface<T> {
  final CacheService<T> _cache;
  final EntityFactory<T> _parser;

  RequestHandler(this._cache, this._parser);

  final jsonHeaders = {
    'content-type': 'application/json',
  };

  @override
  Future<Response> handleGet(Request request, String id) async {
    try {
      T? entity = await _cache.getById(id);
      return Response.ok(entity?.toJsonTransfer(), headers: {...jsonHeaders});
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }

  @override
  Future<Response> handlePost(Request request) async {
    try {
      T entity = _parser.fromJson(jsonDecode((await request.readAsString())));
      entity.id = entity.id.replaceAll(ID_TempIDPrefix, "");
      T? entityResponse = await _cache.store(entity.id, entity);
      return Response.ok(
        jsonEncode(entityResponse),
        headers: {...jsonHeaders},
      );
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }

  @override
  Future<Response> handlePut(Request request) async {
    try {
      T entity = _parser.fromJson(jsonDecode((await request.readAsString())));
      T? entityResponse = await _cache.store(entity.id, entity);
      return Response.ok(
        entityResponse.toJsonTransfer(),
        headers: {...jsonHeaders},
      );
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }

  @override
  Future<Response> handleDelete(Request request) async {
    try {
      List<String> ids = await request
          .readAsString()
          .then((value) => jsonDecode(value).cast<String>());
      for (String id in ids) {
        await _cache.delete(id);
      }
      return Response.ok(
        jsonEncode({'message': 'Deleted'}),
        headers: {...jsonHeaders},
      );
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }
}
