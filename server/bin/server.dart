// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'package:Server/entity/checklist.dart';
import 'package:Server/entity/item.dart';
import 'package:Server/entity/unit.dart';
import 'package:Server/entity/worksite.dart';
import 'package:Server/handlers/checklistDay_handler.dart';
import 'package:Server/handlers/checklist_handler.dart';
import 'package:Server/handlers/data_sync_handler.dart';
import 'package:Server/handlers/item_handler.dart';
import 'package:Server/handlers/unit_handler.dart';
import 'package:Server/handlers/worksite_handler.dart';
import 'package:Server/storage/checklist_cache.dart';
import 'package:Server/storage/item_cache.dart';
import 'package:Server/storage/unit_cache.dart';
import 'package:Server/storage/worksite_cache.dart';
import 'package:injector/injector.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/cache.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

Future<void> main() async {
  final injector = Injector.appInstance;
  injector
      .registerSingleton<LocalStorage>(() => LocalStorage(ReadWriteMutex()));
  injector.registerDependency<WorksiteFactory>(() => WorksiteFactory());
  injector.registerDependency<ChecklistFactory>(() => ChecklistFactory());
  injector.registerDependency<ChecklistDayFactory>(() => ChecklistDayFactory());
  injector.registerDependency<ItemFactory>(() => ItemFactory());
  injector.registerDependency<UnitFactory>(() => UnitFactory());

  injector.registerSingleton<WorksiteCache>(() {
    final parser = injector.get<WorksiteFactory>();
    final storage = injector.get<LocalStorage>();
    final m = ReadWriteMutex();
    return WorksiteCache(parser, storage, m);
  });

  injector.registerDependency<WorksiteHandler>(() {
    final worksiteCache = injector.get<WorksiteCache>();
    final parser = injector.get<WorksiteFactory>();
    return WorksiteHandler(worksiteCache, parser);
  });

  injector.registerSingleton<ChecklistCache>(() {
    final parser = injector.get<ChecklistFactory>();
    final storage = injector.get<LocalStorage>();
    final m = ReadWriteMutex();
    return ChecklistCache(parser, storage, m);
  });

  injector.registerDependency<ChecklistHandler>(() {
    final checklistCache = injector.get<ChecklistCache>();
    final parser = injector.get<ChecklistFactory>();
    return ChecklistHandler(checklistCache, parser);
  });

  injector.registerSingleton<ChecklistDayCache>(() {
    final parser = injector.get<ChecklistDayFactory>();
    final storage = injector.get<LocalStorage>();
    final m = ReadWriteMutex();
    return ChecklistDayCache(parser, storage, m);
  });

  injector.registerDependency<ChecklistDayHandler>(() {
    final checklistDayCache = injector.get<ChecklistDayCache>();
    final parser = injector.get<ChecklistDayFactory>();
    return ChecklistDayHandler(checklistDayCache, parser);
  });

  injector.registerSingleton<ItemCache>(() {
    final parser = injector.get<ItemFactory>();
    final storage = injector.get<LocalStorage>();
    final m = ReadWriteMutex();
    return ItemCache(parser, storage, m);
  });

  injector.registerDependency<ItemHandler>(() {
    final itemCache = injector.get<ItemCache>();
    final parser = injector.get<ItemFactory>();
    return ItemHandler(itemCache, parser);
  });

  injector.registerSingleton<UnitCache>(() {
    final parser = injector.get<UnitFactory>();
    final storage = injector.get<LocalStorage>();
    final m = ReadWriteMutex();
    return UnitCache(parser, storage, m);
  });

  injector.registerDependency<UnitHandler>(() {
    final unitCache = injector.get<UnitCache>();
    final parser = injector.get<UnitFactory>();
    return UnitHandler(unitCache, parser);
  });

  injector.registerDependency<DataSync>(() {
    final worksiteCache = injector.get<WorksiteCache>();
    final checklistCache = injector.get<ChecklistCache>();
    final checklistDayCache = injector.get<ChecklistDayCache>();
    final itemCache = injector.get<ItemCache>();
    final unitCache = injector.get<UnitCache>();
    return DataSync(
        worksiteCache, checklistCache, checklistDayCache, itemCache, unitCache);
  });

  // DEFAULT VALUE CREATION
  //units
  // BRENDAN NOTE: From interview, these were the most important units
  List<String> unitNames = [
    'ls',
    'ea',
    'lf',
    'sf',
    'used',
    'bags',
    'boxes',
    'pallets',
    'panels',
    'pieces',
    'rolls',
    'sheets',
    'units',
    'hours',
    'other',
  ];

    // 'm',
    // 'm2',
    // 'm3',
    // 'cm',
    // 'cm2',
    // 'cm3',
    // 'mm',
    // 'mm2',
    // 'mm3',
    // 'km',
    // 'km2',
    // 'ft',
    // 'ft2',
    // 'ft3',
    // 'in',
    // 'in2',
    // 'in3',
    // 'yd',
    // 'yd2',
    // 'yd3',
    // 'mi',
    // 'men',
    // 'days',
    // 'L',
    // 'gal',
    // 'kg',
    // 't',
    // 'lb',
    // 'oz',
    // 'g',

  for (String unitName in unitNames) {
    Unit unit = Unit(
        id: ID_UnitPrefix + unitName,
        name: unitName,
        companyId: ID_CompanyPrefix + "1",
        dateCreated: DateTime.now().toUtc(),
        dateUpdated: DateTime.now().toUtc());
    injector.get<UnitCache>().store(unit.id, unit);
  }

  Worksite worksiteTest = Worksite(
    id: ID_WorksitePrefix + "1",
    name: 'Sunvalley Poultry',
    companyId: ID_CompanyPrefix + "1",
    ownerId: ID_UserPrefix + "1",
    dateCreated: DateTime.now().toUtc(),
    dateUpdated: DateTime.now().toUtc(),
  );

  Checklist checklistTest = Checklist(
    id: ID_ChecklistPrefix + "1",
    worksiteId: ID_WorksitePrefix + "1",
    dateCreated: DateTime.now().toUtc(),
    dateUpdated: DateTime.now().toUtc(),
  );

  ChecklistDay checklistDayTest = ChecklistDay(
    id: ID_ChecklistDayPrefix + "1",
    checklistId: ID_ChecklistPrefix + "1",
    date: DateTime.now().toUtc(),
    dateCreated: DateTime.now().toUtc(),
    dateUpdated: DateTime.now().toUtc(),
  );
  Item itemTest = Item(
      id: ID_ItemPrefix + "1",
      checklistDayId: ID_ChecklistDayPrefix + "1",
      unitId: ID_UnitPrefix + "hours",
      desc: "Foreman Frank's Hours",
      result: '',
      comment: 'test',
      creatorId: ID_UserPrefix + "1",
      verified: true,
      dateCreated: DateTime.now().toUtc(),
      dateUpdated: DateTime.now().toUtc());

  checklistDayTest.addItemId('Labour', itemTest.id);

  Item itemTest6 = Item(
      id: ID_ItemPrefix + "6",
      checklistDayId: ID_ChecklistDayPrefix + "1",
      unitId: ID_UnitPrefix + "hours",
      desc: "Leadhand Dan's Hours",
      result: '',
      comment: 'test',
      creatorId: ID_UserPrefix + "1",
      verified: true,
      dateCreated: DateTime.now().toUtc(),
      dateUpdated: DateTime.now().toUtc());

  checklistDayTest.addItemId('Labour', itemTest6.id);

  Item itemTest7 = Item(
      id: ID_ItemPrefix + "7",
      checklistDayId: ID_ChecklistDayPrefix + "1",
      unitId: ID_UnitPrefix + "hours",
      desc: "Manual Labour Paul's Hours",
      result: '',
      comment: 'test',
      creatorId: ID_UserPrefix + "1",
      verified: true,
      dateCreated: DateTime.now().toUtc(),
      dateUpdated: DateTime.now().toUtc());

  checklistDayTest.addItemId('Labour', itemTest7.id);

  Item itemTest2 = Item(
      id: ID_ItemPrefix + "2",
      checklistDayId: ID_ChecklistDayPrefix + "1",
      unitId: ID_UnitPrefix + "units",
      desc: "Ceiling Panels (avg 14/day)",
      result: '',
      comment: 'test',
      creatorId: ID_UserPrefix + "1",
      verified: true,
      dateCreated: DateTime.now().toUtc(),
      dateUpdated: DateTime.now().toUtc());

  checklistDayTest.addItemId('Labour', itemTest2.id);

  Item itemTest3 = Item(
      id: ID_ItemPrefix + "3",
      checklistDayId: ID_ChecklistDayPrefix + "1",
      unitId: ID_UnitPrefix + "used",
      desc: "Forklift 5K 14'-17' DF IND - one month plus one week duration",
      result: '',
      comment: 'test',
      creatorId: ID_UserPrefix + "1",
      verified: true,
      dateCreated: DateTime.now().toUtc(),
      dateUpdated: DateTime.now().toUtc());

  checklistDayTest.addItemId('Equipment', itemTest3.id);

  Item itemTest4 = Item(
      id: ID_ItemPrefix + "4",
      checklistDayId: ID_ChecklistDayPrefix + "1",
      unitId: ID_UnitPrefix + "panels",
      desc: "Wall Panels 3'-9\" wide X 29'-11\" long",
      result: '',
      comment: 'test',
      creatorId: ID_UserPrefix + "1",
      verified: true,
      dateCreated: DateTime.now().toUtc(),
      dateUpdated: DateTime.now().toUtc());

  checklistDayTest.addItemId('Materials', itemTest4.id);

  Item itemTest5 = Item(
      id: ID_ItemPrefix + "5",
      checklistDayId: ID_ChecklistDayPrefix + "1",
      unitId: ID_UnitPrefix + "panels",
      desc: "Ceiling Panels 3'-9\" wide X 29'-11\" long",
      result: '',
      comment: 'test',
      creatorId: ID_UserPrefix + "1",
      verified: true,
      dateCreated: DateTime.now().toUtc(),
      dateUpdated: DateTime.now().toUtc());

  checklistDayTest.addItemId('Materials', itemTest5.id);

  checklistTest.addChecklistDay(checklistDayTest, null, null);
  worksiteTest.checklistIds!.add(checklistTest.id);

  injector.get<WorksiteCache>().store(worksiteTest.id, worksiteTest);
  injector.get<ChecklistCache>().store(checklistTest.id, checklistTest);
  injector
      .get<ChecklistDayCache>()
      .store(checklistDayTest.id, checklistDayTest);
  injector.get<ItemCache>().store(itemTest.id, itemTest);
  injector.get<ItemCache>().store(itemTest2.id, itemTest2);
  injector.get<ItemCache>().store(itemTest3.id, itemTest3);
  injector.get<ItemCache>().store(itemTest4.id, itemTest4);
  injector.get<ItemCache>().store(itemTest5.id, itemTest5);
  injector.get<ItemCache>().store(itemTest6.id, itemTest7);
  injector.get<ItemCache>().store(itemTest7.id, itemTest6);

  // If the "PORT" environment variable is set, listen to it. Otherwise, 8080.
  // https://cloud.google.com/run/docs/reference/container-contract#port
  final port = int.parse(Platform.environment['PORT'] ?? Server_Port);

  // See https://pub.dev/documentation/shelf/latest/shelf/Cascade-class.html
  final cascade = Cascade()
      // First, serve files from the 'public' directory
      .add(_staticHandler)
      // If a corresponding file is not found, send requests to a `Router`
      .add(_router.call);

  // See https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
  final server = await shelf_io.serve(
    // See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
    logRequests()
        // See https://pub.dev/documentation/shelf/latest/shelf/MiddlewareExtensions/addHandler.html
        .addHandler(cascade.handler),
    InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  print('Serving at http://${server.address.host}:${server.port}');

  // Used for tracking uptime of the demo server.
  //_watch.start();
}

// Serve files from the file system.
final _staticHandler =
    shelf_static.createStaticHandler('public', defaultDocument: 'index.html');

// Router instance to handler requests.
final _router = shelf_router.Router()
  ..post(
      API_DataSync, Injector.appInstance.get<DataSync>().handleCheckCacheSync)
  ..get(API_Worksite + '/<id>',
      (Injector.appInstance.get<WorksiteHandler>()).handleGet)
  ..get(API_WorksiteUserVisible + '/<companyId>/<userId>',
      Injector.appInstance.get<WorksiteHandler>().handleGetUserVisibleWorksites)
  ..post(API_Worksite, Injector.appInstance.get<WorksiteHandler>().handlePost)
  ..put(API_Worksite, Injector.appInstance.get<WorksiteHandler>().handlePut)
  ..delete(
      API_Worksite, Injector.appInstance.get<WorksiteHandler>().handleDelete)
  ..get(API_Checklist + '/<id>',
      Injector.appInstance.get<ChecklistHandler>().handleGet)
  ..get(
      API_ChecklistOnWorksite + '/<worksiteId>',
      Injector.appInstance
          .get<ChecklistHandler>()
          .handleGetChecklistsOnWorksite)
  ..post(
    API_Checklist,
    Injector.appInstance.get<ChecklistHandler>().handlePost,
  )
  ..put(
    API_Checklist,
    Injector.appInstance.get<ChecklistHandler>().handlePut,
  )
  ..delete(
    API_Checklist,
    Injector.appInstance.get<ChecklistHandler>().handleDelete,
  )
  ..get(
    API_ChecklistDay + '/<id>',
    Injector.appInstance.get<ChecklistDayHandler>().handleGet,
  )
  ..get(
    API_DaysOnChecklist + '/<checklistId>',
    Injector.appInstance.get<ChecklistDayHandler>().handleGetDaysOnChecklist,
  )
  ..post(
    API_ChecklistDay,
    Injector.appInstance.get<ChecklistDayHandler>().handlePost,
  )
  ..put(
    API_ChecklistDay,
    Injector.appInstance.get<ChecklistDayHandler>().handlePut,
  )
  ..delete(
    API_ChecklistDay,
    Injector.appInstance.get<ChecklistDayHandler>().handleDelete,
  )
  ..get(
    API_Item + '/<id>',
    Injector.appInstance.get<ItemHandler>().handleGet,
  )
  ..get(
    API_ItemOnChecklist + '/<checklistId>',
    Injector.appInstance.get<ItemHandler>().handleGetItemsOnChecklist,
  )
  ..get(
    API_ItemOnChecklistDay + '/<checklistDayId>',
    Injector.appInstance.get<ItemHandler>().handleGetItemsOnChecklistDay,
  )
  ..post(
    API_Item,
    Injector.appInstance.get<ItemHandler>().handlePost,
  )
  ..put(
    API_Item,
    Injector.appInstance.get<ItemHandler>().handlePut,
  )
  ..delete(
    API_Item,
    Injector.appInstance.get<ItemHandler>().handleDelete,
  )
  ..get(API_Unit + '/<id>', Injector.appInstance.get<UnitHandler>().handleGet)
  ..get(API_UnitsAll + '/<companyId>',
      Injector.appInstance.get<UnitHandler>().handleGetAll)
  ..post(API_Unit, Injector.appInstance.get<UnitHandler>().handlePost)
  ..put(API_Unit, Injector.appInstance.get<UnitHandler>().handlePut);
