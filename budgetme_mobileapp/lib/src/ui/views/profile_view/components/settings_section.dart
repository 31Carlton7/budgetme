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
import 'package:heroicons/heroicons.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/views/adjust_monthly_spending_limit_view/adjust_monthly_spending_limit_view.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kSmallPadding),
      decoration: BoxDecoration(
        boxShadow: cardBoxShadow,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      ),
      child: Card(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const AdjustMonthlySpendingLimitView();
                  }),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(kDefaultBorderRadius)),
                  color: Theme.of(context).cardColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      BudgetMeLocalizations.of(context)!.adjustMonthlySpendingLimit,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(isRTL(context) ? math.pi : 0),
                      child: HeroIcon(
                        HeroIcons.chevronRight,
                        size: 21,
                        solid: true,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 0),
            GestureDetector(
              onTap: () async {
                final link = Uri.parse('https://budgetme.co/#/about');

                if (await canLaunchUrl(link)) {
                  await launchUrl(link);
                } else {
                  DoNothingAction();
                }
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: kDefaultPadding, right: kDefaultPadding, top: kDefaultPadding, bottom: kSmallPadding),
                color: Theme.of(context).cardColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      BudgetMeLocalizations.of(context)!.about,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      child: HeroIcon(
                        HeroIcons.externalLink,
                        size: 21,
                        solid: true,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final link = Uri.parse('https://budgetme.co/#/privacypolicy');

                if (await canLaunchUrl(link)) {
                  await launchUrl(link);
                } else {
                  DoNothingAction();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: kSmallPadding, horizontal: kDefaultPadding),
                color: Theme.of(context).cardColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      BudgetMeLocalizations.of(context)!.privacyPolicy,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      child: HeroIcon(
                        HeroIcons.externalLink,
                        size: 21,
                        solid: true,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final link = Uri.parse('https://budgetme.co/#/support');

                if (await canLaunchUrl(link)) {
                  await launchUrl(link);
                } else {
                  DoNothingAction();
                }
              },
              child: Container(
                padding: const EdgeInsets.only(
                    top: kSmallPadding, bottom: kDefaultPadding, left: kDefaultPadding, right: kDefaultPadding),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(kDefaultBorderRadius)),
                  color: Theme.of(context).cardColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      BudgetMeLocalizations.of(context)!.support,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      child: HeroIcon(
                        HeroIcons.externalLink,
                        size: 21,
                        solid: true,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
