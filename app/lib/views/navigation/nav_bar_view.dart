// View Imports:
import 'package:build_stats_flutter/resources/app_colours.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:flutter/material.dart';

class NavBottomBar extends StatelessWidget {
  const NavBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: MyAppColours.g5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.person),
            iconSize: MyAppStyle.stdButtomSize,
            onPressed: () {},
          ),
    
          IconButton(
            icon: Icon(Icons.home),
            iconSize: MyAppStyle.stdButtomSize,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
    
          IconButton(
            icon: Icon(Icons.settings),
            iconSize: MyAppStyle.stdButtomSize,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}