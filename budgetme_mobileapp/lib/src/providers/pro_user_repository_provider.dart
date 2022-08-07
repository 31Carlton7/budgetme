// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:budgetme/src/repositories/pro_user_repository.dart';

final proUserRepositoryProvider = ChangeNotifierProvider<ProUserRepository>((ref) {
  return ProUserRepository();
});
