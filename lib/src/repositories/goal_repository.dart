import 'dart:convert';

import 'package:budgetme/src/models/goal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GoalRepository extends StateNotifier<List<Goal>> {
  GoalRepository() : super([]);

  Future<void> addGoal(Goal goal) async {
    state = [goal, ...state];
    await _saveData();
  }

  Future<void> removeGoal(Goal goal) async {
    state = [
      for (var item in state)
        if (item.id != goal.id) item,
    ];

    await _saveData();
  }

  Future<void> updateGoal(Goal goal) async {
    state[state.indexWhere((gl) => gl.id == goal.id)] = goal;

    await _saveData();
  }

  Future<void> _saveData() async {
    final box = Hive.box('budgetme');

    List<String> goals = state.map((e) => json.encode(e.toMap())).toList();

    await box.put('goals', goals);
  }

  void loadData() {
    var box = Hive.box('budgetme');

    /// Removes all [Goal] (s) from device.
    // box.delete('goals');

    List<String> goals = box.get('goals', defaultValue: <String>[]);
    var maps = <Map<String, dynamic>>[];

    for (String item in goals) {
      maps.add(json.decode(item) as Map<String, dynamic>);
    }

    for (Map<String, dynamic> item in maps) {
      state.add(Goal.fromMap(item));
    }
  }
}
