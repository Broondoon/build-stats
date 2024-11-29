import 'package:shared/app_strings.dart';
import 'package:shared/src/base_entities/entity/entity.dart';

class BaseItem extends Entity {
  late String checklistDayId;
  late String? unitId;
  late String? desc;
  late String? result;
  late String? comment;
  late String? creatorId;
  late bool? verified;
  String? prevId;

  BaseItem({
    required super.id,
    super.name,
    required this.checklistDayId,
    this.unitId,
    this.desc,
    this.result,
    this.comment,
    this.creatorId,
    this.verified,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
    this.prevId,
  });

  BaseItem.fromBaseItem({required BaseItem item}) : this.fromEntity(entity: item, checklistDayId: item. checklistDayId, unitId: item.unitId, desc: item.desc, result: item.result, comment: item.comment, creatorId: item.creatorId, verified: item.verified, prevId: item.prevId);

  BaseItem.fromEntity({required super.entity, required this.checklistDayId, this.unitId, this.desc, this.result, this.comment, this.creatorId, this.verified, this.prevId})
      : super.fromEntity();

  @override
  toJson() {
        Map<String, dynamic> map = super.toJson();
    map['checklistDayId'] = checklistDayId;
    map['unitId'] = unitId;
    map['desc'] = desc;
    map['result'] = result;
    map['comment'] = comment;
    map['creatorId'] = creatorId;
    map['verified'] = verified?.toString() ?? "";
    map['prevId'] = prevId ?? "";
    map['flagForDeletion'] = flagForDeletion.toString();
    return map;
  }

  @override
  toJsonTransfer() {
        Map<String, dynamic> map = super.toJsonTransfer();
    map['checklistDayId'] = checklistDayId;
    map['unitId'] = unitId;
    map['desc'] = desc;
    map['result'] = result;
    map['comment'] = comment;
    map['creatorId'] = creatorId;
    map['verified'] = verified?.toString() ?? "";
    map['prevId'] = prevId ?? "";
    return map;
  }

  @override
  joinData() {
    return super.joinData() + '|' + ([
      checklistDayId,
      unitId ?? '',
      desc ?? '',
      result ?? '',
      comment ?? '',
      creatorId?.toString() ?? '',
      verified?.toString() ?? '',
      prevId ?? '',
    ].join('|'));
  }
}

class BaseItemFactory<T extends BaseItem> extends EntityFactory<T> {
  @override
  BaseItem fromJson(Map<String, dynamic> json) {
    return BaseItem.fromEntity(
        entity: super.fromJson(json),
        checklistDayId: json['checklistDayId'],
        unitId: json['unitId'],
        desc: json['desc'],
        result: json['result'],
        comment: json['comment'],
        creatorId: json['creatorId'],
        verified: json['verified'] == "true",
        prevId: json['prevId'],
    );
  }
}
