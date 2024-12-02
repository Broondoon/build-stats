// View Imports:
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:build_stats_flutter/views/categories/cat_list_view.dart';
import 'package:build_stats_flutter/views/checklist/button_row_view.dart';
import 'package:build_stats_flutter/views/date/date_row_view.dart';
import 'package:build_stats_flutter/views/navigation/nav_bar_view.dart';
import 'package:build_stats_flutter/views/navigation/top_bar_view.dart';
import 'package:build_stats_flutter/views/overlay/base_overlay_view.dart';
import 'package:build_stats_flutter/views/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyChecklistPage extends StatefulWidget {
  const MyChecklistPage({super.key});

  @override
  State<MyChecklistPage> createState() => _MyChecklistPageState();
}

class _MyChecklistPageState extends State<MyChecklistPage> {
  OverlayEntry? _overlayEntry;
  late Future<void> serverFuture;

  late Function _exportWorksiteFunc;

  @override
  void initState() {
    super.initState();
    serverFuture = Provider.of<MyAppState>(
      context,
      listen: false,
    ).loadEverything();
    _exportWorksiteFunc = Provider.of<MyAppState>(
      context,
      listen: false,
    ).exportWorksite;
  }

  // TODO: Untangle this mess so that we can actually refactor it into a view
  void _showCommentOverlay(BuildContext context) {
    // TODO: LOAD COMMENTS WHEN RAN
    String comments = 'placeholder';

    _overlayEntry = OverlayEntry(
      builder: (context) => BaseOverlay.comment(
        closefunct: () {}, // _removeOverlay, //TODO: This is bad
        overlayRef: _overlayEntry!,
        comments: comments,
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

  @override
  Widget build(BuildContext context) {
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
                  exportFunct: _exportWorksiteFunc,
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
  }
}
