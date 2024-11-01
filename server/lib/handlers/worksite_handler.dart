import 'dart:convert';

import 'package:Server/entity/worksite.dart';
import 'package:Server/handlers/handler.dart';
import 'package:Server/storage/worksite_cache.dart';
import 'package:injector/injector.dart';
import 'package:shared/app_strings.dart';
import 'package:shelf/shelf.dart';

class WorksiteHandler extends RequestHandler<Worksite> {
  final WorksiteCache _worksiteCache;
  final WorksiteFactory _worksiteFactory;
  WorksiteHandler(this._worksiteCache, this._worksiteFactory)
      : super(_worksiteCache, _worksiteFactory);

  Future<Response> handleGetUserVisibleWorksites(
      Request request, String companyId, String userId) async {
    try {
      List<Worksite>? worksites = (await _worksiteCache.getAll((x) async =>
              await _worksiteCache.LoadBulk((Worksite x) =>
                  x.ownerId == userId && x.companyId == companyId)))
          ?.where((x) => x.ownerId == userId && x.companyId == companyId)
          .toList();
      if (worksites == null) {
        return Response.notFound("No worksites found");
      } else {
        return Response.ok(jsonEncode(worksites.map((x) => x.toJsonTransfer())),
            headers: {...jsonHeaders});
      }
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }
}
