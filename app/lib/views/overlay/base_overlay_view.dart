// View Imports:
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:build_stats_flutter/views/comments/comment_view.dart';
import 'package:build_stats_flutter/views/overlay/new_cat_overlay_view.dart';
import 'package:build_stats_flutter/views/overlay/new_worksite_overlay_view.dart';
import 'package:build_stats_flutter/views/overlay/old_cat_overlay_view.dart';
import 'package:build_stats_flutter/views/overlay/overlay_interface.dart';
import 'package:build_stats_flutter/views/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:build_stats_flutter/resources/app_style.dart';

// A key failure of this BaseOverlay system is the
// need for certain params which don't get used.
// But hey, this is my first time working with
// null-checking built into the language
// and I've got things to do!
// ...
// Actually this constant null-checking is the biggest flaw in this entire codebase
// I didn't expect it to become such a big thing, but as the system grows it turns out
// that I don't really know how to integrate it into broader system design.
// Probably should have researched it / watched a few videos...
class BaseOverlay extends StatefulWidget {
  const BaseOverlay({
    // Not sure the diff between in and out
    super.key,
    required this.overlayRef,
    required this.choice,
    required this.closefunct,
    this.comments,
    this.catTitle,
    // this.pageday,
    // this.checklistDay,
  });

  final OverlayEntry overlayRef;
  final overlayChoice choice; 
  final Function closefunct;
  final String? comments;
  final String? catTitle;

  // final DateTime? pageday;
  // final ChecklistDay? checklistDay;

  // This article has been very helpful in setting up a proper factory
  // https://medium.com/@ximya/modularizing-flutter-ui-with-factory-constructors-f13907b6f5d4

  factory BaseOverlay.oldCat({
    required OverlayEntry overlayRef,
    required Function closefunct,
    String? comments,
    required String catTitle,
    // required DateTime pageday,
    // required ChecklistDay checklistDay,
  }) =>
    BaseOverlay(
      overlayRef: overlayRef,
      choice: overlayChoice.category,
      closefunct: closefunct,
      catTitle: catTitle,
      // pageday: pageday,
      // checklistDay: checklistDay,
    );

  factory BaseOverlay.newCat({
    required OverlayEntry overlayRef,
    required Function closefunct,
    String? comments,
    String? catTitle,
    // DateTime? pageday,
    // ChecklistDay? checklistDay,
  }) =>
    BaseOverlay(
      overlayRef: overlayRef,
      choice: overlayChoice.newcategory,
      closefunct: closefunct,
    );

  factory BaseOverlay.comment({
    required OverlayEntry overlayRef,
    required Function closefunct,
    required String comments,
    String? catTitle,
    // DateTime? pageday,
    // ChecklistDay? checklistDay,
  }) =>
    BaseOverlay(
      overlayRef: overlayRef,
      choice: overlayChoice.comments,
      closefunct: closefunct,
      comments: comments,
    );

  @override
  State<BaseOverlay> createState() => _BaseOverlayState();
}

class _BaseOverlayState extends State<BaseOverlay> {
  
  late String overlayTitle;

  @override
  void initState() {
    super.initState();
    overlayTitle = getOverlayTitle();
  }

  // TODO: How do we avoid this?
  // New Category overlay:
  String newCatName = '';

  //New worksite overlay:
  bool minimumReqsToSave = false;
  String workname = '';
  String intID = '';
  String contractor = '';
  List<(String, String)> people = [];
  

  void changeNewCatName(String newName) {
    newCatName = newName;
  }

  void changeWorksiteInfo(
    bool reqsSatisfied,
    String newWorkname, 
    String newIntId, 
    String newContractor,
    List<(String, String)> newpeople,
  ) {
    minimumReqsToSave = reqsSatisfied; // This is particularly heinous naming convention
    workname = newWorkname;
    intID = newIntId;
    contractor = newContractor;
    people = newpeople;
  }

  // This feels a little silly, and against OOP principles
  OverlayImpInterface getOverlay(overlayChoice yourChoice) {
    switch (yourChoice) {
      case overlayChoice.comments:
        return CommentSection();
      case overlayChoice.newcategory:
        return NewCat(
          changeNewCatName: changeNewCatName,
        );
      case overlayChoice.category:
        return OldCat(
          catTitle: widget.catTitle!,
          // catIds: ids,
          // pageDay: widget.pageday!,
          // checklistDay: widget.checklistDay!,
        );
      case overlayChoice.worksite:
        return NewWorksite(
          changeInfoFunct: changeWorksiteInfo,
          removeOverlayFunct: _removeOverlay,
        );
    }
  }

  // Doing this as a function because I'm too tired to refactor everyone that calls baseoverlay
  String getOverlayTitle() {
    switch (widget.choice) {
      case overlayChoice.comments:
        return 'Comments';
      case overlayChoice.newcategory:
        return 'New Category';
      case overlayChoice.category:
        return widget.catTitle!;
      case overlayChoice.worksite:
        return 'New Worksite';
    }
  }

  @override
  Widget build(BuildContext context) {
    OverlayImpInterface overlay = getOverlay(widget.choice);
    
    return Stack(
      children: [
        GestureDetector(
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
            child: SizedBox(  // ignoring the VS Code suggestion
              width: MediaQuery.of(context).size.width, // * 0.6,
              height: MediaQuery.of(context).size.height * 0.86,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // child: overlay,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          overlayTitle,
                          style: MyAppStyle.largeFont,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: justCloseOverlay,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    Flexible(
                      child: overlay
                    ),
                  ],
                ),
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
    if (widget.choice == overlayChoice.newcategory) {
      widget.closefunct(newCatName);
    }
    else if (widget.choice == overlayChoice.worksite) {
      print('CLOSING NEW WORKSITE OVERLAY');
      if (minimumReqsToSave) {
        print('SAVING NEW WORKSITE BECAUSE FORMS FILLED');
        widget.closefunct(
          workname,
          intID,
          contractor,
          people,
        );
      }
    }
    else {
      widget.closefunct();
    }

    widget.overlayRef.remove();
  }

  void justCloseOverlay() {
    widget.overlayRef.remove();
  }
}