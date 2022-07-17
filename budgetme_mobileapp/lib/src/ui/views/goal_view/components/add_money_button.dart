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
import 'package:flutter/services.dart';

// Package imports:
import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/providers/goal_repository_provider.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:budgetme/src/ui/views/goal_view/components/show_add_money_bottom_sheet.dart';

class AddMoneyButton extends ConsumerWidget {
  const AddMoneyButton(this.goal, this.setState, this.controller, {Key? key}) : super(key: key);

  final Goal goal;
  final void Function(void Function()) setState;
  final ConfettiController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalRepositoryProvider).where((e) => e.id == goal.id);
    final _goal = goals.isNotEmpty ? goals.first : defGoal;

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
        prefixIcon: const HeroIcon(HeroIcons.plus, size: 27, color: BudgetMeLightColors.white, solid: false),
        onPressed: () async {
          HapticFeedback.mediumImpact();

          // Awaits result of bottom sheet to check if the goal has been completed
          var glComplete = await showAddMoneyBottomSheet(context, _goal);

          if (glComplete) {
            controller.play();
          } else {
            controller.stop();
          }

          setState(() {});
        },
      ),
    );
  }
}
