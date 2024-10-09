import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'item.dart';

class Checklist {
  String id;
  String worksiteId;
  Worksite? worksite;
  DateTime? date;
  String? comment;
  List<Item> items;

  Checklist(
      {required this.id,
      required this.worksiteId,
      this.date,
      this.comment,
      required this.items});

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      id: json['id'],
      worksiteId: json['worksiteId'],
      date: json['date'],
      comment: json['comment'],
      items: json['items'].map<Item>((json) => Item.fromJson(json)).toList(),
    );
  }
}
