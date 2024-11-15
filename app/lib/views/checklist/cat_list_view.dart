// View Imports:

// import 'package:build_stats_flutter/main.dart';
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/checklist/cat_view.dart';
import 'package:build_stats_flutter/views/overlay/base_overlay_view.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({
    super.key,
  });

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  late List<Widget> _catList;
  late List<String> catTitles;

  OverlayEntry? _catOverlayEntry;

  @override
  // TODO: declare this as async
  void initState() {
    super.initState();
    _loadCats();
  }

  Future<void> _loadCats() async {
    _catList = [];
    catTitles = [];
    //TODO: load from memory
  }

  void showNewCatOverlay() {
    _catOverlayEntry = OverlayEntry (
      builder: (context) => BaseOverlay(
        closefunct: _removeNewCatOverlay,
        // returnfunct: _removeOverlay,
        choice: overlayChoice.newcategory,
      ),
    );

    Overlay.of(context).insert(_catOverlayEntry!);
  }

  // TODO: I WANT THE OVERLAY TO GIVE ME INFO?
  // THERE ARE OTHER WAYS THAN CURSED FUNCTION JUGGLING I KNOW IT
  void _removeNewCatOverlay() {//String newCatTitle){
    _catOverlayEntry?.remove();
    addCat("Labour");
  }

  void showOldCatOverlay() {
    _catOverlayEntry = OverlayEntry (
      builder: (context) => BaseOverlay(
        closefunct: _removeOldCatOverlay,
        // returnfunct: _removeOverlay,
        choice: overlayChoice.category,
      ),
    );

    Overlay.of(context).insert(_catOverlayEntry!);
  }

  void _removeOldCatOverlay() {//String newCatTitle){
    _catOverlayEntry?.remove();
    // addCat(newCatTitle);
  }

  // @override
  void addCat(String newCatTitle){
    // TODO: actually have input from overlay
    // String newCatTitle = "";

    setState(() {
      if (_catList.isNotEmpty) {
        _catList.add(
          Divider(
            color: Colors.grey,
            thickness: 0.25,
            indent: 8,
            endIndent: 8,
            // 8 indent matches padding on CatRow
          ),
        );
      }

      _catList.add(
        CatRow(
          catTitle: newCatTitle,
          openOverlayFunct: showOldCatOverlay,
        ),
      );

      catTitles.add(newCatTitle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        // child: OldCategoryView(changeManager: changeManager, pageDay: pageDay),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _catList.length,
                itemBuilder: (context, index) {
                  return _catList[index];
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // addCat("Hi");
                showNewCatOverlay();
              },
            )
          ],
        )
      ),
    );
  }
}