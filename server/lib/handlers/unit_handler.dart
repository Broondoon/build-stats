import 'dart:convert';

import 'package:Server/entity/unit.dart';
import 'package:Server/handlers/handler.dart';
import 'package:Server/storage/unit_cache.dart';
import 'package:injector/injector.dart';
import 'package:shared/app_strings.dart';
import 'package:shelf/shelf.dart';

class UnitHandler extends RequestHandler<Unit> {
  final UnitCache _unitCache;
  final UnitFactory _unitFactory;
  UnitHandler(this._unitCache, this._unitFactory)
      : super(_unitCache, _unitFactory);

  Future<Response> handleGetAll(Request request, String companyId) async {
    try {
      List<Unit>? units = (await _unitCache.getAll((x) async => null
              //(x) async => await _worksiteCache.LoadBulk((Worksite x) => x.ownerId == userId && x.companyId == companyId)
              ))
          ?.where((x) => x.companyId == companyId)
          .toList();
      if (units == null || units.isEmpty) {
        return Response.notFound("No units found");
      } else {
        return Response.ok(
            jsonEncode(units.map((x) => x.toJsonTransfer()).toList()),
            headers: {...jsonHeaders});
      }
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }
}
