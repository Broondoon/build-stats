import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';

class Item {
  String id;
  String checklistDayId;
  String? unit;
  String? desc;
  String? result;
  String? comment;
  int? creatorId;
  bool? verified;
  DateTime dateCreated;
  DateTime dateUpdated;

  Item(
      {required this.id,
      required this.checklistDayId,
      this.unit,
      this.desc,
      this.result,
      this.comment,
      this.creatorId,
      this.verified,
      required this.dateCreated,
      required this.dateUpdated});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        id: json['id'],
        checklistDayId: json['checklistDayId'],
        unit: json['unit'],
        desc: json['desc'],
        result: json['result'],
        comment: json['comment'],
        creatorId: json['creatorId'],
        verified: json['verified'],
        dateCreated: DateTime.parse(json['dateCreated'] ?? FallbackDate),
        dateUpdated: DateTime.parse(json['dateUpdated'] ?? FallbackDate));
  }

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
    };
  }

  getChecksum() {
    throw UnimplementedError();
  }
}
