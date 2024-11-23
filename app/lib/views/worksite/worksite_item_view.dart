// View Imports:

import 'package:build_stats_flutter/main.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:flutter/material.dart';

class WorksiteItem extends StatelessWidget {
  const WorksiteItem({
    super.key,
    required this.context,
    required this.numWorksites,
    required this.currDay,
  });

  final BuildContext context;
  final int numWorksites;
  final DateTime currDay;

  @override
  Widget build(BuildContext context) {
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
              "Worksite $numWorksites",
              style: MyAppStyle.regularFont,
            ),
            Text(
              "2024-H92088",
            ),
            Text(
              "Start Date: ${currDay.year}-${currDay.month}-${currDay.day}",
            ),
            Text(
              "General Contractor: Sam Wilkonson",
            ),
            Text(
              "Site Superintendent: Alice McHarris",
            ),
          ],
        ),
      ),
    );
  }
}