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

class BMNotification {
  /// Title of notification
  String title;

  /// Body of notification
  String body;

  BMNotification({
    required this.title,
    required this.body,
  });

  BMNotification copyWith({
    String? title,
    String? body,
  }) {
    return BMNotification(
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }

  factory BMNotification.fromMap(Map<String, dynamic> map) {
    return BMNotification(
      title: map.entries.first.key,
      body: map.entries.first.value,
    );
  }

  String toJson() => json.encode(toMap());

  factory BMNotification.fromJson(String source) => BMNotification.fromMap(json.decode(source));

  @override
  String toString() => 'Notification(title: $title, body: $body)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BMNotification && other.title == title && other.body == body;
  }

  @override
  int get hashCode => title.hashCode ^ body.hashCode;
}
