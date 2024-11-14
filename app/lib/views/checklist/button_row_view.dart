// View Imports:

import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:flutter/material.dart';

class ButtonRow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 40,
          child: TextButton(
            // style: MyAppStyle.buttonStyle,
            child: Text("Edit", style: MyAppStyle.regularFont,),
            onPressed: () {},
          ),
        ),
    
        SizedBox(
          width: 100,
          height: 40,
          child: TextButton(
            // style: MyAppStyle.buttonStyle,
            child: Text("Submit", style: MyAppStyle.regularFont,),
            onPressed: () {},
          ),
        ),
    
        SizedBox(
          width: 120,
          height: 40,
          child: TextButton(
            // style: MyAppStyle.buttonStyle,
            child: Text("Comments", style: MyAppStyle.regularFont,),
            onPressed: commentFunct,
          ),
        ),
      ],
    );
  }
}