//data_sync_timer_stub.dart

import 'dart:isolate';

import 'package:build_stats_flutter/model/storage/data_sync/data_sync_timer_base.dart';

class DataSyncTimer extends DataSyncTimerBase {
  @override
  Future<void> startDataSyncTimer() async {
    //Partial isolate setup present. However, it's gonna require some reworking, since the isolate doesnt defautl have access to caches. 
    //https://chatgpt.com/share/6746763e-53c4-8006-9a9e-5ee2477ed55c
    //possible solution above, but with current time constraints, I don't think it's a priority.
    //final ReceivePort receivePort = ReceivePort();
    //final Isolate isolate = await Isolate.spawn((SendPort sendPort) => 
    super.dataSyncFunction()
    //, receivePort.sendPort);
    //receivePort.listen((data) {
      //print('RECEIVED: $data');
    //})
    ;
  }
}