import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

const String kAppTitle = 'BudgetMe';

const String kVersionNumber = 'Version v0.0.1 (1)';

const String kFontFamily = 'Inter';

const String kAppIcon = 'assets/app_icons/store_icon_a.png';

const double kLargePadding = 27.0;

const double kDefaultPadding = 16.0;

const double kMediumPadding = 12.0;

const double kSmallPadding = 10.0;

const double kDefaultBorderRadius = 10.0;

const double kSmallBorderRadius = 7.0;

const double kLargeBorderRadius = 16.0;

String formatAmount(int amount, Currency currency) => intl.NumberFormat.simpleCurrency(
      name: currency.code,
      decimalDigits: 0,
    ).format(amount);

Color? lightDarkModeDefaultTextColor(ThemeData themeData) {
  if (themeData.brightness == Brightness.dark) {
    return BudgetMeLightColors.white;
  } else {
    return BudgetMeLightColors.black;
  }
}

const defaultCurrency = <String, dynamic>{
  'code': 'USD',
  'name': 'United States Dollar',
  'symbol': '\$',
  'flag': 'USD',
  'decimal_digits': 2,
  'number': 840,
  'name_plural': 'US dollars',
  'thousands_separator': ',',
  'decimal_separator': '.',
  'space_between_amount_and_symbol': false,
  'symbol_on_left': true,
};

String generalGoalImagePath = '';

String goalLocalImagePath(Goal goal) {
  return generalGoalImagePath.substring(0, generalGoalImagePath.indexOf('/Documents')) + '/tmp' + goal.image;
}

String goalImagePath(Goal goal) {
  return goal.image.contains('image_picker') ? goalLocalImagePath(goal) : generalGoalImagePath + goal.image;
}

Goal defGoal = Goal(
  id: '0',
  title: '',
  deadline: DateTime.now(),
  requiredAmount: 10,
  currentAmount: 0,
  transactions: [],
  currency: Currency.from(json: defaultCurrency),
  image: '',
);

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}
