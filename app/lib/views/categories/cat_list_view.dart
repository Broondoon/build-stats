import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/views/categories/cat_row_view.dart';
import 'package:build_stats_flutter/views/overlay/base_overlay_view.dart';
import 'package:build_stats_flutter/views/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({
    super.key,
    // required this.pageday,
    // required this.checklistDay,
  });

  // final DateTime pageday;
  // final ChecklistDay checklistDay;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();
  late List<Widget> _catList;
  late List<String> catTitles;
  OverlayEntry? _catOverlayEntry;

  @override
  void initState() {
    print('CATEGORYLIST STATE INIT');
    super.initState();
    _loadCats();
  }

  Future<void> _loadCats() async {
    _catList = [];
    catTitles = Provider.of<MyAppState>(
      context, 
      listen: false
    ).currChecklistDay!.getCategories();
    
    // widget.checklistDay.getCategories();

    print('LENGTH OF TITLES: ${catTitles.length}');

    setState(() {
      for (String catName in catTitles) {
        print('LOADING CATEGORY $catName');
        if (_catList.isNotEmpty) {
          _catList.add(
            const Divider(
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
            catTitle: catName,
            openOverlayFunct: showOldCatOverlay,
          ),
        );
      }
    });
  }

  void showNewCatOverlay() {
    _catOverlayEntry = OverlayEntry (
      builder: (context) => BaseOverlay.newCat(
        overlayRef: _catOverlayEntry!,
        closefunct: createNewCat,
        // pageday: widget.pageday,
        // checklistDay: widget.checklistDay,
      ),
    );

    Overlay.of(context).insert(_catOverlayEntry!);
  }

  void createNewCat(String newCatTitle) {
    if (newCatTitle.isNotEmpty) {
      addNewCat(newCatTitle);
    }
  }

  void showOldCatOverlay(String catTitle) {
    _catOverlayEntry = OverlayEntry (
      builder: (context) => BaseOverlay.oldCat(
        overlayRef: _catOverlayEntry!,
        closefunct: () {},
        catTitle: catTitle,
        // pageday: widget.pageday,
        // checklistDay: widget.checklistDay,
      ),
    );

    Overlay.of(context).insert(_catOverlayEntry!);
  }

  // OF NOTE: There is no checking for duplicate category titles, which will probably break backend
  // FORBIDDEN TECHNIQUE: OSTRICH BURIES INTO SAND
  Future<void> addNewCat(String newCatTitle) async {

    Provider.of<MyAppState>(
      context, 
      listen: false
    ).addNewCat(newCatTitle);

    // print('ADDING NEW CAT $newCatTitle');
    // await changeManager.addCategory(widget.checklistDay, newCatTitle);

    setState(() {
      if (_catList.isNotEmpty) {
        _catList.add(
          const Divider(
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
              icon: const Icon(Icons.add),
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