import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/providers/goal_repository_provider.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:budgetme/src/ui/views/goal_view/components/show_add_money_bottom_sheet.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

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
