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

  BaseItem({
    required super.id,
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
  });

  BaseItem.fromBaseItem({required BaseItem item})
      : super(
          id: item.id,
          dateCreated: item.dateCreated,
          dateUpdated: item.dateUpdated,
          flagForDeletion: item.flagForDeletion,
        ) {
    checklistDayId = item.checklistDayId;
    unitId = item.unitId;
    desc = item.desc;
    result = item.result;
    comment = item.comment;
    creatorId = item.creatorId;
    verified = item.verified;
  }

  @override
  toJson() {
    return {
      'id': id,
      'checklistDayId': checklistDayId,
      'unitId': unitId,
      'desc': desc,
      'result': result,
      'comment': comment,
      'creatorId': creatorId,
      'verified': verified?.toString() ?? "",
      'dateCreated': dateCreated.toUtc().toIso8601String(),
      'dateUpdated': dateUpdated.toUtc().toIso8601String(),
      'flagForDeletion': flagForDeletion.toString(),
    };
  }

  @override
  toJsonTransfer() {
    return {
      'id': id,
      'checklistDayId': checklistDayId,
      'unitId': unitId,
      'desc': desc,
      'result': result,
      'comment': comment,
      'creatorId': creatorId,
      'verified': verified,
      'dateCreated': dateCreated.toUtc().toIso8601String(),
      'dateUpdated': dateUpdated.toUtc().toIso8601String(),
    };
  }

  @override
  joinData() {
    return [
      id,
      checklistDayId,
      unitId ?? '',
      desc ?? '',
      result ?? '',
      comment ?? '',
      creatorId?.toString() ?? '',
      verified?.toString() ?? '',
      dateCreated.toUtc().toIso8601String(),
      dateUpdated.toUtc().toIso8601String(),
    ].join('|');
  }
}

class BaseItemFactory<T extends BaseItem> extends EntityFactory<T> {
  @override
  BaseItem fromJson(Map<String, dynamic> json) {
    return BaseItem(
        id: json['id'],
        checklistDayId: json['checklistDayId'],
        unitId: json['unitId'],
        desc: json['desc'],
        result: json['result'],
        comment: json['comment'],
        creatorId: json['creatorId'],
        verified: json['verified'] == "true",
        dateCreated:
            DateTime.parse(json['dateCreated'] ?? Default_FallbackDate),
        dateUpdated:
            DateTime.parse(json['dateUpdated'] ?? Default_FallbackDate),
        flagForDeletion: json['flagForDeletion'] == "true");
  }
}
