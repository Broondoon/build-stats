// View Imports:
import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/item/row_item_view.dart';
import 'package:build_stats_flutter/views/overlay/overlay_interface.dart';
import 'package:build_stats_flutter/views/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:provider/provider.dart';

class OldCat extends StatefulWidget implements OverlayImpInterface {
  const OldCat({
    super.key,
    required this.catTitle,
    // required this.catIds,
    // required this.checklistDay,
    // required this.pageDay,
  });

  final String catTitle;
  // final List<String> catIds;
  // final ChecklistDay checklistDay;
  // final DateTime pageDay;

  // TODO: DEPRECATED; LONGER NEEDED
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
  List<Widget> _itemList = [];
  List<String> _idList = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    
    print('LOADING ITEMS!');

    _idList = await Provider.of<MyAppState>(
      context, 
      listen: false
    ).loadItemsFromCat(widget.catTitle);
    _itemList = [];

    print('\nLIST OF IDS:\n$_idList\n');

    for (String id in _idList) {
      Item? item = await changeManager.getItemById(id);
      // print('ITEM: \n${item?.toJson()}\n\n');
      if (item != null) {
        setState(() {
          print("ADDING NEW ITEM 'CAUSE WE FOUND IT BY ID");
          _itemList.add(
            RowItem(
              item: item,
              // checklistDay: widget.checklistDay,
              // pageDay: widget.pageDay,
            )
          );
        });
      }
      else {
        print('COULD NOT FIND ITEM BY ID');
        print('MISSING ID: $id');
      }
    }
  }

  Future<void> _addItem() async {
    Item newItem = await changeManager.createItem(
      // widget.checklistDay, 
      Provider.of<MyAppState>(
        context, 
        listen: false
      ).currChecklistDay!,
      widget.catTitle
    );

    setState(() {
      _itemList.add(
        RowItem(
          item: newItem,
          // checklistDay: widget.checklistDay,
          // pageDay: widget.pageDay,
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.catTitle,
          style: MyAppStyle.largeFont,
        ),
        Flexible(
          child: ListView.builder(
            itemCount: _itemList.length,
            itemBuilder: (context, index) {
              return _itemList[index];
            }
          ),
        ),
        TextButton(
          style: MyAppStyle.buttonStyle,
          onPressed: _addItem,
          child: const Text(
            'Add New Item',
            style: MyAppStyle.regularFont, 
          ),
        )
      ],
    );
  }
}