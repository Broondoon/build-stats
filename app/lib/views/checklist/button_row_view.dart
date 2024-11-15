// View Imports:

import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:flutter/material.dart';

class ButtonRow extends StatefulWidget {
  const ButtonRow({
    super.key,
    required this.editFunct,
    required this.saveFunct,
    required this.commentFunct,
  });

  final Function editFunct;
  final Function saveFunct;
  final VoidCallback commentFunct;

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
        SizedBox(
          width: 100,
          height: 40,
          child: TextButton(
            // style: MyAppStyle.buttonStyle,
            style: TextButton.styleFrom(
              backgroundColor: _editIsPressed ? const Color.fromARGB(255, 227, 227, 227) : Colors.transparent,
            ),
            child: Text(
              "Edit", 
              style: MyAppStyle.regularFont,
            ),
            onPressed: () {

              setState(() {
                _editIsPressed = !_editIsPressed;
              });
            },
          ),
        ),
    
        SizedBox(
          width: 100,
          height: 40,
          child: TextButton(
            // style: MyAppStyle.buttonStyle,
            child: Text("Submit", style: MyAppStyle.regularFont,),
            onPressed: () {

              if (_editIsPressed) {
                setState(() {
                  _editIsPressed = !_editIsPressed;
                });
              }       
            },
          ),
        ),
    
        SizedBox(
          width: 120,
          height: 40,
          child: TextButton(
            // style: MyAppStyle.buttonStyle,
            child: Text("Comments", style: MyAppStyle.regularFont,),
            onPressed: widget.commentFunct,
          ),
        ),
      ],
    );
  }
}