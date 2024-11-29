// View Imports:

import 'package:build_stats_flutter/resources/app_colours.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/checklist/my_checklist_page.dart';
import 'package:build_stats_flutter/views/worksite/worksites_page_view.dart';
import 'package:flutter/material.dart';

class MyLandingPage extends StatelessWidget {
  const MyLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              // color: MyAppColours.g5,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  MyAppColours.g3,
                  MyAppColours.g5
                ]
              ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'SiteReady',
                      style: MyAppStyle.titleFont,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Image.asset(
                        'assets/images/site_ready_logo.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 0.0,
                //   width: 0.0,
                // ),
                Column(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 40,
                      child: TextButton(
                        style: MyAppStyle.titleButtonStyle,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const MyWorksitesPage();
                          }));
                        },
                        child: const Text(
                          'Office',
                          style: MyAppStyle.titleScreenSmallFont,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 120,
                      height: 40,
                      child: TextButton(
                        style: MyAppStyle.titleButtonStyle,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const MyChecklistPage();
                          }));
                        },
                        child: const Text(
                          'Worksite',
                          style: MyAppStyle.titleScreenSmallFont,
                        ),
                      ),
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