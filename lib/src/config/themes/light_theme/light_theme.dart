import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/config/themes/text_theme.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: BudgetMeTextTheme.theme(base),
    primaryIconTheme: const IconThemeData(size: 24, color: BudgetMeLightColors.black),
    brightness: Brightness.light,
    dividerTheme: DividerThemeData(
      space: 0,
      thickness: 0.25,
      color: BudgetMeLightColors.gray[400]!,
    ),
    iconTheme: const IconThemeData(
      color: BudgetMeLightColors.black,
      size: 24.0,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: BudgetMeLightColors.white,
      contentTextStyle: TextStyle(
        color: BudgetMeLightColors.black,
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
      fillColor: BudgetMeLightColors.gray[600],
      hoverColor: BudgetMeLightColors.gray[400],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kSmallBorderRadius),
        borderSide: const BorderSide(
          color: BudgetMeLightColors.transparent,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kSmallBorderRadius),
        borderSide: const BorderSide(
          color: BudgetMeLightColors.transparent,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kSmallBorderRadius),
        borderSide: const BorderSide(
          color: BudgetMeLightColors.transparent,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kSmallBorderRadius),
        borderSide: const BorderSide(
          color: BudgetMeLightColors.transparent,
          width: 1.5,
        ),
      ),
      helperStyle: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        color: BudgetMeLightColors.black,
        height: 1.5,
      ),
      hintStyle: TextStyle(
        fontSize: 15.0,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        color: BudgetMeLightColors.gray[600],
        height: 1.5,
      ),
      labelStyle: const TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        color: BudgetMeLightColors.black,
        height: 1.5,
      ),
      prefixStyle: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        color: BudgetMeLightColors.colorScheme.secondaryContainer,
        height: 1.5,
      ),
      suffixStyle: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        color: BudgetMeLightColors.colorScheme.secondaryContainer,
        height: 1.5,
      ),
    ),
    cardTheme: CardTheme(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      ),
      elevation: 0.0,
      color: BudgetMeLightColors.white,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: BudgetMeLightColors.white,
      modalBackgroundColor: BudgetMeLightColors.white,
      modalElevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kLargeBorderRadius))),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: BudgetMeLightColors.primary),
    appBarTheme: AppBarTheme(
      color: BudgetMeLightColors.transparent,
      foregroundColor: BudgetMeLightColors.transparent,
      titleTextStyle: BudgetMeTextTheme.theme(base).headline4,
      toolbarTextStyle: BudgetMeTextTheme.theme(base).headline5,
      elevation: 0.0,
    ),
    colorScheme: BudgetMeLightColors.colorScheme,
    primaryColor: BudgetMeLightColors.primary,
    errorColor: BudgetMeLightColors.error,
    canvasColor: BudgetMeLightColors.gray[100],
    splashColor: BudgetMeLightColors.transparent,
    highlightColor: BudgetMeLightColors.transparent,
    backgroundColor: BudgetMeLightColors.gray[100],
    scaffoldBackgroundColor: BudgetMeLightColors.gray[100],
    dividerColor: BudgetMeLightColors.gray[200]!,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: BudgetMeLightColors.gray[400],
      selectedItemColor: BudgetMeLightColors.primary,
      selectedLabelStyle: BudgetMeTextTheme.theme(base).bodyText2?.copyWith(fontWeight: FontWeight.w500),
      unselectedLabelStyle: BudgetMeTextTheme.theme(base).bodyText2?.copyWith(fontWeight: FontWeight.w500),
      backgroundColor: BudgetMeLightColors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 0.0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );
}
