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

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:budgetme/src/models/transaction.dart';
import 'package:currency_picker/currency_picker.dart';

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

  String photographer;

  String photographerLink;

  Goal({
    required this.id,
    required this.title,
    required this.deadline,
    required this.requiredAmount,
    required this.currentAmount,
    required this.transactions,
    required this.currency,
    required this.image,
    required this.photographer,
    required this.photographerLink,
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
    String? photographer,
    String? photographerLink,
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
      photographer: photographer ?? this.photographer,
      photographerLink: photographerLink ?? this.photographerLink,
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
      'photographer': photographer,
      'photographerLink': photographerLink,
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
        photographer: map['photographer'] ?? '',
        photographerLink: map['photographerLink'] ?? '');
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
        other.photographer == photographer &&
        other.photographerLink == photographerLink &&
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
        photographer.hashCode ^
        photographerLink.hashCode ^
        image.hashCode;
  }
}
