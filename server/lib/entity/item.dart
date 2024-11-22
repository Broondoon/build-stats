import 'package:shared/item.dart';

class Item extends BaseItem {
  Item({
    required super.id,
    required super.checklistDayId,
    super.unit,
    super.desc,
    super.result,
    super.comment,
    super.creatorId,
    super.verified,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  Item.fromBaseItem({required super.item}) : super.fromBaseItem();
}

class ItemFactory extends BaseItemFactory<Item> {
  @override
  Item fromJson(Map<String, dynamic> json) =>
      Item.fromBaseItem(item: super.fromJson(json));
}