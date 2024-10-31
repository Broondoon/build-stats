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

  CategoryExpansionTile({
    super.key,
    required this.catTitle,
  });

  @override
  State<CategoryExpansionTile> createState() => _CategoryExpansionTileState();
}

class _CategoryExpansionTileState extends State<CategoryExpansionTile> {
  // TODO: LOAD THIS DYNAMICALLY
  List<Widget> _elemList = [];

  void _addRowItem() {
    setState(() {
      _elemList.add(RowItem());
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

class DateRow extends StatelessWidget {
  const DateRow({
    super.key,
    required this.currChecklist,
  });

  final Checklist? currChecklist;

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
            onPressed: () {},
          ),
      
          // Text(
              // "Date: ${currChecklist?.date?.year}-${currChecklist?.date?.month}-${currChecklist?.date?.day}"), // ?? "No date"),
          Text("2024-08-09", style: MyAppStyle.regularFont,),
      
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            iconSize: 10,
            onPressed: () {},
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