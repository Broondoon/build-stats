// View Imports:
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:build_stats_flutter/views/comments/comment_view.dart';
import 'package:build_stats_flutter/views/overlay/new_cat_overlay_view.dart';
import 'package:build_stats_flutter/views/overlay/new_worksite_overlay_view.dart';
import 'package:build_stats_flutter/views/overlay/old_cat_overlay_view.dart';
import 'package:build_stats_flutter/views/overlay/overlay_interface.dart';
import 'package:flutter/material.dart';

class BaseOverlay extends StatelessWidget {
  const BaseOverlay({
    super.key,
    required this.overlayRef,
    required this.choice,
    required this.closefunct,
    this.comments = "",
  });

  final OverlayEntry overlayRef;
  final overlayChoice choice; 
  final VoidCallback closefunct;
  final String comments;
  // final OverlayImpInterface overlay = getOverlay(choice);

  // This feels a little silly, and against OOP principles
  // Some kind of inheritance could serve me better, possibly
  // BUT I already made this, and need to move on to other things
  OverlayImpInterface getOverlay(overlayChoice yourChoice) {
    switch (yourChoice) {
      case overlayChoice.comments:
        return CommentSection();
      case overlayChoice.newcategory:
        return NewCat();
      case overlayChoice.category:
        return OldCat();
      case overlayChoice.worksite:
        return NewWorksite();
    }
  }

  @override
  Widget build(BuildContext context) {
    OverlayImpInterface overlay = getOverlay(choice);

    return Stack(
      children: [
        GestureDetector(
          // onTap: closefunct, //== _cursedWorkaround ? returnfunct : closefunct,
          onTap: () {
            overlay.timeToClose();
            _removeOverlay();
          },
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
                child: overlay,
                // child: CommentSection(),
                // child: NewWorksite()
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Close the overlay
  void _removeOverlay() {
    closefunct();
    overlayRef.remove();
  } 
}