import 'package:build_stats_flutter/resources/app_colours.dart';
import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/////////////////////////////////////////////////////////////////////////////

class DateRow extends StatefulWidget {
  const DateRow({
    super.key,
    // required this.startDay,
    // required this.pageDay,
    // required this.onDateChange,
  });

  // final Checklist? currChecklist;
  // final DateTime startDay;
  // final DateTime pageDay;
  // final ValueChanged<DateTime> onDateChange;

  @override
  State<DateRow> createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  // late DateTime _startDay;
  // late DateTime _currDay;

  // @override
  // void initState() {
  //   super.initState();
  //   // _startDay = widget.startDay;
  //   // _currDay = widget.pageDay;
  // }

  // void changeDateTime(bool increment) {
  //   setState(() {
  //     if (increment) {
  //       _currDay = _currDay.add(const Duration(days: 1));
  //     }
  //     else {
  //       if (_currDay.isAfter(_startDay)) {
  //         _currDay = _currDay.subtract(const Duration(days: 1));
  //       }
  //     }

  //     // widget.onDateChange(_currDay);
      
  //   });
  // }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyAppColours.g5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 10,
            onPressed: () {
              // changeDateTime(false);
              Provider.of<MyAppState>(
                context, 
                listen: false
              ).changePageDay(false);
            },
          ),
      
          Consumer<MyAppState>(
            builder: (
              context, 
              appState, 
              child,
            ) {
              return Text(
                'Date: ${appState.pageDay.year}-${appState.pageDay.month}-${appState.pageDay.day}',
                style: MyAppStyle.regularFont,
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            iconSize: 10,
            onPressed: () {
              // changeDateTime(true);
              Provider.of<MyAppState>(
                context, 
                listen: false
              ).changePageDay(true);
            },
          ),
        ],
      ),
    );
  }
}