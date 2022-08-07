import 'package:budgetme/src/repositories/pro_user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final proUserRepositoryProvider = ChangeNotifierProvider<ProUserRepository>((ref) {
  return ProUserRepository();
});
