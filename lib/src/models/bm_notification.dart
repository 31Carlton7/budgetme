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
