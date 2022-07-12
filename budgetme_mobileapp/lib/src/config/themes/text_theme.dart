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

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';

class BudgetMeTextTheme {
  static const double kH00 = 40.0;
  static const double kH0 = 34.0;
  static const double kH1 = 27.0;
  static const double kH2 = 24.0;
  static const double kH3 = 22.0;
  static const double kH4 = 17.0;
  static const double kH5 = 14.0;
  static const double kH6 = 12.0;

  static const String kFontFamily = 'Poppins';
  static const double kLineHeight = 1.5;
  static const double kLetterSpacing = -0.41;

  static TextTheme theme(ThemeData base) {
    return base.textTheme.copyWith(
      headline1: TextStyle(
        fontFamily: kFontFamily,
        fontWeight: FontWeight.w700,
        fontSize: kH00,
        height: kLineHeight,
        letterSpacing: kLetterSpacing,
        color: lightDarkModeDefaultTextColor(base),
      ),
      headline2: TextStyle(
        fontFamily: kFontFamily,
        fontWeight: FontWeight.w700,
        fontSize: kH0,
        height: kLineHeight,
        letterSpacing: kLetterSpacing,
        color: lightDarkModeDefaultTextColor(base),
      ),
      headline3: TextStyle(
        fontFamily: kFontFamily,
        fontWeight: FontWeight.w800,
        fontSize: kH1,
        height: kLineHeight,
        letterSpacing: kLetterSpacing,
        color: lightDarkModeDefaultTextColor(base),
      ),
      headline4: TextStyle(
        fontFamily: kFontFamily,
        fontWeight: FontWeight.w600,
        fontSize: kH2,
        height: kLineHeight,
        letterSpacing: kLetterSpacing,
        color: lightDarkModeDefaultTextColor(base),
      ),
      headline5: TextStyle(
        fontFamily: kFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: kH3,
        height: kLineHeight,
        letterSpacing: kLetterSpacing,
        color: lightDarkModeDefaultTextColor(base),
      ),
      headline6: TextStyle(
        fontFamily: kFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: kH4,
        height: kLineHeight,
        letterSpacing: kLetterSpacing,
        color: lightDarkModeDefaultTextColor(base),
      ),
      bodyText1: TextStyle(
        fontFamily: kFontFamily,
        fontWeight: FontWeight.w400,
        fontSize: kH5,
        height: kLineHeight,
        letterSpacing: kLetterSpacing,
        color: lightDarkModeDefaultTextColor(base),
      ),
      bodyText2: TextStyle(
        fontFamily: kFontFamily,
        fontWeight: FontWeight.w400,
        fontSize: kH6,
        height: kLineHeight,
        letterSpacing: kLetterSpacing,
        color: lightDarkModeDefaultTextColor(base),
      ),
      button: TextStyle(
        fontFamily: kFontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 17.0,
        height: kLineHeight,
        letterSpacing: kLetterSpacing,
        color: lightDarkModeDefaultTextColor(base),
      ),
      caption: TextStyle(
        fontFamily: kFontFamily,
        fontWeight: FontWeight.w400,
        fontSize: kH6,
        height: kLineHeight,
        letterSpacing: kLetterSpacing,
        color: lightDarkModeDefaultTextColor(base),
      ),
      overline: TextStyle(
        fontFamily: kFontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 10.0,
        height: kLineHeight,
        letterSpacing: kLetterSpacing,
        color: lightDarkModeDefaultTextColor(base),
      ),
    );
  }
}
