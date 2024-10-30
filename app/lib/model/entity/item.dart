import 'package:build_stats_flutter/model/Domain/Interface/cachable.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';

class Item extends Cacheable {
  String checklistDayId;
  String? unit;
  String? desc;
  String? result;
  String? comment;
  String? creatorId;
  bool? verified;

  Item({
    required super.id,
    required this.checklistDayId,
    this.unit,
    this.desc,
    this.result,
    this.comment,
    this.creatorId,
    this.verified,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  @override
  toJson() {
    return {
      'id': id,
      'checklistDayId': checklistDayId,
      'unit': unit,
      'desc': desc,
      'result': result,
      'comment': comment,
      'creatorId': creatorId,
      'verified': verified,
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
      'flagForDeletion': flagForDeletion,
    };
  }

  @override
  toJsonNoTempIds() {
    return {
      'id': id,
      'checklistDayId': checklistDayId,
      'unit': unit,
      'desc': desc,
      'result': result,
      'comment': comment,
      'creatorId': creatorId,
      'verified': verified,
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
    };
  }

  @override
  joinData() {
    return [
      id,
      checklistDayId,
      unit ?? '',
      desc ?? '',
      result ?? '',
      comment ?? '',
      creatorId?.toString() ?? '',
      verified?.toString() ?? '',
      dateCreated.toIso8601String(),
      dateUpdated.toIso8601String(),
    ].join('|');
  }
}

class ItemFactory extends CacheableFactory<Item> {
  @override
  Item fromJson(Map<String, dynamic> json) {
    return Item(
        id: json['id'],
        checklistDayId: json['checklistDayId'],
        unit: json['unit'],
        desc: json['desc'],
        result: json['result'],
        comment: json['comment'],
        creatorId: json['creatorId'],
        verified: json['verified'],
        dateCreated:
            DateTime.parse(json['dateCreated'] ?? Default_FallbackDate),
        dateUpdated:
            DateTime.parse(json['dateUpdated'] ?? Default_FallbackDate),
        flagForDeletion: json['flagForDeletion'] ?? false);
  }
}
