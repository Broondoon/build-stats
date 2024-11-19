// View Imports:

import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/views/checklist/checklist_view.dart';
import 'package:flutter/material.dart';

class OldCategoryView extends StatelessWidget {
  const OldCategoryView({
    super.key,
    required this.changeManager,
    required this.pageDay,
  });

  final ChangeManager changeManager;
  final DateTime pageDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategoryExpansionTile(
          catTitle: Text("Labour"),
          catIds: [], // currItemsByCat![0],
          changeManager: changeManager,
          checklistDay: null, //currChecklistDay!,
          pageDay: pageDay,
        ),
          
        CategoryExpansionTile(
          catTitle: Text("Equipment"),
          catIds: [], // currItemsByCat![1],
          changeManager: changeManager,
          checklistDay: null, // currChecklistDay!,
          pageDay: pageDay,
        ),
          
        CategoryExpansionTile(
          catTitle: Text("Materials"),
          catIds: [], // currItemsByCat![0],
          changeManager: changeManager,
          checklistDay: null, // currChecklistDay!,
          pageDay: pageDay,
        ),
      ],
    );
  }
}
