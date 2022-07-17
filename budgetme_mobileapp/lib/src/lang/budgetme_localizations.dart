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
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:budgetme/src/lang/budgetme_localizations_delegate.dart';
import '../../l10n/messages_all.dart';

// We have to build this file before we uncomment the next import line,
// and we'll get to that shortly
// import '../../l10n/messages_all.dart';

class BudgetMeLocalizations {
  /// Initialize localization systems and messages
  static const LocalizationsDelegate<BudgetMeLocalizations> delegate = BudgetMeLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static Future<BudgetMeLocalizations> load(Locale locale) async {
    // If we're given "en_US", we'll use it as-is. If we're
    // given "en", we extract it and use it.
    final String localeName =
        locale.countryCode == null || locale.countryCode!.isEmpty ? locale.languageCode : locale.toString();

    // We make sure the locale name is in the right format e.g.
    // converting "en-US" to "en_US".
    final String canonicalLocaleName = Intl.canonicalizedLocale(localeName);

    // Load localized messages for the current locale.
    // await initializeMessages(canonicalLocaleName);
    // We'll uncomment the above line after we've built our messages file

    // Force the locale in Intl.
    Intl.defaultLocale = canonicalLocaleName;

    await initializeMessages(canonicalLocaleName);

    return BudgetMeLocalizations();
  }

  /// Retrieve localization resources for the widget tree
  /// corresponding to the given `context`
  static BudgetMeLocalizations? of(BuildContext context) =>
      Localizations.of<BudgetMeLocalizations>(context, BudgetMeLocalizations);

  String get dashboard => Intl.message(
        'Dashboard',
        name: 'dashboard',
      );

  String get monthlySavings => Intl.message(
        'Monthly Savings',
        name: 'monthlySavings',
      );

  String get remainingBalance => Intl.message(
        'Remaining Balance',
        name: 'remainingBalance',
      );

  String get totalSaved => Intl.message(
        'Total Saved',
        name: 'totalSaved',
      );

  String get savingsGoals => Intl.message(
        'Savings Goals',
        name: 'savingsGoals',
      );

  String get currentProgress => Intl.message(
        'Current Progress',
        name: 'currentProgress',
      );

  String userPercentProgress(String percent) => Intl.message(
        'You are $percent of the way there!',
        name: 'userPercentProgress',
        args: [percent],
      );

  String get timeLeft => Intl.message(
        'Time Left',
        name: 'timeLeft',
      );

  String get years => Intl.message(
        'Years',
        name: 'years',
      );

  String get months => Intl.message(
        'Months',
        name: 'months',
      );

  String get days => Intl.message(
        'Days',
        name: 'days',
      );

  String get hours => Intl.message(
        'Hours',
        name: 'hours',
      );

  String get minutes => Intl.message(
        'Minutes',
        name: 'minutes',
      );

  String get seconds => Intl.message(
        'Seconds',
        name: 'seconds',
      );

  String get transactionHistory => Intl.message(
        'Transaction History',
        name: 'transactionHistory',
      );

  String get seeAll => Intl.message(
        'See All',
        name: 'seeAll',
      );

  String get transaction => Intl.message(
        'Transaction',
        name: 'transaction',
      );

  String get editGoal => Intl.message(
        'Edit Goal',
        name: 'editGoal',
      );

  String get deleteGoal => Intl.message(
        'Delete Goal',
        name: 'deleteGoal',
      );

  String get next => Intl.message(
        'Next',
        name: 'next',
      );

  String get skip => Intl.message(
        'Skip',
        name: 'skip',
      );

  String get cancel => Intl.message(
        'Cancel',
        name: 'cancel',
      );

  String get create => Intl.message(
        'Create',
        name: 'create',
      );

  String get edit => Intl.message(
        'Edit',
        name: 'edit',
      );

  String get save => Intl.message(
        'Save',
        name: 'save',
      );

  String get savingForQ => Intl.message(
        'What are you saving for?',
        name: 'savingForQ',
      );

  String get howMuchNeededQ => Intl.message(
        'How much money is needed?',
        name: 'howMuchNeededQ',
      );

  String get whenDeadlineQ => Intl.message(
        'When is the deadline?',
        name: 'whenDeadlineQ',
      );

