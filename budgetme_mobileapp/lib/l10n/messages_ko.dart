// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, always_declare_return_types

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String MessageIfAbsent(String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ko';

  static m0(goalTitle) => "Are you sure want to delete your ${goalTitle} goal?";

  static m1(currency, number) => "Please enter a value less than your required amount of ${currency}${number}";

  static m2(amount) => "Unlock unlimited Goals for just 2.99 USD 😆 Pay once, Pay forever!";

  static m3(month) => "${month} Dashboard";

  static m4(amount) => "Unlock your true self with unlimited goals for a one-time purchase of just 2.99 USD! 😎 Note: Prices may vary in other currencies";

  static m5(percent) => "You are ${percent}% of the way there!";

  static m6(versionNumber) => "Version ${versionNumber}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("About"),
    "add" : MessageLookupByLibrary.simpleMessage("Add"),
    "adjustMonthlySpendingLimit" : MessageLookupByLibrary.simpleMessage("Adjust Monthly Spending Limit"),
    "areYouSureDelQ" : m0,
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "create" : MessageLookupByLibrary.simpleMessage("Create"),
    "currentProgress" : MessageLookupByLibrary.simpleMessage("Current Progress"),
    "dashboard" : MessageLookupByLibrary.simpleMessage("Dashboard"),
    "days" : MessageLookupByLibrary.simpleMessage("Days"),
    "delete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteGoal" : MessageLookupByLibrary.simpleMessage("Delete Goal"),
    "deleteGoalQ" : MessageLookupByLibrary.simpleMessage("Delete Goal?"),
    "device" : MessageLookupByLibrary.simpleMessage("Device"),
    "done" : MessageLookupByLibrary.simpleMessage("Done"),
    "edit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "editGoal" : MessageLookupByLibrary.simpleMessage("Edit Goal"),
    "finish" : MessageLookupByLibrary.simpleMessage("Finish"),
    "hideFrom" : MessageLookupByLibrary.simpleMessage("Hide from history"),
    "hours" : MessageLookupByLibrary.simpleMessage("Hours"),
    "howMuchNeededQ" : MessageLookupByLibrary.simpleMessage("How much money is needed?"),
    "howMuchSavedQ" : MessageLookupByLibrary.simpleMessage("How much money is currently saved?"),
    "minutes" : MessageLookupByLibrary.simpleMessage("Minutes"),
    "monthlySavings" : MessageLookupByLibrary.simpleMessage("Monthly Savings"),
    "months" : MessageLookupByLibrary.simpleMessage("Months"),
    "newMonthlySpendingLimit" : MessageLookupByLibrary.simpleMessage("New Monthly Spending Limit"),
    "next" : MessageLookupByLibrary.simpleMessage("Next"),
    "noResults" : MessageLookupByLibrary.simpleMessage("No Results"),
    "noTransactions" : MessageLookupByLibrary.simpleMessage("No transactions have been made...yet!"),
    "pleaseEnterLess" : m1,
    "pleaseNote" : MessageLookupByLibrary.simpleMessage("Please note that increasing your weekly spending will make it harder to achieve goals and it is discouraged."),
    "prefCurr" : MessageLookupByLibrary.simpleMessage("Select your Preferred Currency"),
    "pressThePBtn" : MessageLookupByLibrary.simpleMessage("Press the purple button to create a new Goal!"),
    "privacyPolicy" : MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "profile" : MessageLookupByLibrary.simpleMessage("Profile"),
    "purchase" : MessageLookupByLibrary.simpleMessage("Purchase"),
    "purchasePro" : MessageLookupByLibrary.simpleMessage("Purchase Pro😎"),
    "purchaseProText" : m2,
    "remainingBalance" : MessageLookupByLibrary.simpleMessage("Remaining Balance"),
    "remove" : MessageLookupByLibrary.simpleMessage("Remove"),
    "save" : MessageLookupByLibrary.simpleMessage("Save"),
    "savingForQ" : MessageLookupByLibrary.simpleMessage("What are you saving for?"),
    "savingsGoals" : MessageLookupByLibrary.simpleMessage("Savings Goals"),
    "search" : MessageLookupByLibrary.simpleMessage("Search"),
    "searchForImage" : MessageLookupByLibrary.simpleMessage("Search for images on UnSplash using the search bar"),
    "seconds" : MessageLookupByLibrary.simpleMessage("Seconds"),
    "seeAll" : MessageLookupByLibrary.simpleMessage("See All"),
    "selectImage" : MessageLookupByLibrary.simpleMessage("Select Image"),
    "settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "skip" : MessageLookupByLibrary.simpleMessage("Skip"),
    "statistics" : m3,
    "support" : MessageLookupByLibrary.simpleMessage("Support"),
    "timeLeft" : MessageLookupByLibrary.simpleMessage("Time Left"),
    "totalSaved" : MessageLookupByLibrary.simpleMessage("Total Saved"),
    "transaction" : MessageLookupByLibrary.simpleMessage("Transaction"),
    "transactionHistory" : MessageLookupByLibrary.simpleMessage("Transaction History"),
    "unlimitedGoals" : MessageLookupByLibrary.simpleMessage("Unlimited Goals"),
    "unlockText" : m4,
    "userPercentProgress" : m5,
    "vacation" : MessageLookupByLibrary.simpleMessage("Vacation"),
    "version" : m6,
    "web" : MessageLookupByLibrary.simpleMessage("Web"),
    "whenDeadlineQ" : MessageLookupByLibrary.simpleMessage("When is the deadline?"),
    "years" : MessageLookupByLibrary.simpleMessage("Years")
  };
}
