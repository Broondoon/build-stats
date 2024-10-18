import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
import 'package:build_stats_flutter/model/storage/item_cache.dart';
import 'package:build_stats_flutter/model/storage/worksite_cache.dart';
// import 'package:build_stats_flutter/tutorial_main.dart';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print(DateTime.now());
  await initLocalStorage();
  await initTestStorage();
  runApp(const MyApp());
  print("APP IS RUNNING YAY");
}

Future<void> initTestStorage() async {
  Worksite testWorksite = Worksite(
    id: "Worksite1",
    checklistIds: ["Checklist1"],
  );
  Checklist testChecklist = Checklist(
      id: "Checklist1",
      worksiteId: "Worksite1",
      date: DateTime.now(),
      comment: "This is a comment",
      itemIds: ["Item1"]);
  Item testItem = Item(
      id: "Item1",
      checklistId: "Checklist1",
      unit: "unit",
      desc: "desc",
      result: "result",
      comment: "comment",
      creatorId: 1,
      verified: true);
  print("starting storage");
  await WorksiteCache.StoreWorksite(testWorksite);
  print("stored worksite");
  await ChecklistCache.StoreChecklist(testChecklist);
  print("stored checklist");
  await ItemCache.StoreItem(testItem);
  print("stored item");
}

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
        home: MyHomePage(),
      ),
    );

    // const appTitle = 'Form Styling Demo';
    // return MaterialApp(
    //   title: appTitle,
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: const Text(appTitle),
    //     ),
    //     // body: const MyCustomForm(),
    //   ),
    // );
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
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Checklist? currChecklist;
  List<Item>? currItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    // final Checklist? checklist = await Checklistcache.GetChecklistById("1");
    currChecklist = await ChecklistCache.GetChecklistById("Checklist1");
    setState(() {
      currItems = currChecklist?.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
                side: BorderSide(
                  color: Colors.black,
                  width: 2,
                )),
            child: Column(
              children: [
                DateRow(currChecklist: currChecklist),

                Text("Solid Foundations Landscaping"),

                Text("Categories:"),

                CategoryExpansionTile(catTitle: Text("Labour")),

                CategoryExpansionTile(catTitle: Text("Equipment")),

                CategoryExpansionTile(catTitle: Text("Materials")),

                CommentCard()

                // const Text('Spacer 1'),
                // Text(appState.currWorksite.id.toString()),
                // TextField(
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(),
                //     hintText: 'Enter something here!'
                //   ),
                // ),
                // TextFormField(
                //   decoration: const InputDecoration(
                //     border: UnderlineInputBorder(),
                //     labelText: 'Another text input!'
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Card(
          margin: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.black,
                width: 1,
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Comment here!"),
            ),
          ),
        ),
      ),
    );
  }
}

class DateRow extends StatelessWidget {
  const DateRow({
    super.key,
    required this.currChecklist,
  });

  final Checklist? currChecklist;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 10,
          onPressed: () {},
        ),

        Text(
            "Date: ${currChecklist?.date?.year}-${currChecklist?.date?.month}-${currChecklist?.date?.day}"), // ?? "No date"),
        //Text("Date: 2024-10-11"),

        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          iconSize: 10,
          onPressed: () {},
        ),
      ],
    );
  }
}

class CategoryExpansionTile extends StatelessWidget {
  final Text catTitle;
  const CategoryExpansionTile({
    super.key,
    required this.catTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: catTitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
          // IconButton(
          //   icon: Icon(Icons.add),
          //   onPressed: () {},
          // ),
        ],
      ),
      children: [
        RowItem(),
      ],
    );
  }
}

class RowItem extends StatelessWidget {
  const RowItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(
        // color: Colors.blueAccent,
        width: 1,
      )),
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: TextFormField(
                decoration: const InputDecoration(
                    // border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: 'Units'),
              )),

          // SizedBox(width: 10),
          VerticalDivider(),
          // SizedBox(width: 25),

          Expanded(
              child: TextFormField(
            decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                border: InputBorder.none,
                hintText: 'Description'),
          )),

          // SizedBox(width: 25),
          VerticalDivider(),
          // SizedBox(width: 25),

          SizedBox(
              width: 100,
              child: TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                    // border: OutlineInputBorder(),
                    border: InputBorder.none,
                    hintText: 'Value'),
              )),
        ],
      ),
    );
  }
}

// class MyChecklistPage extends StatefulWidget {
//   @override
//   State<MyChecklistPage> createState() => _MyChecklistPageState();
// }

// class _MyChecklistPageState extends State<MyChecklistPage> {
//   var currWorksite = Worksite(id: 1234);

//   @override
//   Widget build(BuildContext context) {
    

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Scaffold(
//           body: Row(
//             children: [
//               SafeArea(

//               ),
//               Expanded(
//                 child: Container(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   child: page, // GeneratorPage(),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//     );
//   }
// }





/* IDEA for Data Input Sync with Local Storage
   Implement one of the following:
   Sync occurs when click/tap outside of field
     (basically, when no longer interacting)
   Sync occurs set time after no changes
     (may be kinda hard to do)
*/

/* Text Editing Controller!
https://api.flutter.dev/flutter/widgets/TextEditingController-class.html
*/