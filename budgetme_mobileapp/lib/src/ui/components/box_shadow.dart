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
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';

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
