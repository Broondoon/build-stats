// View Imports:
import 'package:build_stats_flutter/resources/app_colours.dart';
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  // final String appBarText;
  // final DateTime? worksiteDate;
  final topBarChoice whichAppBar;
  
  const TopBar({
    super.key,
    // required this.appBarText,
    // required this.worksiteDate,
    required this.whichAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAppState>(
      builder: (
        context, 
        appState, 
        child,
      ) {
        return AppBar(
          title: Text(
            whichAppBar == topBarChoice.worksitelist
              ? 'Worksites'
              // : appState.currWorksite., 
              : 'Worksite 1', // TODO: Bug Kyle to add .name to worksite constructor
            style: MyAppStyle.largeFont
          ),
          automaticallyImplyLeading: false, // <--- Uncomment this to remove app bar back button
          // See: https://stackoverflow.com/questions/44978216/flutter-remove-back-button-on-appbar
          backgroundColor: MyAppColours.g4,
          actions: whichAppBar == topBarChoice.checklist
            ? [
              Padding(
                // Weird thing but the actions text was 1 pixel lower than the title.
                padding: const EdgeInsets.fromLTRB(0, 0, 16.0, 1.0), //EdgeInsets.only(right: 8.0),
                child: Text(
                  'Start Date: ${appState.startDay.year}-${appState.startDay.month}-${appState.startDay.day}',
                  style: MyAppStyle.largeFont,
                ),
              ),
            ]
            : null,
          );
      },
    );
  }

  // This is needed in order to implement a PreferredSizeWidget
  // See here for more: https://stackoverflow.com/questions/52678469/the-appbardesign-cant-be-assigned-to-the-parameter-type-preferredsizewidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}