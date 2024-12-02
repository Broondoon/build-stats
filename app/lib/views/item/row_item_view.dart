import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/views/state_controller.dart';
import 'package:build_stats_flutter/views/units/unit_dropdown_view.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:provider/provider.dart';

class RowItem extends StatefulWidget {
  const RowItem({
    super.key,
    required this.item,
    // required this.checklistDay,
    // required this.pageDay,
  });

  final Item item;
  // final ChecklistDay checklistDay;
  // final DateTime pageDay;

  @override
  State<RowItem> createState() => _RowItemState();
}

class _RowItemState extends State<RowItem> {
  ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();

  late Item _item;
  late String _unit;
  late String _desc;
  late String _result;

  // TextEditingController unitEdit = TextEditingController();
  TextEditingController descEdit = TextEditingController();
  TextEditingController resultEdit = TextEditingController();
  FocusNode descEditFocusNode = FocusNode();
  FocusNode resultEditFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _unit = _item.unitId ?? '';
    _desc = _item.desc ?? '';
    _result = _item.result ?? '';

    // unitEdit.text = _unit;
    descEdit.text = _desc;
    resultEdit.text = _result;


    // unitEdit.addListener(_onTextChanged);
    //descEdit.addListener(_onTextChanged);
    //resultEdit.addListener(_onTextChanged);
    descEditFocusNode.addListener(_handleFocusChange);
    resultEditFocusNode.addListener(_handleFocusChange);
  }

  // void unitChanged(String newUnit) {
  //   print('DO THEY MATCH? ${_item.unitId} VS $newUnit');
    // Author's note: yes they did
    // _unit = newUnit;
  // }

  // // TODO: Test if we can
  // void _onTextChanged() {
  //   // _item.unitId
  //   if(_item.desc == descEdit.text && _item.result == resultEdit.text) {
  //     return;
  //   }
  //   _item.desc = descEdit.text;
  //   _item.result = resultEdit.text;
  //   _saveItemChanges();
  // }

   // TODO: Test if we can
  void _handleFocusChange() {
    // _item.unitId
    if(_item.desc == descEdit.text && _item.result == resultEdit.text) {
      return;
    }
    _item.desc = descEdit.text;
    _item.result = resultEdit.text;
    _saveItemChanges();
  }

  Future<void> _saveItemChanges() async {
    print('HELLO WE ARE UPDATING ITEM');

    // ChecklistDay currChecklistDay = Provider.of<MyAppState>(
    //   context, 
    //   listen: false
    // ).currChecklistDay!;

    // DateTime pageday = Provider.of<MyAppState>(
    //   context, 
    //   listen: false
    // ).pageDay;

    // _item = await changeManager.updateItem(_item, _currChecklistDay, _pageday);
    _item = await Provider.of<MyAppState>(
      context, 
      listen: false
    ).updateItem(_item);
    
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
              width: 125,
              child: UnitDropdown(
                item: _item, 
                changedFunction: _saveItemChanges, 
                hintText: 'Units'
              ),
              
              // TextFormField(
              //   controller: unitEdit,
              //   decoration: const InputDecoration(
              //     // border: InputBorder.none,
              //     // border: OutlineInputBorder(
              //     //   borderSide: BorderSide(
              //     //   width: 1,
              //     // ),
              //     //   borderRadius: BorderRadius.all(Radius.circular(8.0)),
              //     // ),
              //     hintText: 'Units',
              //   ),
              // )
            ),
          const VerticalDivider(
            thickness: 0.5,
          ),
          Expanded(
              child: TextFormField(
            controller: descEdit,
            focusNode: descEditFocusNode,
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
                focusNode: resultEditFocusNode,
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
