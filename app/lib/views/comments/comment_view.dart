// View Imports:

import 'package:build_stats_flutter/resources/app_colours.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/overlay/overlay_interface.dart';
import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget implements OverlayImpInterface {
  const CommentSection({
    super.key,
  });

  @override
  void timeToClose() {
    // ...suposedly implemented by the State class?
    print("STATED POORLY");
  }

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.,
      children: [
        Container(
          color: MyAppColours.g4,
          child: SizedBox(
            height: 40,
            child: Center(
              child: Text(
                "Comments",
                style: MyAppStyle.regularFont,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: MyAppColours.g5,
                width: 2.0,
              )
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
              // TODO: REFACTOR FOR LOADING AND CODE MANIPULATION OF TEXT CONTENT
              child: TextField(
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Start writing something..."
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
