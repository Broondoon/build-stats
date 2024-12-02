// View Imports:

import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:flutter/material.dart';

class ButtonRow extends StatefulWidget {
  const ButtonRow({
    super.key,
    required this.editFunct,
    required this.saveFunct,
    required this.commentFunct,
    required this.exportFunct,
  });

  final Function editFunct;
  final Function saveFunct;
  final VoidCallback commentFunct;
  final Function exportFunct;

  @override
  State<ButtonRow> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  bool _editIsPressed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(
        //   width: 100,
        //   height: 40,
        //   child: TextButton(
        //     // style: MyAppStyle.buttonStyle,
        //     style: TextButton.styleFrom(
        //       backgroundColor: _editIsPressed
        //           ? const Color.fromARGB(255, 227, 227, 227)
        //           : Colors.transparent,
        //       padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
        //       shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //         side: BorderSide(
        //           width: 1,
        //         ),
        //       ),
        //     ),
        //     onPressed: () {
        //       setState(() {
        //         _editIsPressed = !_editIsPressed;
        //       });
        //     },
        //     child: const Text(
        //       'Edit',
        //       style: MyAppStyle.regularFont,
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   width: 8,
        // ),
        SizedBox(
          width: 120,
          height: 40,
          child: TextButton(
            style: MyAppStyle.buttonStyle,
            onPressed: () {
              if (_editIsPressed) {
                setState(() {
                  _editIsPressed = !_editIsPressed;
                });
              }
            },
            child: const Text(
              'Submit',
              style: MyAppStyle.regularFont,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          width: 120,
          height: 40,
          child: TextButton(
            style: MyAppStyle.buttonStyle,
            onPressed: widget.commentFunct,
            child: const Text(
              'Comments',
              style: MyAppStyle.regularFont,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          width: 120,
          height: 40,
          child: TextButton(
            style: MyAppStyle.buttonStyle,
            onPressed: () {},
            child: const Text(
              'Export',
              style: MyAppStyle.regularFont,
            ),
          ),
        ),
      ],
    );
  }
}