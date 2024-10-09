import 'package:build_stats_flutter/model/entity/checklist.dart';

class Item {
  String id;
  int checklistId;
  Checklist? checklist;
  String? unit;
  String? desc;
  String? result;
  String? comment;
  int? creatorId;
  bool? verified;

  Item(
      {required this.id,
      required this.checklistId,
      this.unit,
      this.desc,
      this.result,
      this.comment,
      this.creatorId,
      this.verified});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        id: json['id'],
        checklistId: json['checklistId'],
        unit: json['unit'],
        desc: json['desc'],
        result: json['result'],
        comment: json['comment'],
        creatorId: json['creatorId'],
        verified: json['verified']);
  }
}
