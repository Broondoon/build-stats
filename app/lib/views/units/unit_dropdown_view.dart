import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/entity/unit.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

//for item change handler await changeManager.getUnitMap();
class UnitDropdown extends StatefulWidget {
  const UnitDropdown({
    super.key,
    required this.item,
    required this.unitHashMap,
    required this.itemChangeHandler,
  });

  final Item item;
  final Map<String, String> unitHashMap;
  final Future<void> Function() itemChangeHandler;

  @override
  State<UnitDropdown> createState() => _UnitDropdownState();
}

class _UnitDropdownState extends State<UnitDropdown> {
  String dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    dropdownValue = widget.item.unitId ?? '';
    return DropdownMenu<String>(
      initialSelection: widget.item.unitId ?? '',
      onSelected: (String? value) {
        if (value == widget.item.unitId) {
          return;
        }
        // This is called when the user selects an item.
        widget.item.unitId = value;
        // await widget.itemChangeHandler();
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries:
          widget.unitHashMap.entries.map<DropdownMenuEntry<String>>((entry) {
        return DropdownMenuEntry<String>(value: entry.key, label: entry.value);
      }).toList(),
    );
  }
}
