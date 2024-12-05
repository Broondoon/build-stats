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
    User user = Injector.appInstance.get<MyAppState>(dependencyName: AppStateDependancyName).currUser;

      try {
        await Injector.appInstance.get<DataSync>().checkCacheSync(user);
      } catch (e) {
        if (Injector.appInstance.get<MyAppState>(dependencyName: AppStateDependancyName).OFFLINE) {
          // Now... what do we do here?
          // If we catch, basically checkCacheSync() doesn't complete.
          // Which means we won't be getting an updated user from the funct.
          // But... it's not as if this original code was using it. No harm no foul?
        }
        else {
          rethrow;
        }
      }
    });
  }

  @override
  dynamic startDataSyncTimer() => throw UnimplementedError();
}