  String get howMuchSavedQ => Intl.message(
        'How much money is currently saved?',
        name: 'howMuchSavedQ',
      );

  String get prefCurr => Intl.message(
        'Select your Preferred Currency',
        name: 'prefCurr',
      );

  String get purchasePro => Intl.message(
        'Purchase Pro😎',
        name: 'purchasePro',
      );

  String purchaseProText(String amount) => Intl.message(
        'Unlock unlimited Goals for just $amount 😆 Pay once, Pay forever!',
        name: 'purchaseProText',
        args: [amount],
      );

  String statistics(String month) => Intl.message('$month Dashboard', name: 'statistics', args: [month]);

  String get settings => Intl.message(
        'Settings',
        name: 'settings',
      );

  String get adjustMonthlySpendingLimit => Intl.message(
        'Adjust Monthly Spending Limit',
        name: 'adjustMonthlySpendingLimit',
      );

  String get about => Intl.message(
        'About',
        name: 'about',
      );

  String get privacyPolicy => Intl.message(
        'Privacy Policy',
        name: 'privacyPolicy',
      );

  String get support => Intl.message(
        'Support',
        name: 'support',
      );

  String version(String number) => Intl.message('Version $number', name: 'version', args: [number]);

  String get profile => Intl.message(
        'Profile',
        name: 'profile',
      );

  String get unlimitedGoals => Intl.message(
        'Unlimited Goals',
        name: 'unlimitedGoals',
      );

  String unlockText(String amount) => Intl.message(
        'Unlock your true self with unlimited goals for a one-time purchase of just $amount! 😎 Note: Prices may vary in other currencies',
        name: 'unlockText',
        args: [amount],
      );

  String get purchase => Intl.message(
        'Purchase',
        name: 'purchase',
      );

  String get pleaseNote => Intl.message(
        'Please note that increasing your weekly spending will make it harder to achieve goals and it is discouraged.',
        name: 'pleaseNote',
      );

  String get newMonthlySpendingLimit => Intl.message(
        'New Monthly Spending Limit',
        name: 'newMonthlySpendingLimit',
      );

  String get pressThePBtn => Intl.message(
        'Press the purple button to create a new Goal!',
        name: 'pressThePBtn',
      );

  String get search => Intl.message(
        'Search',
        name: 'search',
      );

  String get finish => Intl.message(
        'Finish',
        name: 'finish',
      );

  String pleaseEnterLess(String currency, String number) =>
      Intl.message('Please enter a value less than your required amount of $currency$number',
          name: 'pleaseEnterLess', args: [currency, number]);

  String get vacation => Intl.message(
        'Vacation',
        name: 'vacation',
      );

  String get web => Intl.message(
        'Web',
        name: 'web',
      );

  String get device => Intl.message(
        'Device',
        name: 'device',
      );

  String get selectImage => Intl.message(
        'Select Image',
        name: 'selectImage',
      );

  String get searchForImage => Intl.message(
        'Search for images on Unsplash using the search bar',
        name: 'searchForImage',
      );

  String get noResults => Intl.message(
        'No Results',
        name: 'noResults',
      );

  String get done => Intl.message(
        'Done',
        name: 'done',
      );

  String get remove => Intl.message(
        'Remove',
        name: 'remove',
      );

  String get add => Intl.message(
        'Add',
        name: 'add',
      );

  String get hideFrom => Intl.message(
        'Hide from history',
        name: 'hideFrom',
      );

  String get delete => Intl.message(
        'Delete',
        name: 'delete',
      );

  String get deleteGoalQ => Intl.message(
        'Delete Goal?',
        name: 'deleteGoalQ',
      );

  String areYouSureDelQ(String goalTitle) =>
      Intl.message('Are you sure want to delete your $goalTitle goal?', name: 'areYouSureDelQ', args: [goalTitle]);

  String get noTransactions => Intl.message(
        'No transactions have been made...yet!',
        name: 'noTransactions',
      );

  String get congratulations => Intl.message(
        'Congratulations on completing your goal! 😆',
        name: 'congratulations',
      );

  String get startNewGoal => Intl.message(
        'Start new goal',
        name: 'startNewGoal',
      );

  String get outOfTime => Intl.message(
        'Out of time!',
        name: 'outOfTime',
      );
}
