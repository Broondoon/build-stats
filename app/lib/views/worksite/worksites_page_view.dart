// View Imports:
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/navigation/nav_bar_view.dart';
import 'package:build_stats_flutter/views/navigation/top_bar_view.dart';
import 'package:build_stats_flutter/views/overlay/base_overlay_view.dart';
import 'package:build_stats_flutter/views/state_controller.dart';
import 'package:build_stats_flutter/views/worksite/worksite_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyWorksitesPage extends StatefulWidget {
  const MyWorksitesPage({
    super.key
  });

  @override
  State<MyWorksitesPage> createState() => _MyWorksitesPageState();
}

class _MyWorksitesPageState extends State<MyWorksitesPage> {
  // TODO: LOAD FROM DB ON CONSTRUCTION
  List<Widget> worksiteList = [];
  var numWorksites = 0;
  OverlayEntry? _overlayEntry;

  // TODO: decide if this should be pulled from elsewhere
  DateTime currDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadWorksites();
  }

  Future<void> _loadWorksites() async {
    List<Worksite> worksites = await Provider.of<MyAppState>(
      context,
      listen: false,
    ).loadUserWorksites();

    for (Worksite worksite in worksites) {
      print('WORKSITE NAME: ${worksite.name}');
      int tmpid = 6;
      // setState(() {
        addWorksite(
          worksite.name, 
          '2024-AD8${tmpid + worksites.length}', 
          'Crackstone Construction', 
          [('Foreman', 'Frank')],
        );
      // });
    }
  }

  void showNewWorksiteOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => BaseOverlay(
        closefunct: addNewWorksite,
        overlayRef: _overlayEntry!,
        choice: overlayChoice.worksite,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void addNewWorksite(
    String workname, 
    String newIntId, 
    String newContractor,
    List<(String, String)> newpeople,
  ) {
    Provider.of<MyAppState>(
      context,
      listen: false,
    ).saveNewWorksite(
      workname,
      newIntId,
      newContractor,
      newpeople,
    );

    addWorksite(
      workname, 
      newIntId, 
      newContractor,
      newpeople,
    );
  }

  void addWorksite(
    String workname, 
    String newIntId, 
    String newContractor,
    List<(String, String)> newpeople,
  ) {
    setState(() {
      numWorksites++;

      if (numWorksites > 1) {
        worksiteList.add(
          const Divider(
            height: 0.0,
          ),
        );
      }

      worksiteList.add(
        WorksiteItem(
          context: context, 
          // numWorksites: numWorksites, 
          currDay: currDay,
          workname: workname,
          intId: newIntId,
          contractor: newContractor,
          people: newpeople,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(
        // appBarText: 'Worksites',
        // worksiteDate: null,
        whichAppBar: topBarChoice.worksitelist,
      ),
      body: Material(
        clipBehavior: Clip.hardEdge,
        child: Padding(
          // Padding because the button at bottom felt a little too close to bottom edge
          padding: const EdgeInsets.fromLTRB(0.8, 0.8, 0.8, 8.0),
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: worksiteList.length,
                  itemBuilder: (context, index) {
                    return worksiteList[index];
                  },
                ),
              ),
              // Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: TextButton(
                  style: MyAppStyle.buttonStyle,
                  onPressed: () {
                    showNewWorksiteOverlay();
                    // addWorksite();
                  },
                  child: const Text(
                    'Create New Worksite',
                    style: MyAppStyle.regularFont,
                  ),
                ),
              ),
              // const Spacer(),
              // const NavBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
