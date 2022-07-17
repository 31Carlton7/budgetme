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

// Package imports:
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/providers/balance_repository_provider.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';

class MonthlySavingsCard extends ConsumerWidget {
  const MonthlySavingsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(balanceRepositoryProvider);
    final balance = repo.balance.toString();
    final remainingBalance = repo.remainingBalance.toString();
    final totalMoneySaved = repo.totalMoneySaved.toString();
    final currency = Currency.from(json: repo.currency).symbol;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kSmallPadding),
      decoration: BoxDecoration(
        boxShadow: cardBoxShadow,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kMediumPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        BudgetMeLocalizations.of(context)!.remainingBalance,
                        style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: currency + remainingBalance,
                              style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: ' of ',
                              style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: currency + balance,
                              style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        // textDirection: TextDirection.ltr,
                        style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Container(
                          width: 60,
                          height: 46,
                          decoration: BoxDecoration(
                            color: BudgetMeLightColors.gray[1000],
                          ),
                        ),
                        Container(
                          width: ((repo.remainingBalance / repo.balance) * 60),
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: BudgetMeLightColors.primaryGradient,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        BudgetMeLocalizations.of(context)!.totalSaved,
                        style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        currency + totalMoneySaved,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Container()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
