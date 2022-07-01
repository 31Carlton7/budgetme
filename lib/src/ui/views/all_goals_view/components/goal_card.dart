import 'dart:math';

import 'package:flutter/material.dart';

import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/views/goal_view/components/show_goal_settings_bottom_sheet.dart';
import 'package:budgetme/src/ui/views/goal_view/goal_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class GoalCard extends ConsumerWidget {
  const GoalCard(this.goal, this.setState, {Key? key}) : super(key: key);

  final Goal goal;
  final void Function(void Function()) setState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalView(goal),
          ),
        );
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: kDefaultPadding, left: kDefaultPadding, right: kDefaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          boxShadow: cardBoxShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(
                goalImagePath(goal),
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, obj, stack) {
                  return Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: BudgetMeLightColors().allColors300[Random().nextInt(4)],
                    ),
                  );
                },
              ),
              Container(
                height: 175,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      BudgetMeLightColors.transparent,
                      BudgetMeLightColors.black.withOpacity(0.65),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(kDefaultBorderRadius),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            goal.title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline6?.copyWith(
                                  color: BudgetMeLightColors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatAmount(goal.currentAmount, goal.currency),
                              style: Theme.of(context).textTheme.headline5?.copyWith(
                                    color: BudgetMeLightColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              'of ${formatAmount(goal.requiredAmount, goal.currency)}',
                              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: BudgetMeLightColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: kDefaultPadding),
                    Stack(
                      children: [
                        Container(
                          width: ((MediaQuery.of(context).size.width - 64) * (goal.percentCompleted * 0.01)),
                          height: 5,
                          decoration: BoxDecoration(
                            color: BudgetMeLightColors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 5,
                          decoration: BoxDecoration(
                            color: BudgetMeLightColors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 1,
                top: 1,
                child: GestureDetector(
                  onTap: () async {
                    await showGoalSettingsBottomSheet(context, setState, goal);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(kSmallPadding),
                    decoration: BoxDecoration(
                      color: BudgetMeLightColors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const HeroIcon(
                      HeroIcons.dotsHorizontal,
                      size: 14,
                      color: BudgetMeLightColors.white,
                      solid: true,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
