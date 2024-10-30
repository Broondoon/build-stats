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
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/navigation/nav_bar_view.dart';
import 'package:build_stats_flutter/views/navigation/top_bar_view.dart';

// External Imports:
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// BUNK scratch import
// import 'package:build_stats_flutter/views/scratch.dart';

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

class MyAppState extends ChangeNotifier {
  Worksite? currWorksite;
  Checklist? currChecklist;

  void setWorksite(Worksite worksite) {
    currWorksite = worksite;
  }

  void setChecklist(Checklist checklist) {
    currChecklist = checklist;
  }

  // About to be deprecated
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: MyAppColours.g5,
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox( // A sneaky hack! Forces spaceBetween to put things where we want them
                  height: 0.0,
                  width: 0.0,
                ),
                Text(
                  "SiteReady",
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
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) {
                              return const MyWorksitesPage();
                            }
                          )
                        );
                      },
                      child: const Text("Project Manager"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) {
                              return const MyChecklistPage();
                            }
                          )
                        );
                      },
                      child: const Text("Foreman"),
                    ),
                  ],
                ),
                SizedBox(
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

class MyWorksitesPage extends StatefulWidget {
  const MyWorksitesPage({super.key});

  @override
  State<MyWorksitesPage> createState() => _MyWorksitesPageState();
}

class _MyWorksitesPageState extends State<MyWorksitesPage> {
  // TODO: LOAD FROM DB ON CONSTRUCTION
  List<Widget> worksiteList = [];
  var numWorksites = 0;
  
  void addWorksite() {
    setState(() {
        numWorksites++;
        worksiteList.add(
          // TODO: TELL BACKEND TO CREATE NEW WORKSITE
          GestureDetector(
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) {
                    // TODO: GET SELECTED CHECKLIST INFO
                    // AND PASS IT TO THE CHECKLIST PAGE?
                    return const MyChecklistPage();
                  }
                )
              );
            },
            child: SizedBox(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TODO: READ FROM WORKSITE
                        Text(
                          "Worksite $numWorksites",
                          style: MyAppStyle.regularFont,
                        ),
                        Text(
                          "Start Date: 20XX-01-01",
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              )
            ),
          ),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        appBarText: "Worksites",
        isWorksite: false,
      ),
      body: Material(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: worksiteList.length,
                itemBuilder: (context, index) {
                  return worksiteList[index];
                },
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  addWorksite();
                },
                child: Text(
                  "Create New Worksite",
                  style: MyAppStyle.regularFont,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class MyChecklistPage extends StatefulWidget {
  const MyChecklistPage({super.key});

  @override
  State<MyChecklistPage> createState() => _MyChecklistPageState();
}

class _MyChecklistPageState extends State<MyChecklistPage> {
  // TODO: LOAD THIS FROM DB ON CONSTRUCTION
  Checklist? currChecklist;
  List<Item>? currItems = [];
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    // _loadItems();
  }

  // TODO: Untangle this mess so that we can actually refactor it into a view
  void showCommentOverlay(BuildContext context) {
    // TODO: LOAD COMMENTS WHEN RAN

    _overlayEntry = OverlayEntry (
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _removeOverlay,
            child: Container(
              color: Colors.black54,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          
          Positioned( // needed to have overlay from bottom
            bottom: 0,
            child: Material(  // material may or may not be needed EDIT: IT IS VERY MUCH NEEDED
              child: Container(  // ignoring the VS Code suggestion
                width: MediaQuery.of(context).size.width, // * 0.6,
                height: MediaQuery.of(context).size.height * 0.86,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.,
                    children: [
                      Container(
                        color: MyAppColours.g4,
                        child: SizedBox(
                          height: 40,
                          child: Center(
                            child: Text(
                              "Comments",
                              style: MyAppStyle.regularFont,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: MyAppColours.g5,
                              width: 2.0,
                            )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                            // TODO: REFACTOR FOR LOADING AND CODE MANIPULATION OF TEXT CONTENT
                            child: TextField(
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Start writing something..."
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    //// This piece of code closes the overlay once 2 seconds have passed!
    // Future.delayed(const Duration(seconds: 2), () {
    //   overlayEntry?.remove();
    // });
  }

  void _removeOverlay() {
      _overlayEntry?.remove();
  }

  // TODO: Re-enable loading!
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
      appBar: TopBar(
        // TODO: USE LOADED NAME
        appBarText: "Worksite 1",
        isWorksite: true,
      ),

      bottomNavigationBar: NavBottomBar(),

      body: Column(
        children: [
          DateRow(currChecklist: currChecklist),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CategoryExpansionTile(catTitle: Text("Labour")),
                    
                  CategoryExpansionTile(catTitle: Text("Equipment")),
                    
                  CategoryExpansionTile(catTitle: Text("Materials")),
                ],
              ),
            ),
          ),
          
          // CommentCard(),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 40,
                child: TextButton(
                  // style: MyAppStyle.buttonStyle,
                  child: Text("Edit", style: MyAppStyle.regularFont,),
                  onPressed: () {},
                ),
              ),

              SizedBox(
                width: 100,
                height: 40,
                child: TextButton(
                  // style: MyAppStyle.buttonStyle,
                  child: Text("Submit", style: MyAppStyle.regularFont,),
                  onPressed: () {},
                ),
              ),

              SizedBox(
                width: 120,
                height: 40,
                child: TextButton(
                  // style: MyAppStyle.buttonStyle,
                  child: Text("Comments", style: MyAppStyle.regularFont,),
                  onPressed: () {
                    showCommentOverlay(context);
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 20,),
        ],
      ),
    );
  }
}