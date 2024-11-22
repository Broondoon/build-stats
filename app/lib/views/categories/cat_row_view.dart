// View Imports:

import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:flutter/material.dart';

class CatRow extends StatefulWidget {
  const CatRow({
    super.key,
    required this.catTitle,
    required this.openOverlayFunct,
  });

  final String catTitle;
  final Function openOverlayFunct;

  @override
  State<CatRow> createState() => _CatRowState();
}

class _CatRowState extends State<CatRow> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.openOverlayFunct(widget.catTitle);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.catTitle,
              style: MyAppStyle.regularFont,
            ),
            // SizedBox(
            //   width: 200,
            // ),
            Spacer(),
            Row(
              children: [
                Icon(
                  Icons.flag_circle_outlined,
                  color: const Color.fromARGB(255, 211, 211, 211),
                ),
                SizedBox(
                  width: 4,
                ),
                Container (
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text("12"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}