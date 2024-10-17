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

  // var nullToList = (List<String> ?jsonList) => jsonList ?? <String>[];

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      id: json['id'],
      worksiteId: json['worksiteId'] ?? "-1234",
      date: DateTime.parse(json['date'] ?? "1969-07-20"),
      comment: json['comment'],
      // itemIds: json['itemIds']?.toList().then(), // BIG POTENTIAL ISSUE; allowing NULL here is somewhat DANGEROUS
      // itemIds: nullToList(json['itemIds']),
      itemIds: json['itemIds'] ?? <String>[],
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
