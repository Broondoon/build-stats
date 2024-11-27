import 'dart:async';
import 'dart:isolate';

import 'package:build_stats_flutter/model/entity/user.dart';
import 'package:build_stats_flutter/model/storage/data_sync/data_sync.dart';
import 'package:build_stats_flutter/views/state_controller.dart';
import 'package:injector/injector.dart';
import 'package:shared/app_strings.dart';

abstract class DataSyncTimerInterface {
  Timer dataSyncFunction();
  dynamic startDataSyncTimer();
}

//Base timer for the datasync. We might need multiple versions for different platforms, so precursory setup is present.
class DataSyncTimerBase implements DataSyncTimerInterface{

  DataSyncTimerBase();
  
  @override
  Timer dataSyncFunction(){
   return Timer.periodic(Duration(seconds: DataSyncTimerDurationSeconds), (timer) async {
    User user = Injector.appInstance.get<MyAppState>().currUser;
    await Injector.appInstance.get<DataSync>().checkCacheSync(user);
  });
  }

  @override
  dynamic startDataSyncTimer() => throw UnimplementedError();
}
