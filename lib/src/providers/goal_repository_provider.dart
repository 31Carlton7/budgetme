import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/repositories/goal_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goalRepositoryProvider = StateNotifierProvider<GoalRepository, List<Goal>>((ref) {
  return GoalRepository();
});
