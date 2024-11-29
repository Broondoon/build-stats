// View Imports:
import 'dart:async';

import 'package:build_stats_flutter/model/Domain/Service/cache_service.dart';
import 'package:build_stats_flutter/model/entity/unit.dart';
import 'package:build_stats_flutter/model/storage/data_sync/data_sync.dart';
import 'package:build_stats_flutter/model/storage/local_storage/to_CSV.dart';
import 'package:build_stats_flutter/model/storage/unit_cache.dart';
import 'package:build_stats_flutter/views/checklist/button_row_view.dart';
import 'package:build_stats_flutter/views/categories/cat_list_view.dart';
import 'package:build_stats_flutter/views/date/date_row_view.dart';

// Model Imports:
import 'package:build_stats_flutter/model/entity/user.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
import 'package:build_stats_flutter/model/storage/item_cache.dart';
import 'package:build_stats_flutter/model/storage/worksite_cache.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';

// Resource Imports:
import 'package:build_stats_flutter/resources/app_colours.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:build_stats_flutter/views/navigation/nav_bar_view.dart';
import 'package:build_stats_flutter/views/navigation/top_bar_view.dart';
import 'package:build_stats_flutter/views/overlay/base_overlay_view.dart';
import 'package:build_stats_flutter/views/state_controller.dart';
import 'package:build_stats_flutter/views/worksite/worksites_page_view.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/app_strings.dart';

// ??? Imports:
import 'package:shared/cache.dart';

// External Imports:
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';
import 'package:provider/provider.dart';
import 'package:injector/injector.dart';
import 'package:shared/entity.dart';

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

  // try {
  //   runApp(const MyApp());
  // } catch (e) {
  //   print(e);
  //   exit(1);
  // }
}



// Future<void> initTestStorage() async {
//   Worksite testWorksite = Worksite(
//     id: "Worksite1",
//     checklistIds: ["Checklist1"],
//   );
//   Checklist testChecklist = Checklist(
//       id: "Checklist1",
//       worksiteId: "Worksite1",
//       date: DateTime.now(),
//       comment: "This is a comment",
//       itemIds: ["Item1"]);
//   Item testItem = Item(
//       id: "Item1",
//       checklistId: "Checklist1",
//       unit: "unit",
//       desc: "desc",
//       result: "result",
//       comment: "comment",
//       creatorId: 1,
//       verified: true);

//   await WorksiteCache.StoreWorksite(testWorksite);
//   print("stored worksite");
//   await ChecklistCache.StoreChecklist(testChecklist);
//   print("stored checklist");
//   await ItemCache.StoreItem(testItem);
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Need to access the app state in the unit cache to potentially update units on data sync. 
    //so regestring it as a singleton to grab it when needed.
    Injector.appInstance.registerSingleton<MyAppState>(() => MyAppState());
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
        home: MyLandingPage(), //MyScratchPage(),
      ),
    );
  }
}

