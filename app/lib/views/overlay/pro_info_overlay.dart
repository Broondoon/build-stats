import 'package:build_stats_flutter/views/overlay/overlay_interface.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjInfo extends StatefulWidget implements OverlayImpInterface {
  const ProjInfo({
    super.key,
  });

  // TODO: fix this so that it actually does somthing, because as now it's BROKEN
  @override
  void timeToClose() {}

  @override
  State<ProjInfo> createState() => _NewProjInfoState();
}

class _NewProjInfoState extends State<ProjInfo> {

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return const Text('todo');
  }
}