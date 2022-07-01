import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BudgetMeLightColors {
  static MaterialColor primary = MaterialColor(
    0xFF6366F1,
    <int, Color>{
      100: const Color(0xFFE0E7FF),
      200: const Color(0xFFC7D2FE),
      300: const Color(0xFFA5B4FC),
      400: const Color(0xFF818CF8),
      500: const Color(0xFF6366F1),
      600: const Color(0xFF4F46E5),
      700: const Color(0xFF4338CA),
      800: const Color(0xFF3730A3),
      900: const Color(0xFF312E81),
      1000: const Color(0xFF6366F1).withOpacity(0.1),
    },
  );

  static MaterialColor gray = MaterialColor(
    0xFF64748B,
    <int, Color>{
      100: const Color(0xFFF9FAFB),
      200: const Color(0xFFE2E8F0),
      300: const Color(0xFFCBD5E1),
      400: const Color(0xFF94A3B8),
      500: const Color(0xFF64748B),
      600: const Color(0xFF475569),
      700: const Color(0xFF334155),
      800: const Color(0xFF1E293B),
      900: const Color(0xFF0F172A),
      1000: const Color(0xFF64748B).withOpacity(0.1),
    },
  );

  static MaterialColor success = MaterialColor(
    0xFF74E874,
    <int, Color>{
      100: const Color(0xFFEDFDE4),
      200: const Color(0xFFD7FCCA),
      300: const Color(0xFFBAF8AD),
      400: const Color(0xFF9EF196),
      500: const Color(0xFF74E874),
      600: const Color(0xFF54C75E),
      700: const Color(0xFF3AA74D),
      800: const Color(0xFF25863E),
      900: const Color(0xFF166F35),
      1000: const Color(0xFF74E874).withOpacity(0.1),
    },
  );

  static MaterialColor info = MaterialColor(
    0xFF0A7FFC,
    <int, Color>{
      100: const Color(0xFFCDEFFE),
      200: const Color(0xFF9CDAFE),
      300: const Color(0xFF6BC0FE),
      400: const Color(0xFF46A7FD),
      500: const Color(0xFF0A7FFC),
      600: const Color(0xFF0762D8),
      700: const Color(0xFF0549B5),
      800: const Color(0xFF033392),
      900: const Color(0xFF012478),
      1000: const Color(0xFF0A7FFC).withOpacity(0.1),
    },
  );

  static MaterialColor warning = MaterialColor(
    0xFFFFEE07,
    <int, Color>{
      100: const Color(0xFFFFFDCD),
      200: const Color(0xFFFFFA9B),
      300: const Color(0xFFFFF66A),
      400: const Color(0xFFFFF345),
      500: const Color(0xFFFFEE07),
      600: const Color(0xFFDBCB05),
      700: const Color(0xFFB7A803),
      800: const Color(0xFF938602),
      900: const Color(0xFF7A6E01),
      1000: const Color(0xFFFFEE07).withOpacity(0.1),
    },
  );

  static MaterialColor error = MaterialColor(
    0xFFFF4F1E,
    <int, Color>{
      100: const Color(0xFFFFE8D2),
      200: const Color(0xFFFFCCA4),
      300: const Color(0xFFFFA978),
      400: const Color(0xFFFF8756),
      500: const Color(0xFFFF4F1E),
      600: const Color(0xFFDB3215),
      700: const Color(0xFFB71B0F),
      800: const Color(0xFF930909),
      900: const Color(0xFF7A050E),
      1000: const Color(0xFFFF4F1E).withOpacity(0.1),
    },
  );

  List<Color> allColors300 = [primary[300]!, success[300]!, info[300]!, warning[300]!, error[300]!];

  static LinearGradient primaryGradient = LinearGradient(
    colors: [primary[500]!, primary[600]!],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient primaryGradient10pt = LinearGradient(
    colors: [primary[1000]!, primary[600]!.withOpacity(0.1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  static var colorScheme = ColorScheme.light(
    primary: black,
    primaryContainer: primary[300],
    onPrimary: info,
    secondary: CupertinoColors.systemGrey6,
    secondaryContainer: CupertinoColors.secondaryLabel,
    background: success,
    surface: warning,
    error: error,
    onSecondary: gray[200]!,
    onBackground: white,
    onSurface: warning[100]!,
    onError: error[100]!,
  );
}
