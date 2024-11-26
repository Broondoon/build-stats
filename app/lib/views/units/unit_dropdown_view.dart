import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/views/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Drop down for selecting units
//the controller handles the change handler for the item so we use that.
class UnitDropdown extends StatefulWidget {
  const UnitDropdown({
    super.key,
    required this.item,
    // required this.controller,
    required this.changedFunction,
    this.hintText,
  });

  final Item item;
  // final TextEditingController controller;
  final Function changedFunction;
  final String? hintText;

  @override
  State<UnitDropdown> createState() => _UnitDropdownState();
}

class _UnitDropdownState extends State<UnitDropdown> {
  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    dropdownValue = widget.item.unitId ?? '';
    return DropdownMenu<String>(
      initialSelection: widget.item.unitId ?? '',
      // controller: widget.controller,
      hintText: widget.hintText,
      onSelected: (String? value) {
        if (value == widget.item.unitId) return;
        print('NEW ITEM ID: $value');
        widget.item.unitId = value;
        setState(() {
          dropdownValue = value!;
        });

        widget.changedFunction();
      },
      //can probably make this a thing somewhere else, and only call it once. But this isolates it from other front end stuff for now.
      dropdownMenuEntries:
          Provider.of<MyAppState>(context, listen: false).getUnits().entries.map<DropdownMenuEntry<String>>((entry) {
        return DropdownMenuEntry<String>(value: entry.key, label: entry.value);
      }).toList(),
    );
  }
}
