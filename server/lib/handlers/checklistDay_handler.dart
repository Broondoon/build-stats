import 'package:Server/entity/checklist.dart';
import 'package:Server/handlers/handler.dart';
import 'package:Server/storage/checklist_cache.dart';
import 'package:injector/injector.dart';
import 'package:shelf/shelf.dart';

class ChecklistDayHandler extends RequestHandler<ChecklistDay> {
  ChecklistDayCache _checklistDayCache;
  ChecklistDayFactory _checklistDayFactory;
  ChecklistDayHandler(this._checklistDayCache, this._checklistDayFactory)
      : super(_checklistDayCache, _checklistDayFactory);

  Future<Response> handleGetDaysOnChecklist(
      Request request, String checklistId) async {
    try {
      List<ChecklistDay>? checklistDays = (await _checklistDayCache.getAll(
              (x) async => await _checklistDayCache.LoadBulk(
                  (ChecklistDay x) => x.checklistId == checklistId)))
          ?.where((x) => x.checklistId == checklistId)
          .toList();
      return Response.ok(checklistDays, headers: {...jsonHeaders});
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }
}