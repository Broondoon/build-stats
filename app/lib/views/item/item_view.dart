import 'package:flutter/material.dart';

class RowItem extends StatelessWidget {
  const RowItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(
        // color: Colors.blueAccent,
        width: 1,
      )),
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: TextFormField(
                decoration: const InputDecoration(
                    // border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: 'Units'),
              )),

          // SizedBox(width: 10),
          VerticalDivider(),
          // SizedBox(width: 25),

          Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                border: InputBorder.none,
                hintText: 'Description'),
          )),

          // SizedBox(width: 25),
          VerticalDivider(),
          // SizedBox(width: 25),

          SizedBox(
              width: 100,
              child: TextFormField(
                // readOnly: true,
                decoration: const InputDecoration(
                    // border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: 'Value'),
              )),
        ],
      ),
    );
  }
}