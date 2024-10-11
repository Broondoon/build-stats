import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'item.dart';

class Checklist {
  String id;
  String worksiteId;
  //Worksite? worksite;
  DateTime? date;
  String? comment;
  List<String> itemIds = [];
  List<Item> items = []; //only for internal use. do not transfer out of app.

  Checklist(
      {required this.id,
      required this.worksiteId,
      this.date,
      this.comment,
      required this.itemIds});

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      id: json['id'],
      worksiteId: json['worksiteId'],
      date: json['date'],
      comment: json['comment'],
      itemIds: json['itemIds'].toList(),
    );
  }

  toJson() {
    return {
      'id': id,
      'worksiteId': worksiteId,
      'date': date?.toIso8601String(),
      'comment': comment,
      'items': itemIds,
    };
  }
}
