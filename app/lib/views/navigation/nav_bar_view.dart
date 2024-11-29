// View Imports:
import 'package:build_stats_flutter/resources/app_colours.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/overlay/base_overlay_view.dart';
import 'package:flutter/material.dart';

class NavBottomBar extends StatefulWidget {
  const NavBottomBar({
    super.key,
  });

  @override
  State<NavBottomBar> createState() => _NavBottomBarState();
}

class _NavBottomBarState extends State<NavBottomBar> {
  OverlayEntry? _overlayEntry;

  void _showContactsOverlay(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => BaseOverlay.contacts(
        overlayRef: _overlayEntry!,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _showProjInfoOverlay(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => BaseOverlay.projinfo(
        overlayRef: _overlayEntry!,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: MyAppColours.g5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.person),
            iconSize: MyAppStyle.stdButtomSize,
            onPressed: () {
              _showContactsOverlay(context);
            },
          ),
    
          IconButton(
            icon: const Icon(Icons.home),
            iconSize: MyAppStyle.stdButtomSize,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
    
          IconButton(
            icon: const Icon(Icons.settings),
            iconSize: MyAppStyle.stdButtomSize,
            onPressed: () {
              _showProjInfoOverlay(context);
            },
          ),
        ],
      ),
    );
  }
}