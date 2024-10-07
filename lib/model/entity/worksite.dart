import 'package:build_stats_flutter/model/entity/checklist.dart';

class Worksite {
  int id;
  int? ownerId;
  List<Checklist>? checklists;

  Worksite({
    required this.id,
    this.ownerId,
    this.checklists,
  })
}