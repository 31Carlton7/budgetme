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

import 'package:flutter/material.dart';

import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/dark_theme/dark_color_palette.dart';
import 'package:budgetme/src/config/themes/text_theme.dart';

ThemeData darkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    textTheme: BudgetMeTextTheme.theme(base),
    primaryIconTheme: const IconThemeData(size: 24, color: BudgetMeDarkColors.white),
    brightness: Brightness.light,
    dividerTheme: DividerThemeData(
      space: 0,
      thickness: 0.25,
      color: BudgetMeDarkColors.gray[200]!,
    ),
    iconTheme: const IconThemeData(
      color: BudgetMeDarkColors.white,
      size: 24.0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: BudgetMeDarkColors.gray[900],
      contentTextStyle: TextStyle(
        color: BudgetMeDarkColors.black,
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
        letterSpacing: 0.0,
        height: 1.5,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      // 23 for height 65, 18 for height 50
      contentPadding: const EdgeInsets.all(15),
      filled: true,
      isCollapsed: true,
      fillColor: BudgetMeDarkColors.gray[600],
      hoverColor: BudgetMeDarkColors.gray[400],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kSmallBorderRadius),
        borderSide: const BorderSide(
          color: BudgetMeDarkColors.transparent,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kSmallBorderRadius),
        borderSide: const BorderSide(
          color: BudgetMeDarkColors.transparent,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kSmallBorderRadius),
        borderSide: const BorderSide(
          color: BudgetMeDarkColors.transparent,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kSmallBorderRadius),
        borderSide: const BorderSide(
          color: BudgetMeDarkColors.transparent,
          width: 1.5,
        ),
      ),
      helperStyle: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        color: BudgetMeDarkColors.black,
        height: 1.5,
      ),
      hintStyle: TextStyle(
        fontSize: 15.0,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        color: BudgetMeDarkColors.gray[600],
        height: 1.5,
      ),
      labelStyle: const TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        color: BudgetMeDarkColors.black,
        height: 1.5,
      ),
      prefixStyle: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        color: BudgetMeDarkColors.colorScheme.secondaryContainer,
        height: 1.5,
      ),
      suffixStyle: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        color: BudgetMeDarkColors.colorScheme.secondaryContainer,
        height: 1.5,
      ),
    ),
    cardTheme: CardTheme(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      ),
      elevation: 0.0,
      color: BudgetMeDarkColors.gray[800],
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: BudgetMeDarkColors.gray[900],
      modalBackgroundColor: BudgetMeDarkColors.gray[900],
      modalElevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kLargeBorderRadius))),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: BudgetMeDarkColors.primary),
    appBarTheme: AppBarTheme(
      color: BudgetMeDarkColors.transparent,
      foregroundColor: BudgetMeDarkColors.transparent,
      titleTextStyle: BudgetMeTextTheme.theme(base).headline4,
      toolbarTextStyle: BudgetMeTextTheme.theme(base).headline5,
      elevation: 0.0,
    ),
    cardColor: BudgetMeDarkColors.gray[800],
    colorScheme: BudgetMeDarkColors.colorScheme,
    primaryColor: BudgetMeDarkColors.primary,
    errorColor: BudgetMeDarkColors.error,
    canvasColor: BudgetMeDarkColors.gray[900],
    splashColor: BudgetMeDarkColors.transparent,
    highlightColor: BudgetMeDarkColors.transparent,
    backgroundColor: BudgetMeDarkColors.gray[900],
    scaffoldBackgroundColor: BudgetMeDarkColors.gray[900],
    dividerColor: BudgetMeDarkColors.gray[200]!,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: BudgetMeDarkColors.gray[800],
      selectedItemColor: BudgetMeDarkColors.primary,
      selectedLabelStyle: BudgetMeTextTheme.theme(base).bodyText2?.copyWith(fontWeight: FontWeight.w500),
      unselectedLabelStyle: BudgetMeTextTheme.theme(base).bodyText2?.copyWith(fontWeight: FontWeight.w500),
      backgroundColor: BudgetMeDarkColors.gray[900],
      type: BottomNavigationBarType.fixed,
      elevation: 0.0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );
}
