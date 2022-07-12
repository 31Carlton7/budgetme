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
