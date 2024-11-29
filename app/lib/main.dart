// View Imports:
import 'package:build_stats_flutter/views/landing_page/landing_page_view.dart';

// Model Imports:
import 'package:build_stats_flutter/model/entity/unit.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
import 'package:build_stats_flutter/model/storage/item_cache.dart';
import 'package:build_stats_flutter/model/storage/worksite_cache.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/storage/data_sync/data_sync.dart';
import 'package:build_stats_flutter/model/storage/unit_cache.dart';

// Resource Imports:
import 'package:build_stats_flutter/views/state_controller.dart';

// Custom Imports:
import 'package:shared/cache.dart';

// External Imports:
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';
import 'package:provider/provider.dart';
import 'package:injector/injector.dart';

// BUNK scratch import
// import 'package:build_stats_flutter/views/scratch.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await initLocalStorage();
  // await initTestStorage();

  final injector = Injector.appInstance;

  injector
      .registerSingleton<LocalStorage>(() => LocalStorage(ReadWriteMutex()));

  injector.registerDependency<WorksiteFactory>(() => WorksiteFactory());
  injector.registerDependency<ChecklistFactory>(() => ChecklistFactory());
  injector.registerDependency<ChecklistDayFactory>(() => ChecklistDayFactory());
  injector.registerDependency<ItemFactory>(() => ItemFactory());
  injector.registerDependency<UnitFactory>(() => UnitFactory());

  injector.registerDependency<DataConnection<Worksite>>(
      () => DataConnection<Worksite>());
  injector.registerDependency<DataConnection<Checklist>>(
      () => DataConnection<Checklist>());
  // TODO: ERRR
  injector.registerDependency<DataConnection<ChecklistDay>>(
      () => DataConnection<ChecklistDay>());
  injector
      .registerDependency<DataConnection<Item>>(() => DataConnection<Item>());
  injector
      .registerDependency<DataConnection<Unit>>(() => DataConnection<Unit>());

  injector.registerSingleton<JsonFileAccess<Worksite>>(() {
    final parser = injector.get<WorksiteFactory>();
    return JsonFileAccess<Worksite>(parser);
  });

  injector.registerSingleton<JsonFileAccess<Checklist>>(() {
    final parser = injector.get<ChecklistFactory>();
    return JsonFileAccess<Checklist>(parser);
  });

  injector.registerSingleton<JsonFileAccess<ChecklistDay>>(() {
    final parser = injector.get<ChecklistDayFactory>();
    return JsonFileAccess<ChecklistDay>(parser);
  });

  injector.registerSingleton<JsonFileAccess<Item>>(() {
    final parser = injector.get<ItemFactory>();
    return JsonFileAccess<Item>(parser);
  });

  injector.registerSingleton<JsonFileAccess<Unit>>(() {
    final parser = injector.get<UnitFactory>();
    return JsonFileAccess<Unit>(parser);
  });

  injector.registerSingleton<WorksiteCache>(() {
    final dataConnection = injector.get<DataConnection<Worksite>>();
    final fileIOService = injector.get<JsonFileAccess<Worksite>>();
    final parser = injector.get<WorksiteFactory>();
    final storage = injector.get<LocalStorage>();
    final m = ReadWriteMutex();
    return WorksiteCache(
        dataConnection, fileIOService, parser, storage, m); // storage, m);
  });

  injector.registerSingleton<ChecklistCache>(() {
    final dataConnection = injector.get<DataConnection<Checklist>>();
    final fileIOService = injector.get<JsonFileAccess<Checklist>>();
    final parser = injector.get<ChecklistFactory>();
    final storage = injector.get<LocalStorage>();
    final m = ReadWriteMutex();
    return ChecklistCache(dataConnection, fileIOService, parser, storage, m);
  });

  injector.registerSingleton<ChecklistDayCache>(() {
    final dataConnection = injector.get<DataConnection<ChecklistDay>>();
    final fileIOService = injector.get<JsonFileAccess<ChecklistDay>>();
    final parser = injector.get<ChecklistDayFactory>();
    final storage = injector.get<LocalStorage>();
    final m = ReadWriteMutex();
    return ChecklistDayCache(dataConnection, fileIOService, parser, storage, m);
  });

  injector.registerSingleton<ItemCache>(() {
    final dataConnection = injector.get<DataConnection<Item>>();
    final fileIOService = injector.get<JsonFileAccess<Item>>();
    final parser = injector.get<ItemFactory>();
    final storage = injector.get<LocalStorage>();
    final m = ReadWriteMutex();
    return ItemCache(dataConnection, fileIOService, parser, storage, m);
  });

  injector.registerSingleton<UnitCache>(() {
    final dataConnection = injector.get<DataConnection<Unit>>();
    final fileIOService = injector.get<JsonFileAccess<Unit>>();
    final parser = injector.get<UnitFactory>();
    final storage = injector.get<LocalStorage>();
    final m = ReadWriteMutex();
    return UnitCache(dataConnection, fileIOService, parser, storage, m);
  });

  injector.registerDependency<DataSync>(() => DataSync(
        injector.get<WorksiteCache>(),
        injector.get<ChecklistCache>(),
        injector.get<ChecklistDayCache>(),
        injector.get<ItemCache>(),
        injector.get<UnitCache>(),
        null,
      ));

  injector.registerDependency<ChangeManager>(() {
    final _worksiteDataConnection = injector.get<DataConnection<Worksite>>();
    final _checklistDataConnection = injector.get<DataConnection<Checklist>>();
    final _checklistDayDataConnection =
        injector.get<DataConnection<ChecklistDay>>();
    final _itemDataConnection = injector.get<DataConnection<Item>>();
    final _unitDataConnection = injector.get<DataConnection<Unit>>();
    final _worksiteCache = injector.get<WorksiteCache>();
    final _checklistCache = injector.get<ChecklistCache>();
    final _checklistDayCache = injector.get<ChecklistDayCache>();
    final _itemCache = injector.get<ItemCache>();
    final _unitCache = injector.get<UnitCache>();
    final _worksiteFileIOS = injector.get<JsonFileAccess<Worksite>>();
    final _checklistFileIOS = injector.get<JsonFileAccess<Checklist>>();
    final _checklistDayFileIOS = injector.get<JsonFileAccess<ChecklistDay>>();
    final _itemFileIOS = injector.get<JsonFileAccess<Item>>();
    final _unitFileIOS = injector.get<JsonFileAccess<Unit>>();
    final _worksiteParser = injector.get<WorksiteFactory>();
    final _checklistParser = injector.get<ChecklistFactory>();
    final _checklistDayParser = injector.get<ChecklistDayFactory>();
    final _itemParser = injector.get<ItemFactory>();
    final _unitParser = injector.get<UnitFactory>();
    return ChangeManager(
      _worksiteDataConnection,
      _checklistDataConnection,
      _checklistDayDataConnection,
      _itemDataConnection,
      _unitDataConnection,
      _worksiteCache,
      _checklistCache,
      _checklistDayCache,
      _itemCache,
      _unitCache,
      _worksiteFileIOS,
      _checklistFileIOS,
      _checklistDayFileIOS,
      _itemFileIOS,
      _unitFileIOS,
      _worksiteParser,
      _checklistParser,
      _checklistDayParser,
      _itemParser,
      _unitParser,
    );
  });

  try {
    runApp(const MyApp()
        // const ProviderScope(child: MyApp()),
        );
  } catch (e) {
    print(e);
    exit(1);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Need to access the app state in the unit cache to potentially update units on data sync. 
    // so regestring it as a singleton to grab it when needed.
    // Brendan fix: We intentionally provoke an exception
    try {
      Injector.appInstance.get<MyAppState>();
    } catch (e) {
      Injector.appInstance.registerSingleton<MyAppState>(() => MyAppState());
    }
    
    return ChangeNotifierProvider(
      create: (context) => Injector.appInstance.get<MyAppState>(),//MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SiteReady',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        // home: MyLandingPage(), //MyChecklistPage(),
        home: const MyLandingPage(), //MyScratchPage(),
      ),
    );
  }
}