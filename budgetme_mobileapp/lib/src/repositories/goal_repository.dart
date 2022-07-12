/*
BudgetMe iOS & Android App
Copyright (C) 2022 Carlton Aikins

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Project imports:
import 'package:budgetme/src/models/goal.dart';

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
