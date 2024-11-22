import 'package:build_stats_flutter/views/overlay/new_cat_overlay_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// tbh I have no clue what this does
class NewCatState {
  NewCatState(
    this.name
  );
  
  final String name;
}

class NewCatNotifier extends StateNotifier<NewCatState> {
  NewCatNotifier() : super(NewCatState(''));

  void makeNewCat(String newName) {
    state = NewCatState(newName);
  }
}

final newCatProvider = StateNotifierProvider<NewCatNotifier, NewCatState>((ref) {
  return NewCatNotifier();
});