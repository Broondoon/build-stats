import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:flutter/material.dart';

class RowItem extends StatefulWidget {
  const RowItem({
    super.key,
    this.item,
    required this.changeManager,
    this.checklistDay,
    // required this.pageDay,
    this.pageDay, //TODO: tech debt, not sure effects of making not required but I did for bandaid
    // required this.unit,
    // required this.desc,
    // required this.result,
  });

  final Item? item;
  final ChangeManager changeManager;
  final ChecklistDay? checklistDay;
  final DateTime? pageDay;
  // final String unit;
  // final String desc;
  // final String result;

  @override
  State<RowItem> createState() => _RowItemState();
}

class _RowItemState extends State<RowItem> {
  // Item? _item;
  late String _unit;
  late String _desc;
  late String _result;

  TextEditingController unitEdit = TextEditingController();
  TextEditingController descEdit = TextEditingController();
  TextEditingController resultEdit = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _item = widget.item;
    _unit = ""; //_item.unit ?? "";
    _desc = ""; //_item.desc ?? "";
    _result = ""; //= _item.result ?? "";

    unitEdit.text = _unit;
    descEdit.text = _desc;
    resultEdit.text = _result;

    unitEdit.addListener(_onTextChanged);
    descEdit.addListener(_onTextChanged);
    resultEdit.addListener(_onTextChanged);
  }

  // TODO: Test if we can 
  void _onTextChanged() {
    _saveItemChanges();
  }

  Future<void> _saveItemChanges() async {
    // _item = await widget.changeManager.updateItem(_item, widget.checklistDay, widget.pageDay);
    _unit = ""; //_item.unit ?? "";
    _desc = "";//_item.desc ?? "";
    _result = "";//_item.result ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(
        // color: Colors.blueAccent,
        width: 1,
      )),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: unitEdit,
              decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                border: InputBorder.none,
                hintText: 'Units',
              ),
            )
          ),

          // SizedBox(width: 10),
          VerticalDivider(),
          // SizedBox(width: 25),

          Expanded(
            child: TextFormField(
              controller: descEdit,
              decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                border: InputBorder.none,
                hintText: 'Description'
              ),
            )
          ),

          // SizedBox(width: 25),
          VerticalDivider(),
          // SizedBox(width: 25),

          SizedBox(
            width: 100,
            child: TextFormField(
              // readOnly: true,
              controller: resultEdit,
              decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                border: InputBorder.none,
                hintText: 'Value'
              ),
            )
          ),
        ],
      ),
    );
  }
}