import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/resources/app_colours.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:build_stats_flutter/main.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/views/item/item_view.dart';

//////////////////////////////////////////////////////////////////////////

class CategoryExpansionTile extends StatefulWidget {
  final Text catTitle;
  final List<String> catIds;
  final ChangeManager changeManager;
  final ChecklistDay? checklistDay;
  final DateTime pageDay;

  CategoryExpansionTile({
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
            changeManager: _changeManager,
            checklistDay: widget.checklistDay,
            pageDay: widget.pageDay,
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
          item: newItem,
          changeManager: _changeManager,
          checklistDay: widget.checklistDay,
          pageDay: widget.pageDay,
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ExpansionTile(
      title: widget.catTitle,
      maintainState: true, // bug fix! Nice; easy one liner
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.add),
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
        Container(
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

/////////////////////////////////////////////////////////////////////////////

class DateRow extends StatefulWidget {
  const DateRow({
    super.key,
    required this.startDay,
    required this.pageDay,
    required this.onDateChange,
  });

  // final Checklist? currChecklist;
  final DateTime startDay;
  final DateTime pageDay;
  final ValueChanged<DateTime> onDateChange;

  @override
  State<DateRow> createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  late DateTime _startDay;
  late DateTime _currDay;

  @override
  void initState() {
    super.initState();
    _startDay = widget.startDay;
    _currDay = widget.pageDay;
  }

  void changeDateTime(bool increment) {
    setState(() {
      if (increment) {
        _currDay = _currDay.add(Duration(days: 1));
      }
      else {
        if (_currDay.isAfter(_startDay)) {
          _currDay = _currDay.subtract(Duration(days: 1));
        }
      }

      widget.onDateChange(_currDay);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyAppColours.g5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 10,
            onPressed: () {
              changeDateTime(false);
            },
          ),
      
          Text(
            "Date: ${_currDay.year}-${_currDay.month}-${_currDay.day}",
            style: MyAppStyle.regularFont,
          ), // ?? "No date"),
          // Text("2024-08-09", style: MyAppStyle.regularFont,),
      
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            iconSize: 10,
            onPressed: () {
              changeDateTime(true);
            },
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////

class CatCommentCard extends StatelessWidget {
  const CatCommentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: TextFormField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Comment here..."
          ),
        )
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Card(
          margin: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Comment here!"
              ),
            ),
          ),
        ),
      ),
    );
  }
}