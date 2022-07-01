import 'dart:convert';

class Transaction {
  String id;
  String title;
  int amount;
  DateTime time;
  bool remove;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.time,
    required this.remove,
  });

  Transaction copyWith({
    String? id,
    String? title,
    int? amount,
    DateTime? time,
    bool? remove,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      time: time ?? this.time,
      remove: remove ?? this.remove,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'time': time.millisecondsSinceEpoch,
      'remove': remove,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount: map['amount']?.toInt() ?? 0,
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      remove: map['remove'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) => Transaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transaction(id: $id, title: $title, amount: $amount, time: $time, remove: $remove)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaction &&
        other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.time == time &&
        other.remove == remove;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ amount.hashCode ^ time.hashCode ^ remove.hashCode;
  }
}
