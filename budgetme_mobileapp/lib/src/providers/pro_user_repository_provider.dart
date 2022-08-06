import 'package:budgetme/src/repositories/pro_user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final proUserRepositoryProvider = Provider<ProUserRepository>((ref) {
  return ProUserRepository();
});
