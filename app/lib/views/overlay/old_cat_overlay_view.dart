// View Imports:

import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/item/item_view.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class OldCat extends StatefulWidget {
  const OldCat({
    super.key,
  });

  @override
  State<OldCat> createState() => _OldCatState();
}

class _OldCatState extends State<OldCat> {
  ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Labour",
          style: MyAppStyle.largeFont,
        ),
        RowItem(
          item: null,
          changeManager: changeManager,
          // checklistDay: ,
          // pageDay: ,
        ),
        RowItem(
          item: null,
          changeManager: changeManager,
          // checklistDay: ,
          // pageDay: ,
        ),
        RowItem(
          item: null,
          changeManager: changeManager,
          // checklistDay: ,
          // pageDay: ,
        ),
        RowItem(
          item: null,
          changeManager: changeManager,
          // checklistDay: ,
          // pageDay: ,
        ),
        RowItem(
          item: null,
          changeManager: changeManager,
          // checklistDay: ,
          // pageDay: ,
        ),
      ],
    );
  }
}