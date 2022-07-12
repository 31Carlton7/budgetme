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

// Project imports:
import 'budgetme_localizations.dart';

class BudgetMeLocalizationsDelegate extends LocalizationsDelegate<BudgetMeLocalizations> {
  const BudgetMeLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['ar', 'en', 'zh', 'ko', 'ja', 'de', 'he', 'fr', 'pt', 'ru', 'es'].contains(locale.languageCode);

  @override
  Future<BudgetMeLocalizations> load(Locale locale) => BudgetMeLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<BudgetMeLocalizations> old) => false;
}
