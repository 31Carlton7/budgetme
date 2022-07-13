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
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:currency_picker/currency_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';

// Project imports:
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/goal.dart';

const String kAppTitle = 'BudgetMe';

const String kAppVersionNumber = 'v1.0.3 (4)';

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

var defaultCurrency = <String, dynamic>{
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
  photographer: '',
  photographerLink: '',
);

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}

bool get localeIsEn => Platform.localeName.substring(0, 2) == 'en';
bool isRTL(BuildContext context) => Directionality.of(context) == TextDirection.RTL;
