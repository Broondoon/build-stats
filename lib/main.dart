// View Imports:
import 'package:build_stats_flutter/views/item/item_view.dart';
import 'package:build_stats_flutter/views/checklist/checklist_view.dart';

// Model Imports:
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
// import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
// import 'package:build_stats_flutter/model/storage/item_cache.dart';
// import 'package:build_stats_flutter/model/storage/worksite_cache.dart';
// import 'package:build_stats_flutter/tutorial_main.dart';
// import 'package:localstorage/localstorage.dart';

// Resource Imports:
import 'package:build_stats_flutter/resources/app_colours.dart';

// External Imports:
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await initLocalStorage();
  // await initTestStorage();
  runApp(const MyApp());
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
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Build Stats',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyLandingPage(), //MyChecklistPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  Worksite? currWorksite;
  Checklist? currChecklist;

  void setWorksite(Worksite worksite) {
    currWorksite = worksite;
  }

  void setChecklist(Checklist checklist) {
    currChecklist = checklist;
  }

  void newItem(List<Widget> currItems) {
    currItems.add(RowItem());
    notifyListeners();
  }
}

class MyLandingPage extends StatelessWidget {
  const MyLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Build Stats"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context, MaterialPageRoute(
                builder: (context) {
                  return const MyWorksitesPage();
                }
              )
            );
          },
          child: const Text("Next"),
        ),
      ),
    );
  }
}

class MyWorksitesPage extends StatelessWidget {
  const MyWorksitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Worksites"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context, MaterialPageRoute(
                builder: (context) {
                  return const MyChecklistPage();
                }
              )
            );
          },
          child: const Text("Next"),
        ),
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
  Checklist? currChecklist;
  List<Item>? currItems = [];

  @override
  void initState() {
    super.initState();
    // _loadItems();
  }

  // Future<void> _loadItems() async {
  //   // final Checklist? checklist = await Checklistcache.GetChecklistById("1");
  //   currChecklist = await ChecklistCache.GetChecklistById("Checklist1");
  //   setState(() {
  //     currItems = currChecklist?.items;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Checklist A"),
        // automaticallyImplyLeading: false, // <--- Uncomment this to remove app bar back button
        // See: https://stackoverflow.com/questions/44978216/flutter-remove-back-button-on-appbar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: MyAppColours.linGradColours,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
                side: BorderSide(
                  color: Colors.transparent, // Colors.black,
                  width: 2,
                )
              ),
              child: Column(
                children: [
                  DateRow(currChecklist: currChecklist),
              
                  Text("Solid Foundations Landscaping"),
              
                  Text("Categories:"),
              
                  CategoryExpansionTile(catTitle: Text("Labour")),
              
                  CategoryExpansionTile(catTitle: Text("Equipment")),
              
                  CategoryExpansionTile(catTitle: Text("Materials")),
              
                  CommentCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}