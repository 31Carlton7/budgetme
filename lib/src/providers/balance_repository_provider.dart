import 'package:budgetme/src/repositories/balance_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final balanceRepositoryProvider = ChangeNotifierProvider<BalanceRepository>((ref) {
  return BalanceRepository();
});
