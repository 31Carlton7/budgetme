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
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:heroicons/heroicons.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/ui/views/goal_view/components/show_goal_settings_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: non_constant_identifier_names
List<Widget> GoalViewHeader(BuildContext context, void Function(void Function()) setState, Goal goal) {
  return [
    SliverAppBar(
      stretch: true,
      snap: true,
      pinned: true,
      floating: true,
      expandedHeight: 230,
      elevation: 0,
      leadingWidth: 70,
      toolbarHeight: 65,
      collapsedHeight: 100,
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
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRTL(context) ? math.pi : 0),
            child: const HeroIcon(
              HeroIcons.arrowNarrowLeft,
              size: 20,
              color: BudgetMeLightColors.white,
              solid: true,
            ),
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
      flexibleSpace: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
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
          goal.photographer != ''
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () async {
                      final attributionParam = '?utm_source=BudgetMe&utm_medium=referral';
                      final link = Uri.parse(goal.photographerLink + attributionParam);

                      if (await canLaunchUrl(link)) {
                        await launchUrl(link);
                      } else {
                        DoNothingAction();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: kSmallPadding),
                      margin: const EdgeInsets.all(kDefaultPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kSmallBorderRadius),
                        color: BudgetMeLightColors.black.withOpacity(0.3),
                      ),
                      child: Text(
                        '${goal.photographer} / Unsplash',
                        style: Theme.of(context).textTheme.caption?.copyWith(color: BudgetMeLightColors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
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
