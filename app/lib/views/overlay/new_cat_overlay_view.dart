// View Imports:

import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:flutter/material.dart';

class NewCat extends StatefulWidget {
  const NewCat({
    super.key,
  });

  @override
  State<NewCat> createState() => _NewCatState();
}

class _NewCatState extends State<NewCat> {
  
  late String catName = "";
  TextEditingController catNameEdit = TextEditingController();

  @override
  void initState() {
    catName = "";
    catNameEdit.addListener(_saveCatChanges);
  }

  void _saveCatChanges() {
    catName = catNameEdit.text;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(),

        SizedBox(
          width: 200,
          height: 40,
          // child: Card(
            child: Center(
              child: Text(
                "New Category",
                style: MyAppStyle.largeFont,
              ),
            ),
          // ),
        ),
        SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            Text(
              "Name:",
              style: MyAppStyle.regularFont,
            ),
            SizedBox(
              width: 5,
            ),
            SizedBox(
              height: 40,
              width: 150,
              child: TextFormField(
                controller: catNameEdit,
                style: MyAppStyle.regularFont,
                // textAlign: TextAlign.center, // This centeres horizontally :(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // border: InputBorder.none,
                  hintText: '',
                  // contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),

        SizedBox(),
      ],
    );
  }
}