class MyLandingPage extends StatelessWidget {
  const MyLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: MyAppColours.g5,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  // A sneaky hack! Forces spaceBetween to put things where we want them
                  height: 0.0,
                  width: 0.0,
                ),
                const Text(
                  'SiteReady',
                  style: MyAppStyle.titleFont,
                ),
                // SizedBox(
                //   height: 0.0,
                //   width: 0.0,
                // ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const MyWorksitesPage();
                        }));
                      },
                      child: const Text('Office'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const MyChecklistPage();
                        }));
                      },
                      child: const Text('Worksite'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyChecklistPage extends StatefulWidget {
  const MyChecklistPage({super.key});

  @override
  State<MyChecklistPage> createState() => _MyChecklistPageState();
}

class _MyChecklistPageState extends State<MyChecklistPage> {
  // ChangeManager changeManager = Injector.appInstance.get<ChangeManager>();

  // User currUser = User(
  //       id: '${ID_UserPrefix}1',
  //       companyId: '${ID_CompanyPrefix}1',
  //       dateCreated: DateTime.now(),
  //       dateUpdated: DateTime.now(),
  // );

  // Worksite? currWorksite;
  // Checklist? currChecklist;
  // ChecklistDay? currChecklistDay;
  // List<List<String>>? currItemsByCat = [];
  // DateTime pageDay = DateTime.now();
  // late DateTime startDay = pageDay;
  OverlayEntry? _overlayEntry;
  late Future<void> serverFuture;

  @override
  void initState() {
    super.initState();
    // _loadEverything();
    serverFuture = Provider.of<MyAppState>(
      context,
      listen: false,
    ).loadEverything();
  }

  // Future<void> _loadEverything() async {    
  //   List<Worksite> userWorksites = await changeManager.getUserWorksites(currUser) ?? [];

  //   if (userWorksites.isEmpty) {
  //     currWorksite = await changeManager.createWorksite(currUser);
  //   }
  //   else {
  //     // TODO: actually load the right one
  //     // But for now, just load the first one
  //     currWorksite = userWorksites.first;
  //   }

  //   List<String> checklistIds = currWorksite!.checklistIds ?? [];

  //   if (checklistIds.isEmpty) {
  //     currChecklist = await changeManager.createChecklist(currWorksite!);
  //   }
  //   else {
  //     currChecklist = await changeManager.getChecklistById(checklistIds.first);
  //   }

  //   currChecklistDay = await changeManager.GetChecklistDayByDate(pageDay, currChecklist!);
  // }

  // setState(() {
  // getItemsByCategory() gives ids
  // getItemById() gives the item I want

  // List<String> categories = currChecklistDay!.getCategories();
  // currItemsByCat = [];

  // categories.forEach((cat) {
  //   print("CETORGY:");
  //   print(cat);

  //   List<String> catIds = currChecklistDay!.getItemsByCategory(cat);
  //   currItemsByCat!.add(catIds);
  // });
  // });

  // TODO: Untangle this mess so that we can actually refactor it into a view
  void _showCommentOverlay(BuildContext context) {
    // TODO: LOAD COMMENTS WHEN RAN
    String comments = 'placeholder';

    _overlayEntry = OverlayEntry(
      builder: (context) => BaseOverlay.comment(
        closefunct: () {}, // _removeOverlay, //TODO: This is bad
        overlayRef: _overlayEntry!,
        // choice: overlayChoice.comments,
        comments: comments,
        // pageday: pageDay,
        // checklistDay: currChecklistDay,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    //// This piece of code closes the overlay once 2 seconds have passed!
    // Future.delayed(const Duration(seconds: 2), () {
    //   overlayEntry?.remove();
    // });
  }

  Future<void> testFutureBuilderWithDelay() async {
    await Future.delayed(const Duration(seconds: 5), () {
      print('Delay done!');
    });
  }

  // void _updatePageDay(DateTime newDay) {
  //   setState(() {
  //     pageDay = newDay;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();
    // return Consumer<MyAppState>(
    //   builder: (
    //     context, 
    //     appState, 
    //     child,
    //   ) {
        return FutureBuilder<void>(
          // future: testFutureBuilderWithDelay(),
          // future: appState.loadEverything(),
          future: serverFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Text('Waiting...')
              );
            } else if (snapshot.hasError) {
              return Scaffold (
                body: Text(
                  'Error: ${snapshot.error}',  // Display the error
                  style: const TextStyle(
                    color: Colors.red
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                // backgroundColor: Colors.transparent,
                appBar: const TopBar(
                  whichAppBar: topBarChoice.checklist,
                ),
              
                bottomNavigationBar: const NavBottomBar(),
              
                body: Column(
                  children: [
                    const DateRow(),
              
                    const CategoryList(
                      // pageday: pageDay,
                      // checklistDay: currChecklistDay!,
                    ),
              
                    // CommentCard(),
              
                    ButtonRow(
                      editFunct: () {},
                      saveFunct: () {},
                      commentFunct: () {
                        _showCommentOverlay(context);
                      },
                    ),
              
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            } else {
              return const Text('Nope, nada');
            }
          }
        );
    //   },
    // );
  }
}
