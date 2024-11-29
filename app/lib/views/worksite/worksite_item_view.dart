// View Imports:

import 'package:build_stats_flutter/main.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/checklist/my_checklist_page.dart';
import 'package:flutter/material.dart';

class WorksiteItem extends StatelessWidget {
  const WorksiteItem({
    super.key,
    required this.context,
    // required this.numWorksites,
    required this.currDay,
    required this.workname,
    required this.intId,
    required this.contractor,
    required this.people,
  });

  final BuildContext context;
  // final int numWorksites;
  final DateTime currDay;
  final String workname; 
  final String intId; 
  final String contractor;
  final List<(String, String)> people;

  @override
  Widget build(BuildContext context) {

    List<Widget> peopleWidgets = [];
    for ((String, String) person in people) {
      peopleWidgets.add(
        Text(
          '${person.$1}: ${person.$2}',
          style: MyAppStyle.regularFont,
        ),
      );
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) {
              // TODO: GET SELECTED CHECKLIST INFO
              // AND PASS IT TO THE CHECKLIST PAGE?
              return const MyChecklistPage();
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16), // .fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: READ FROM WORKSITE
            Text(
              workname,
              style: MyAppStyle.largeFont,
            ),
            Text(
              intId,
              style: MyAppStyle.regularFont,
            ),
            Text(
              'Contractor: $contractor',
              style: MyAppStyle.regularFont,
            ),
            Text(
              'Start Date: ${currDay.year}-${currDay.month}-${currDay.day}',
              style: MyAppStyle.regularFont,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: peopleWidgets.length,
              itemBuilder: (context, index) {
                return peopleWidgets[index];
              }
            ),
          ],
        ),
      ),
    );
  }
}