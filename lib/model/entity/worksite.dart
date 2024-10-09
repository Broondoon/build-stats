import 'package:build_stats_flutter/model/entity/checklist.dart';

class Worksite {
  String id;
  String? ownerId;
  List<Checklist> checklists;

  Worksite({
    required this.id,
    this.ownerId,
    required this.checklists,
  });

  factory Worksite.fromJson(Map<String, dynamic> json) {
    return Worksite(
      id: json['id'],
      ownerId: json['ownerId'],
      checklists: json['checklists']
          .map<Checklist>((json) => Checklist.fromJson(json))
          .toList(),
    );
  }
}
