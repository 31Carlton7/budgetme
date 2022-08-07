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
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/providers/goal_repository_provider.dart';
import 'package:budgetme/src/ui/views/create_goal_view/create_goal_view.dart';

Future<void> showGoalSettingsBottomSheet(BuildContext ctx, void Function(void Function()) setState, Goal goal) async {
  await showCustomModalBottomSheet(
    context: ctx,
    useRootNavigator: true,
    builder: (context) {
      return Container();
    },
    containerWidget: (context, animation, child) {
      return Consumer(
        builder: (context, ref, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  top: kLargePadding,
                  left: Platform.isIOS ? kDefaultPadding : 0.0,
                  right: Platform.isIOS ? kDefaultPadding : 0.0,
                ),
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: Platform.isIOS ? BorderRadius.circular(kDefaultBorderRadius) : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(
                          BudgetMeLocalizations.of(context)!.editGoal,
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        leading: HeroIcon(HeroIcons.pencil, size: 24, color: Theme.of(context).colorScheme.primary),
                        onTap: () async {
                          await showCreateGoalView(context, goal: goal, edit: true, setState: setState);
                        },
                      ),
                      ListTile(
                        title: Text(
                          BudgetMeLocalizations.of(context)!.deleteGoal,
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                color: BudgetMeLightColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        leading: HeroIcon(HeroIcons.trash, size: 24, color: BudgetMeLightColors.error),
                        onTap: () async {
                          await showDialog(
                            context: ctx,
                            builder: (context) {
                              return PlatformAlertDialog(
                                title: Text(BudgetMeLocalizations.of(context)!.deleteGoalQ),
                                content: Text(BudgetMeLocalizations.of(context)!.areYouSureDelQ(goal.title)),
                                actions: [
                                  PlatformTextButton(
                                    material: (context, platform) {
                                      return MaterialTextButtonData(
                                        child: Text(
                                          BudgetMeLocalizations.of(context)!.delete,
                                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () async {
                                          await ref.read(goalRepositoryProvider.notifier).removeGoal(goal);
                                          Navigator.popUntil(ctx, (route) => route.isFirst);
                                        },
                                      );
                                    },
                                    cupertino: (context, platform) {
                                      return CupertinoTextButtonData(
                                        child: Text(
                                          BudgetMeLocalizations.of(context)!.delete,
                                          style: const TextStyle(
                                              color: CupertinoColors.destructiveRed, fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () async {
                                          await ref.read(goalRepositoryProvider.notifier).removeGoal(goal);
                                          Navigator.pop(context);
                                          Navigator.pop(context, true);
                                          Navigator.popUntil(ctx, (route) => route.isFirst);
                                        },
                                      );
                                    },
                                  ),
                                  PlatformTextButton(
                                    material: (context, platform) {
                                      return MaterialTextButtonData(
                                        child: Text(BudgetMeLocalizations.of(context)!.cancel),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    cupertino: (context, platform) {
                                      return CupertinoTextButtonData(
                                        child: Text(BudgetMeLocalizations.of(context)!.cancel),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
