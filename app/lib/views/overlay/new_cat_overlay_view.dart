import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/overlay/overlay_interface.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewCat extends StatefulWidget implements OverlayImpInterface {
  const NewCat({
    super.key,
    required this.changeNewCatName
  });

  final Function changeNewCatName;

  // TODO: fix this so that it actually does somthing, because as now it's BROKEN
  @override
  void timeToClose() {
    
  }

  @override
  State<NewCat> createState() => _NewCatState();
}

class _NewCatState extends State<NewCat> { // implements OverlayImpInterface {
  late String catName = '';
  TextEditingController catNameEdit = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    catName = '';
    catNameEdit.addListener(_saveCatChanges);
  }

  void _saveCatChanges() {
    catName = catNameEdit.text;
    widget.changeNewCatName(catName);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // const SizedBox(
        //   width: 200,
        //   height: 40,
        //   // child: Card(
        //     child: Center(
        //       child: Text(
        //         'New Category',
        //         style: MyAppStyle.largeFont,
        //       ),
        //     ),
        //   // ),
        // ),
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            const Text(
              'Name:',
              style: MyAppStyle.regularFont,
            ),
            const SizedBox(
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

        const SizedBox(),
      ],
    );
  }
}