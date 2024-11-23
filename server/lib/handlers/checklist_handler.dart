import 'dart:convert';

import 'package:Server/entity/checklist.dart';
import 'package:Server/handlers/handler.dart';
import 'package:Server/storage/checklist_cache.dart';
import 'package:injector/injector.dart';
import 'package:shelf/shelf.dart';

class ChecklistHandler extends RequestHandler<Checklist> {
  ChecklistCache _checklistCache;
  ChecklistFactory _checklistFactory;
  ChecklistHandler(this._checklistCache, this._checklistFactory)
      : super(_checklistCache, _checklistFactory);

  Future<Response> handleGetChecklistsOnWorksite(
      Request request, String worksiteId) async {
    try {
      List<Checklist>? checklists = (await _checklistCache.getAll(
              (x) async => null
              //(x) async => await _checklistCache.LoadBulk((Checklist x) => x.worksiteId == worksiteId))
              ))
          ?.where((x) => x.worksiteId == worksiteId)
          .toList();
      if (checklists == null || checklists.isEmpty) {
        return Response.notFound("No checklists found");
      } else {
        return Response.ok(
            jsonEncode(checklists.map((x) => x.toJsonTransfer()).toList()),
            headers: {...jsonHeaders});
      }
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }
}
