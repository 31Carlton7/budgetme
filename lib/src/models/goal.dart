import 'dart:convert';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/foundation.dart';

import 'package:budgetme/src/models/transaction.dart';

class Goal {
  /// UUID v4 to differentiate all goals.
  String id;

  /// Title/Name of Goal.
  String title;

  /// When the Goal is due, or last day to keep
  /// adding money.
  DateTime deadline;

  /// Amount of money in which the user is trying
  /// to save.
  int requiredAmount;

  /// Amount of money in which the user has saved
  /// towards the goal at that moment.
  int currentAmount;

  /// List of transactions that have had an effect
  /// on how much the [currentAmount] is at.
  List<Transaction> transactions;

  /// The currency in which the user is saving
  /// money in.
  Currency currency;

  /// Local image of what the user is trying to
  /// save.
  String image;

  Goal({
    required this.id,
    required this.title,
    required this.deadline,
    required this.requiredAmount,
    required this.currentAmount,
    required this.transactions,
    required this.currency,
    required this.image,
  });

  int get percentCompleted => ((this.currentAmount / this.requiredAmount) * 100).toInt();

  Goal copyWith({
    String? id,
    String? title,
    DateTime? deadline,
    int? requiredAmount,
    int? currentAmount,
    List<Transaction>? transactions,
    Currency? currency,
    String? image,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      deadline: deadline ?? this.deadline,
      requiredAmount: requiredAmount ?? this.requiredAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      transactions: transactions ?? this.transactions,
      currency: currency ?? this.currency,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'deadline': deadline.millisecondsSinceEpoch,
      'requiredAmount': requiredAmount,
      'currentAmount': currentAmount,
      'transactions': transactions.map((x) => x.toMap()).toList(),
      'currency': currency.toJson(),
      'image': image,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      deadline: DateTime.fromMillisecondsSinceEpoch(map['deadline']),
      requiredAmount: map['requiredAmount']?.toInt() ?? 0,
      currentAmount: map['currentAmount']?.toInt() ?? 0,
      transactions: List<Transaction>.from(map['transactions']?.map((x) => Transaction.fromMap(x))),
      currency: Currency.from(json: map['currency']),
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Goal.fromJson(String source) => Goal.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Goal(id: $id, title: $title, deadline: $deadline, requiredAmount: $requiredAmount, currentAmount: $currentAmount, transactions: $transactions, currency: $currency, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Goal &&
        other.id == id &&
        other.title == title &&
        other.deadline == deadline &&
        other.requiredAmount == requiredAmount &&
        other.currentAmount == currentAmount &&
        listEquals(other.transactions, transactions) &&
        other.currency == currency &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        deadline.hashCode ^
        requiredAmount.hashCode ^
        currentAmount.hashCode ^
        transactions.hashCode ^
        currency.hashCode ^
        image.hashCode;
  }
}
