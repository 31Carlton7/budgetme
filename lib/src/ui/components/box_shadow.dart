import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:flutter/material.dart';

List<BoxShadow> cardBoxShadow = [
  BoxShadow(
    color: BudgetMeLightColors.black.withOpacity(0.1),
    blurRadius: 6,
    spreadRadius: -1,
    offset: const Offset(0, 4),
  ),
  BoxShadow(
    color: BudgetMeLightColors.black.withOpacity(0.1),
    blurRadius: 4,
    spreadRadius: -2,
    offset: const Offset(0, 2),
  ),
];

List<BoxShadow> primaryBoxShadow = [
  BoxShadow(
    color: const Color(0xFF7B61FF).withOpacity(0.4),
    spreadRadius: 0,
    blurRadius: 15,
    offset: const Offset(0, 4),
  ),
];
