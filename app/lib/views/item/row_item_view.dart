import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class RowItem extends StatefulWidget {
  const RowItem({
    super.key,
    this.item,
    this.checklistDay,
    // required this.pageDay,
    this.pageDay, //TODO: tech debt, not sure effects of making not required but I did for bandaid
    // required this.unit,
    // required this.desc,
    // required this.result,
  });

  final Item? item;
  final ChecklistDay? checklistDay;
  final DateTime? pageDay;
  // final String unit;
  // final String desc;
  // final String result;

  @override
  State<RowItem> createState() => _RowItemState();
}

class _RowItemState extends State<RowItem> {
  ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();

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
    _unit = ''; //_item.unit ?? "";
    _desc = ''; //_item.desc ?? "";
    _result = ''; //= _item.result ?? "";

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
    _unit = ''; //_item.unit ?? "";
    _desc = '';//_item.desc ?? "";
    _result = '';//_item.result ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      // decoration: BoxDecoration(
      //     border: Border.all(
      //   width: 1,
      // )),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: unitEdit,
              decoration: const InputDecoration(
                // border: InputBorder.none,
                // border: OutlineInputBorder(
                //   borderSide: BorderSide(
                //   width: 1,
                // ),
                //   borderRadius: BorderRadius.all(Radius.circular(8.0)),
                // ),
                hintText: 'Units',
              ),
            )
          ),

          const VerticalDivider(
            thickness: 0.5,
          ),

          Expanded(
            child: TextFormField(
              controller: descEdit,
              decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                // border: InputBorder.none,
                hintText: 'Description'
              ),
            )
          ),

          const VerticalDivider(

          ),

          SizedBox(
            width: 100,
            child: TextFormField(
              // readOnly: true,
              controller: resultEdit,
              decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                // border: InputBorder.none,
                hintText: 'Value'
              ),
            )
          ),
        ],
      ),
    );
  }
}