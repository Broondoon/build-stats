import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class RowItem extends StatefulWidget {
  const RowItem({
    super.key,
    required this.item,
    required this.checklistDay,
    required this.pageDay,
  });

  final Item item;
  final ChecklistDay checklistDay;
  final DateTime pageDay;

  @override
  State<RowItem> createState() => _RowItemState();
}

class _RowItemState extends State<RowItem> {
  ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();

  late Item _item;
  late String _unit;
  late String _desc;
  late String _result;

  TextEditingController unitEdit = TextEditingController();
  TextEditingController descEdit = TextEditingController();
  TextEditingController resultEdit = TextEditingController();

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _unit = _item.unitId ?? '';
    _desc = _item.desc ?? '';
    _result = _item.result ?? '';

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
    print('HELLO WE ARE UPDATING ITEM');
    _item = await changeManager.updateItem(
        _item, widget.checklistDay, widget.pageDay);
    _unit = _item.unitId ?? '';
    _desc = _item.desc ?? '';
    _result = _item.result ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              )),
          const VerticalDivider(
            thickness: 0.5,
          ),
          Expanded(
              child: TextFormField(
            controller: descEdit,
            decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                // border: InputBorder.none,
                hintText: 'Description'),
          )),
          const VerticalDivider(),
          SizedBox(
              width: 100,
              child: TextFormField(
                // readOnly: true,
                controller: resultEdit,
                decoration: const InputDecoration(
                    // border: OutlineInputBorder(),
                    // border: InputBorder.none,
                    hintText: 'Value'),
              )),
        ],
      ),
    );
  }
}
