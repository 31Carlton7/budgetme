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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/providers/goal_repository_provider.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:budgetme/src/ui/components/show_purchase_pro_bottom_sheet.dart';
import 'package:budgetme/src/ui/views/create_goal_view/create_goal_view.dart';

class AddGoalButton extends ConsumerWidget {
  const AddGoalButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(right: kDefaultPadding, bottom: kDefaultPadding),
      child: BMPrimaryButton(
        containerWidth: 65,
        containerHeight: 65,
        gradient: BudgetMeLightColors.primaryGradient,
        shape: const CircleBorder(),
        boxShadow: primaryBoxShadow,
        padding: EdgeInsets.zero,
        alignment: MainAxisAlignment.center,
        prefixIcon: const HeroIcon(HeroIcons.pencilAlt, size: 27, color: BudgetMeLightColors.white),
        onPressed: () async {
          HapticFeedback.mediumImpact();

          final goals = ref.read(goalRepositoryProvider);

          if (goals.length >= 2 /* && if they don't have Pro */) {
            return showPurchaseProBottomSheet(context);
          } else {
            return showCreateGoalView(context);
          }
        },
      ),
    );
  }
}
