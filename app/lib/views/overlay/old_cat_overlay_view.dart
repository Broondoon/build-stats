// View Imports:

import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/item/item_view.dart';
import 'package:build_stats_flutter/views/overlay/overlay_interface.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class OldCat extends StatefulWidget implements OverlayImpInterface {
  const OldCat({
    super.key,
  });

  // TODO: make this work
  @override
  void timeToClose() {
    // ...suposedly implemented by the State class?
    // print("STATED POORLY");
  }

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