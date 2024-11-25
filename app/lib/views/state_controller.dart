import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/entity/user.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:shared/app_strings.dart';

class MyAppState extends ChangeNotifier {
  User currUser = User(
        id: '${ID_UserPrefix}1',
        companyId: '${ID_CompanyPrefix}1',
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
  );

  Worksite? currWorksite;
  Checklist? currChecklist;
  ChecklistDay? currChecklistDay;
  List<String>? currItemsIdsByCat = [];
  DateTime pageDay = DateTime.now();
  late DateTime startDay = pageDay;
  // OverlayEntry? _overlayEntry; //TODO: is this needed?

  // This is a micro getter function???
  // DateTime get padeDay => _pageDay; 

  Future<void> loadEverything() async {
    ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();

    List<Worksite> userWorksites = await changeManager.getUserWorksites(currUser) ?? [];

    if (userWorksites.isEmpty) {
      currWorksite = await changeManager.createWorksite(currUser);
    }
    else {
      // TODO: actually load the right one
      // But for now, just load the first one
      currWorksite = userWorksites.first;
    }

    List<String> checklistIds = currWorksite!.checklistIds ?? [];

    if (checklistIds.isEmpty) {
      currChecklist = await changeManager.createChecklist(currWorksite!);
    }
    else {
      currChecklist = await changeManager.getChecklistById(checklistIds.first);
    }

    currChecklistDay = await changeManager.GetChecklistDayByDate(pageDay, currChecklist!);

    notifyListeners();
  }

  Future<void> saveChanges() async {
    ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();

    // Save when you've added checklistIds to this day
    currChecklistDay = await changeManager.updateChecklistDay(
      currChecklistDay!, 
      currChecklistDay!.date,
    );

    currChecklist = await changeManager.updateChecklist(currChecklist!);

    // changeManager.updateItem(item, currChecklistDay!, pageDay);

    changeManager.updateWorksite(currWorksite!);

    notifyListeners();
  }

  void setPageDay(DateTime newDay) {
    pageDay = newDay;
    notifyListeners();
  }

  void changePageDay(bool increment) {
    if (increment) {
      pageDay = pageDay.add(const Duration(days: 1));
    }
    else {
      if (pageDay.isAfter(startDay)) {
        pageDay = pageDay.subtract(const Duration(days: 1));
      }
    }

    notifyListeners();
  }

  // OF NOTE: There is no checking for duplicate category titles, which will probably break backend
  // FORBIDDEN TECHNIQUE: OSTRICH BURIES INTO SAND
  Future<void> addNewCat(String newCatTitle) async {
    ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();

    print('ADDING NEW CAT $newCatTitle');
    await changeManager.addCategory(currChecklistDay!, newCatTitle);

    notifyListeners();   
  }

  Future<Item> updateItem(Item changedItem) async {
    ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();

    Item returnItem = await changeManager.updateItem(changedItem, currChecklistDay!, pageDay);

    await flicker();

    return returnItem;
  }

  Future<void> flicker() async {
    await loadEverything();
  }
}