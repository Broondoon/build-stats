import 'dart:convert';

import 'package:Server/entity/checklist.dart';
import 'package:Server/entity/item.dart';
import 'package:Server/handlers/handler.dart';
import 'package:Server/storage/checklist_cache.dart';
import 'package:Server/storage/item_cache.dart';
import 'package:injector/injector.dart';
import 'package:shelf/shelf.dart';

class ItemHandler extends RequestHandler<Item> {
  ItemCache _itemCache;
  ItemFactory _itemFactory;
  ItemHandler(this._itemCache, this._itemFactory)
      : super(_itemCache, _itemFactory);

  Future<Response> handleGetItemsOnChecklistDay(
      Request request, String checklistDayId) async {
    try {
      List<Item>? items = (await _itemCache.getAll((x) async => null
              //(x) async => await _itemCache.LoadBulk((Item x) => x.checklistDayId == checklistDayId)
              ))
          ?.where((x) => x.checklistDayId == checklistDayId)
          .toList();
      if (items == null || items.isEmpty) {
        return Response.notFound("No items found");
      } else {
        return Response.ok(
            jsonEncode(items.map((x) => x.toJsonTransfer()).toList()),
            headers: {...jsonHeaders});
      }
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }

  Future<Response> handleGetItemsOnChecklist(
      Request request, String checklistId) async {
    try {
      ChecklistDayCache _checklistCache =
          Injector.appInstance.get<ChecklistDayCache>();
      List<String>? checklistDayIds = (await _checklistCache.getAll(
              (x) async => null
              //(x) async => await _checklistCache.LoadBulk((ChecklistDay x) => x.checklistId == checklistId)
              ))
          ?.where((x) => x.checklistId == checklistId)
          .map((x) => x.id)
          .toList();

      List<Item>? items = (await _itemCache.getAll((x) async => null
              //(x) async => await _itemCache.LoadBulk((Item x) => checklistDayIds?.contains(x.checklistDayId) ?? false)
              ))
          ?.where((x) => checklistDayIds?.contains(x.checklistDayId) ?? false)
          .toList();
      if (items == null || items.isEmpty) {
        return Response.notFound("No items found");
      } else {
        return Response.ok(
            jsonEncode(items.map((x) => x.toJsonTransfer()).toList()),
            headers: {...jsonHeaders});
      }
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }
}
