import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProUserRepository extends ChangeNotifier {
  bool _proUser = false;

  bool get proUser => _proUser;

  Future<void> setProUser() async {
    var box = Hive.box('budgetme');

    _proUser = true;

    await box.put('pro_user', _proUser);

    notifyListeners();
  }

  void loadData() {
    var box = Hive.box('budgetme');

    /// Removes [pro_user] from device.
    // box.delete('pro_user');

    bool userIsPro = box.get('pro_user', defaultValue: false);

    _proUser = userIsPro;
  }
}
