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
            const Spacer(),
            Row(
              children: [
                const Icon(
                  Icons.flag_circle_outlined,
                  color: Color.fromARGB(255, 211, 211, 211),
                ),
                const SizedBox(
                  width: 4,
                ),
                Container (
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Text('12'),
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