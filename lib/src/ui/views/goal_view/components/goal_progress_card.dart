import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalProgressCard extends ConsumerWidget {
  const GoalProgressCard(this.goal, {Key? key}) : super(key: key);

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        boxShadow: cardBoxShadow,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Current Progress',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: kSmallPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatAmount(goal.currentAmount, goal.currency),
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 30,
                            ),
                      ),
                      Text(
                        'of ${formatAmount(goal.requiredAmount, goal.currency)}',
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: kSmallPadding),
                  Stack(
                    children: [
                      Container(
                        width: ((MediaQuery.of(context).size.width - 64) * (goal.percentCompleted * 0.01)),
                        height: 10,
                        decoration: BoxDecoration(
                          gradient: BudgetMeLightColors.primaryGradient,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: primaryBoxShadow,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 10,
                        decoration: BoxDecoration(
                          gradient: BudgetMeLightColors.primaryGradient10pt,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: kSmallPadding),
                  Center(
                    child: Text(
                      'You are ${goal.percentCompleted}% of the way there!',
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
