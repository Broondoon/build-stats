import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:localstorage/localstorage.dart';

class Worksite {
  String id;
  String? ownerId;
  List<String> checklistIds = [];
  List<Checklist> checklists =
      []; //only for internal use. do not transfer out of app.

  Worksite({
    required this.id,
    this.ownerId,
    required this.checklistIds,
  });

  factory Worksite.fromJson(Map<String, dynamic> json) {
    return Worksite(
      id: json['id'],
      ownerId: json['ownerId'],
      checklistIds: List<String>.from(json['checklistIds'] ?? <String>[]),
    );
  }

  toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'checklistIds': checklistIds,
    };
  }
}
