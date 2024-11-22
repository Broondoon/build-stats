import 'package:build_stats_flutter/resources/app_colours.dart';
import 'package:flutter/material.dart';

class MyAppStyle {
  // Fonts
  static const TextStyle regularFont = TextStyle(
      fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal);

  static const TextStyle largeFont =
      TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold);

  static const TextStyle titleFont =
      TextStyle(fontSize: 48, color: Colors.black, fontWeight: FontWeight.bold);

  // Buttons
  static const stdButtomSize = 42.0;

  static ButtonStyle buttonStyle = const ButtonStyle(
    // backgroundColor: WidgetStatePropertyAll<Color>(MyAppColours.g3),
    // backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    //   return states.contains(WidgetState.pressed) ? MyAppColours.g1 : MyAppColours.g6;
    // }),

    // foregroundColor: WidgetStatePropertyAll<Color>(MyAppColours.g6),

    padding: WidgetStatePropertyAll<EdgeInsets>(
      EdgeInsets.fromLTRB(4, 2, 4, 2),
    ),

    shape: WidgetStatePropertyAll<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        side: BorderSide(
          // color: MyAppColours.g1,
          width: 1,
        ),
      ),
    ),
  );
}
