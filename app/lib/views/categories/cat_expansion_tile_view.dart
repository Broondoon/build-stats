import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:build_stats_flutter/main.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/views/item/row_item_view.dart';

//////////////////////////////////////////////////////////////////////////

class CategoryExpansionTile extends StatefulWidget {
  final Text catTitle;
  final List<String> catIds;
  final ChangeManager changeManager;
  final ChecklistDay? checklistDay;
  final DateTime pageDay;

  const CategoryExpansionTile({
    super.key,
    required this.catTitle,
    required this.catIds,
    required this.changeManager,
    this.checklistDay,
    required this.pageDay,
  });

  @override
  State<CategoryExpansionTile> createState() => _CategoryExpansionTileState();
}

class _CategoryExpansionTileState extends State<CategoryExpansionTile> {
  // TODO: LOAD THIS DYNAMICALLY
  late List<Widget> _elemList;
  late List<String> _idList;
  late ChangeManager _changeManager;

  @override
  // TODO: declare this as async
  void initState() {
    super.initState();
    _idList = widget.catIds;
    _changeManager = widget.changeManager;
    
    // TODO: REMOVE THIS IT JUST PREVENTS AN ERROR
    _elemList = [];

    _loadItems();
  }

  Future<void> _loadItems() async {
    _elemList = [];

    for (String id in _idList) {
      Item? item = await _changeManager.getItemById(id);
      if (item != null) {
        
        _elemList.add(
          RowItem(
            item: item,
            // checklistDay: widget.checklistDay!,
            // pageDay: widget.pageDay,
          )
        );
      }
    }
  }

  void _addRowItem() async {

    Item? newItem;

    // Item newItem = await _changeManager.createItem(
    //   widget.checklistDay, 
    //   widget.catTitle.data!,
    // );

    setState(() {
      // _elemList.add(RowItem());
      _elemList.add(
        RowItem(
          item: newItem!,
          // checklistDay: widget.checklistDay!,
          // pageDay: widget.pageDay,
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return ExpansionTile(
      title: widget.catTitle,
      maintainState: true, // bug fix! Nice; easy one liner
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              // appState.newItem(elemList);
              _addRowItem();
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.add),
          //   onPressed: () {},
          // ),
        ],
      ),
      children: [ // elemList, // + [CatCommentCard()],
        SizedBox(
          height: 120,
          child: ListView.builder(
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            itemCount: _elemList.length,
            itemBuilder: (context, index) {
              return _elemList[index];
              // return ListTile(title: Text("Item @ $index"));
            },
          ),
        )
      ]
    );
  }
}