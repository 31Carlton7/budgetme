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
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/ui/components/back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class TransactionHistoryViewHeader extends ConsumerWidget {
  const TransactionHistoryViewHeader(this.goal, {Key? key}) : super(key: key);

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BMBackButton(),
          const SizedBox(width: kSmallPadding),
          Expanded(
            child: Text(goal.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: kSmallPadding),
          const HeroIcon(
            HeroIcons.download,
            solid: false,
            size: 27,
            color: BudgetMeLightColors.transparent,
          ),
        ],
      ),
    );
  }
}
