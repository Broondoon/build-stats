import 'item.dart';

class Checklist {
  int id;
  int worksiteId;
  DateTime? date;
  String? comment;
  List<Item>? items;

  Checklist({required this.id,
    required this.worksiteId,
    this.date,
    this.comment,
    this.items})
}