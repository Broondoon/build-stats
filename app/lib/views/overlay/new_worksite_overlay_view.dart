// View Imports:

import 'package:flutter/material.dart';

class NewWorksite extends StatelessWidget {
  const NewWorksite({
    super.key,
  });

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