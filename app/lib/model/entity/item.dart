import 'package:shared/item.dart';

class Item extends BaseItem {
  Item({
    required super.id,
    super.name,
    required super.checklistDayId,
    super.unitId,
    super.desc,
    super.result,
    super.comment,
    super.creatorId,
    super.verified,
    required super.dateCreated,
    required super.dateUpdated,
    super.prevId,
    super.flagForDeletion = false,
  });

  Item.fromBaseItem({required super.item}) : super.fromBaseItem();
}

class ItemFactory extends BaseItemFactory<Item> {
  @override
  Item fromJson(Map<String, dynamic> json) {
    return Item.fromBaseItem(item: super.fromJson(json));
  }
}
