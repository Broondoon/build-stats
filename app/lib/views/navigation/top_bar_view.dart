// View Imports:

import 'package:build_stats_flutter/resources/app_colours.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarText;
  final bool isWorksite;
  
  const TopBar({
    super.key,
    required this.appBarText,
    required this.isWorksite,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(appBarText, style: MyAppStyle.largeFont),
      automaticallyImplyLeading: false, // <--- Uncomment this to remove app bar back button
      // See: https://stackoverflow.com/questions/44978216/flutter-remove-back-button-on-appbar
      backgroundColor: MyAppColours.g4,
      actions: isWorksite 
        ? [
          Padding(
            // Weird thing but the actions text was 1 pixel lower than the title.
            padding: const EdgeInsets.fromLTRB(0, 0, 16.0, 1.0), //EdgeInsets.only(right: 8.0),
            child: Text(
              // TODO: THIS NEEDS TO BE DYNAMIC
              "Start Date: 2024-08-09",
              style: MyAppStyle.largeFont,
            ),
          ),
        ]
        : null,
    );
  }

  // This is needed in order to implement a PreferredSizeWidget
  // See here for more: https://stackoverflow.com/questions/52678469/the-appbardesign-cant-be-assigned-to-the-parameter-type-preferredsizewidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}