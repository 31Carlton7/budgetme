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

import 'package:budgetme/src/models/bm_notification.dart';
import 'package:hive/hive.dart';

class NotificationsRepository {
  int notificationIndex = 0;

  List<Map<String, String>> _notifications = [
    {'Let\'s save this bread 🍞💸': 'Anytime is a good time to save money, so why not now?'},
    {
      '🚨 Time to save! 🚨':
          '"Saving - for anything - requires us to not get things now so that we can get bigger ones later." - Jean Chatzky'
    },
    {
      'Save now, thank yourself later 🤝':
          '"Someone\'s sitting in the shade today because someone planted a tree a long time ago." - Warren Buffett'
    },
    {
      'Just save 😌 ':
          '"You don\'t have to see the whole staircase, just take the first step." - Martin Luther King, Jr.'
    },
    {'See the vision 👁': 'If you can\'t stop thinking about it, don\'t stop working for it.'},
    {
      'Save now, and save smart 🧠':
          '"Do not save what is left after spending, but spend what is left after saving." - Warren Buffett'
    },
    {'Saving = Succeeding 📈': '"If you\'re saving, you\'re succeeding." - Steve Burkholder'},
  ];

  List<BMNotification> get budgetMeNotifications {
    List<BMNotification> _bmn = [];

    for (var element in _notifications) {
      _bmn.add(BMNotification.fromMap(element));
    }

    return _bmn;
  }

  Future<void> saveNotificationIndex() async {
    var box = Hive.box('budgetme');

    await box.put(notificationIndex, 'notification_index');
  }

  void loadData() async {
    var box = Hive.box('budgetme');

    /// Removes [NotificationIndex] from device.
    // box.delete('notification_index');

    int index = box.get('notificationIndex', defaultValue: 0);

    notificationIndex = index;
  }
}
