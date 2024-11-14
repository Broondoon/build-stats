// View Imports:

import 'package:build_stats_flutter/views/comments/comment_view.dart';
import 'package:flutter/material.dart';

class BaseOverlay extends StatelessWidget {
  const BaseOverlay({
    super.key,
    required this.closefunct,
    required this.overlay
  });

  final VoidCallback closefunct;
  final Widget overlay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: closefunct,
          child: Container(
            color: Colors.black54,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        
        Positioned( // needed to have overlay from bottom
          bottom: 0,
          child: Material(  // material may or may not be needed EDIT: IT IS VERY MUCH NEEDED
            child: Container(  // ignoring the VS Code suggestion
              width: MediaQuery.of(context).size.width, // * 0.6,
              height: MediaQuery.of(context).size.height * 0.86,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // child: CommentSection(),
                child: Column(
                  children: [
                    Text("New Worksite"),
                    Text("Name:"),
                    Text("Internal ID:"),
                    Text("Contractor:"),
                    Text("Involved Personel:"),
                  ],
                )
              ),
            ),
          ),
        ),
      ],
    );
  }
}