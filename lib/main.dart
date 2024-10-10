import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
// import 'package:build_stats_flutter/tutorial_main.dart';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

void main() async {
  await initLocalStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
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
  var currWorksite = Worksite(id: 1234);
  Checklist? currChecklist; // = currWorksite.checklists?[0];

  void getChecklist(int index) {
    currChecklist = currWorksite.checklists?[index];
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  // Text(" < "),
                  // SizedBox(width: 50),
                  // Spacer(),
                  Text(" < DATE > "),
                  // Spacer(),
                  // SizedBox(width: 50),
                  // Text(" > "),
                ],
              ),

              Text("Bob Dob Destructions"),

              Text("Categories:"),

              CategoryExpansionTile(catTitle: Text("Labour")),

              CategoryExpansionTile(catTitle: Text("Equipment")),

              CategoryExpansionTile(catTitle: Text("Materials")),

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
                    hintText: 'Units'),
              )),

          // SizedBox(width: 10),
          VerticalDivider(),
          // SizedBox(width: 25),

          Expanded(
              child: TextFormField(
            decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                hintText: 'Description'),
          )),

          // SizedBox(width: 25),
          VerticalDivider(),
          // SizedBox(width: 25),

          SizedBox(
              width: 100,
              child: TextFormField(
                decoration: const InputDecoration(
                    // border: OutlineInputBorder(),
                    hintText: 'Result'),
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