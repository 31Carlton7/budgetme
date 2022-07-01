import 'dart:math';

import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/ui/views/goal_view/components/show_goal_settings_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

// ignore: non_constant_identifier_names
List<Widget> GoalViewHeader(BuildContext context, void Function(void Function()) setState, Goal goal) {
  return [
    SliverAppBar(
      stretch: true,
      expandedHeight: 230,
      elevation: 0,
      leadingWidth: 70,
      toolbarHeight: 65,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(kDefaultPadding),
          decoration: BoxDecoration(
            color: BudgetMeLightColors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: const HeroIcon(
            HeroIcons.arrowNarrowLeft,
            size: 20,
            color: BudgetMeLightColors.white,
            solid: true,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () async => await showGoalSettingsBottomSheet(context, setState, goal),
          child: Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              color: BudgetMeLightColors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(9),
            child: const HeroIcon(
              HeroIcons.dotsHorizontal,
              size: 20,
              color: BudgetMeLightColors.white,
              solid: true,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Image.asset(
          goalImagePath(goal),
          fit: BoxFit.cover,
          errorBuilder: (context, obj, stack) {
            return Container(
              height: 230,
              decoration: BoxDecoration(
                color: BudgetMeLightColors().allColors300[Random().nextInt(4)],
              ),
            );
          },
        ),
      ),
    ),
    SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                goal.title + (goal.currentAmount >= goal.requiredAmount ? ' ✅' : ''),
                style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    ),
  ];
}
