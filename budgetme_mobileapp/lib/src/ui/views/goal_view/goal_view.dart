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

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/providers/goal_repository_provider.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:budgetme/src/ui/components/time_left_card.dart';
import 'package:budgetme/src/ui/views/create_goal_view/create_goal_view.dart';
import 'package:budgetme/src/ui/views/goal_view/components/add_money_button.dart';
import 'package:budgetme/src/ui/views/goal_view/components/goal_progress_card.dart';
import 'package:budgetme/src/ui/views/goal_view/components/goal_view_header.dart';
import 'package:budgetme/src/ui/views/goal_view/components/transaction_history_section.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalView extends ConsumerStatefulWidget {
  const GoalView(this.goal, {Key? key}) : super(key: key);

  final Goal goal;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoalViewState();
}

class _GoalViewState extends ConsumerState<GoalView> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (math.pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * math.cos(step), halfWidth + externalRadius * math.sin(step));
      path.lineTo(halfWidth + internalRadius * math.cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * math.sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).canvasColor,
      floatingActionButton: AddMoneyButton(widget.goal, setState, _confettiController),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    final goals = ref.watch(goalRepositoryProvider).where((e) => e.id == widget.goal.id);
    final goal = goals.isNotEmpty ? goals.first : defGoal;

    if (goal.id == '0') {
      return Container();
    }

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            ...GoalViewHeader(context, setState, goal),
            if (goal.currentAmount == goal.requiredAmount)
              SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 3, vertical: kDefaultPadding * 2),
                    child: Column(
                      children: [
                        Text(
                          'Congratulations on completing your goal! 😆',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: kDefaultPadding),
                        BMPrimaryButton(
                          buttonText: 'Start new goal',
                          gradient: BudgetMeLightColors.primaryGradient,
                          textColor: BudgetMeLightColors.white,
                          boxShadow: primaryBoxShadow,
                          padding: EdgeInsets.zero,
                          alignment: MainAxisAlignment.center,
                          onPressed: () {
                            showCreateGoalView(context);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: GoalProgressCard(goal),
            ),
            if (goal.currentAmount < goal.requiredAmount)
              const SliverPadding(padding: EdgeInsets.only(bottom: kDefaultPadding)),
            if (goal.currentAmount < goal.requiredAmount)
              SliverToBoxAdapter(
                child: TimeLeftCard(goal),
              ),
            const SliverPadding(padding: EdgeInsets.only(bottom: kDefaultPadding)),
            SliverToBoxAdapter(
              child: TransactionHistorySection(goal),
            ),
            SliverToBoxAdapter(
              child: goal.photographer != ''
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: kDefaultPadding),
                      child: Text(
                        'Image by ${goal.photographer} / ${goal.photographerLink}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                  : Container(),
            ),

            // const SliverPadding(padding: EdgeInsets.only(bottom: kDefaultPadding)),

            //  SliverToBoxAdapter(
            //   child: Text('UnSplash'),
            // ),
            const SliverPadding(padding: EdgeInsets.only(bottom: kLargePadding * 4)),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: math.pi / 2,
            maxBlastForce: 20,
            minBlastForce: 10,
            shouldLoop: true,
            emissionFrequency: 0.05,
            numberOfParticles: 25,
          ),
        ),
      ],
    );
  }
}
