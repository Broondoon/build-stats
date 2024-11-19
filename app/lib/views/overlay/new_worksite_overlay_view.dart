// View Imports:

import 'package:build_stats_flutter/views/overlay/overlay_interface.dart';
import 'package:flutter/material.dart';

class NewWorksite extends StatefulWidget implements OverlayImpInterface {
  const NewWorksite({
    super.key,
  });

  @override
  void timeToClose() {
    // ...suposedly implemented by the State class?
    print("STATED POORLY");
  }

  @override
  State<NewWorksite> createState() => _NewWorksiteState();
}

class _NewWorksiteState extends State<NewWorksite> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("New Worksite"),
        Text("Name:"),
        Text("Internal ID:"),
        Text("Contractor:"),
        Text("Involved Personel:"),
      ],
    );
  }
}