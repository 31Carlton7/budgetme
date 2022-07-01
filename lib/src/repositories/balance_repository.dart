import 'package:budgetme/src/config/constants.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BalanceRepository extends ChangeNotifier {
  var _remainingBalance = 0.0;
  var _totalMoneySaved = 0.0;
  var _balance = 500.0;
  var _moneySaved = 0.0;
  var _defaultCurrency = defaultCurrency;

  int get balance => _balance.toInt();
  int get moneySaved => _moneySaved.toInt();
  int get remainingBalance => _remainingBalance.toInt();
  int get totalMoneySaved => _totalMoneySaved.toInt();
  Map<String, dynamic> get currency => _defaultCurrency;

  Future<void> setCurrency(Currency currency) async {
    final box = Hive.box('budgetme');

    _defaultCurrency = currency.toJson();
    await box.put('default_currency', _defaultCurrency);
    notifyListeners();
  }

  Future<void> setMoneySaved(double amount) async {
    final box = Hive.box('budgetme');

    _moneySaved = amount;
    await box.put('money_saved', _moneySaved);
    notifyListeners();
  }

  Future<void> setBalance(double amount) async {
    final box = Hive.box('budgetme');

    _balance = amount;
    await box.put('balance', _balance);
    notifyListeners();
  }

  Future<void> increaseRemainingBalance(double amount) async {
    final box = Hive.box('budgetme');

    _remainingBalance += amount;
    await box.put('remaining_balance', _remainingBalance);
    notifyListeners();
  }

  Future<void> decreaseRemainingBalance(double amount) async {
    final box = Hive.box('budgetme');

    _remainingBalance -= amount;

    if (_remainingBalance < 0) _remainingBalance = 0;

    await box.put('remaining_balance', _remainingBalance);
    notifyListeners();
  }

  Future<void> increaseTotalMoneySaved(double amount) async {
    final box = Hive.box('budgetme');

    _totalMoneySaved += amount;
    await box.put('total_money_saved', _totalMoneySaved);
    notifyListeners();
  }

  Future<void> decreaseTotalMoneySaved(double amount) async {
    final box = Hive.box('budgetme');

    _totalMoneySaved -= amount;
    await box.put('total_money_saved', _totalMoneySaved);
    notifyListeners();
  }

  void loadData() {
    final box = Hive.box('budgetme');

    final now = DateTime.now();

    if (now.day == 1) {
      _remainingBalance = box.get('balance', defaultValue: 500.0);
      _totalMoneySaved = box.get('money_saved', defaultValue: 0.0);
    } else {
      _remainingBalance = box.get('remaining_balance', defaultValue: 500.0);
      _totalMoneySaved = box.get('total_money_saved', defaultValue: 0.0);
    }
  }
}
