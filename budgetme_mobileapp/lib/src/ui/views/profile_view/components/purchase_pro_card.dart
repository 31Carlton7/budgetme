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
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/show_purchase_pro_bottom_sheet.dart';

class PurchaseProCard extends ConsumerWidget {
  const PurchaseProCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await showPurchaseProBottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        margin: const EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          gradient: BudgetMeLightColors.primaryGradient,
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          boxShadow: primaryBoxShadow,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  BudgetMeLocalizations.of(context)!.purchasePro,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontWeight: FontWeight.w700, color: BudgetMeLightColors.white),
                ),
                Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(isRTL(context) ? math.pi : 0),
                    child: const HeroIcon(HeroIcons.arrowRight, color: BudgetMeLightColors.white)),
              ],
            ),
            const SizedBox(height: kSmallPadding),
            Text(
              BudgetMeLocalizations.of(context)!.unlockText(''),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w500, color: BudgetMeLightColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
