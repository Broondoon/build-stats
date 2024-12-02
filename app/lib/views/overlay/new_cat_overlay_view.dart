import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/overlay/overlay_interface.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewCat extends StatefulWidget implements OverlayImpInterface {
  const NewCat({
    super.key,
    required this.changeNewCatName,
    required this.removeOverlayFunct,
  });

  final Function changeNewCatName;
  final Function removeOverlayFunct;

  @override
  void timeToClose() {
    
  }

  @override
  State<NewCat> createState() => _NewCatState();
}

class _NewCatState extends State<NewCat> { // implements OverlayImpInterface {
  late String catName = '';
  TextEditingController catNameEdit = TextEditingController();
  bool readyToCreate = false;

  @override
  void initState() {
    super.initState();
    
    catName = '';
    catNameEdit.addListener(_saveCatChanges);
  }

  void _saveCatChanges() {
    catName = catNameEdit.text;

    setState(() {
      if (catName.isNotEmpty) {
        readyToCreate = true;
      }
      else {
        readyToCreate = false;
      }
    });

    widget.changeNewCatName(catName);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Name:',
              style: MyAppStyle.regularFont,
            ),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              height: 40,
              width: 150,
              child: TextFormField(
                controller: catNameEdit,
                style: MyAppStyle.regularFont,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '',
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              side: BorderSide(
                width: 1,
                color: readyToCreate
                  ? Colors.black
                  : const Color.fromARGB(255, 202, 202, 202),
              ),
            ),
          ),
          onPressed: () {
            widget.removeOverlayFunct();
          },
          child: Text(
            'Create Worksite',
            style: TextStyle(
              fontSize: 18,
              color: readyToCreate
                ? Colors.black
                : const Color.fromARGB(255, 202, 202, 202),
            )
          ),
        ),
      ],
    );
  }
}