import 'dart:collection';

import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/entity/unit.dart';
import 'package:build_stats_flutter/model/entity/user.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/storage/data_sync/data_sync.dart';
import 'package:build_stats_flutter/model/storage/Export/to_CSV.dart';
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

  ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();
  Worksite? currWorksite;
  Checklist? currChecklist;
  ChecklistDay? currChecklistDay;
  List<String>? currItemsIdsByCat = [];
  DateTime pageDay = DateTime.now();
  late DateTime startDay = pageDay;
  late HashMap<String, String> units = HashMap<String, String>();
  bool dataSyncing = false; //just a quick flag to ensure we only start the data sync once.
  bool localDataLoaded = false; //just a quick flag to ensure we only load Local Data Once.
  // OverlayEntry? _overlayEntry; //TODO: is this needed?

  // This is a micro getter function???
  // DateTime get padeDay => _pageDay; 

  Future<void> loadEverything() async {
    // If we haven't started data syncing yet, start it now. Load Everything might be called after this again, so ensure we only do this once.
    if(!dataSyncing){
      Injector.appInstance.get<DataSync>().startDataSyncTimer();// Start the data sync timer so we can keep the app synced to the Server.
      dataSyncing = true;
    }

    if(!localDataLoaded){
      await changeManager.loadLocalData();// Load the local data, so we can get the app up and running.
      localDataLoaded = true;
    }

    // ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();
    setUnits( await changeManager.getCompanyUnits(currUser) ?? []);


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

  Future<List<String>> loadItemsFromCat(String catName) async {
    // currItemsIdsByCat = await changeManager.get

    // TODO: see if this is totally catastrophic
    await loadEverything();

    return changeManager.getChecklistDayCategoryItems(currChecklistDay!, catName);
  }

  Future<List<Worksite>> loadUserWorksites() async {
    return await changeManager.getUserWorksites(currUser) ?? [];
  }

  Future<void> saveAllChanges() async {
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

  Future<void> saveNewWorksite(
    workname,
    newIntId,
    newContractor,
    newpeople,
  ) async {
    ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();

    Worksite newWorksite = await changeManager.createWorksite(
      currUser,
    );

    // TODO: Bug Kyle to add these params to backend
    newWorksite.name = workname;
    // newWorksite.intId = newIntId;
    // newWorksite.people = newpeople;

    newWorksite = await changeManager.updateWorksite(
      newWorksite
    );
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
  //kyle: I can probably just throw an exception that you can catch. Not hard. Whats a bigger issue is that we don't upd
  Future<void> addNewCat(String newCatTitle) async {
    ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();

    print('ADDING NEW CAT $newCatTitle');
    await changeManager.addCategory(currChecklistDay!, newCatTitle);
    

    notifyListeners();   
  }

  Future<Item> updateItem(Item changedItem) async {
    ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();

    Item returnItem = await changeManager.updateItem(changedItem, currChecklistDay!, pageDay );

    await flicker();

    return returnItem;
  }

  Future<void> flicker() async {
    await loadEverything();
  }

  //Units are a bit of a pain, as they arn't gathered like everything else, meaning that the caches can't actually detect if they're out of date unless it's done during data sync. 
  //so we need methods to set and get them from the app state.
  //additionally, since they won't change most of the time, we don't want to keep grabbinbg them from the cache, as that requires using a lot of async code, which means rebuilding a bunch of other crap
  //so instead we set them here, and then update them via the data sync when neccessary.
  //If someone else can find a better way to do this, I'm all ears.
  HashMap<String, String> getUnits() {
    return units;
  }

  void setUnits(List<Unit> newUnits) {
    HashMap<String, String> unitIdPairs = HashMap<String, String>.fromIterable(
        newUnits,
        key: (e) => e.id,
        value: (e) => e.name);
    unitIdPairs.addEntries([
      const MapEntry("", ""),
    ]);
    units = unitIdPairs;
    notifyListeners();
  }

  void exportWorksite() => ToCSV.WorksiteToCSV(currUser, currWorksite!.id);
}