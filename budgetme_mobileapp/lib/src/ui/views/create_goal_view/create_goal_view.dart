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
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/ui/views/create_goal_view/bottom_sheet_views/view_one.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

bool cgViewDone = false;

Future<void> showCreateGoalView(
  BuildContext context, {
  Goal? goal,
  bool? edit,
  void Function(void Function())? setState,
}) async {
  await showCustomModalBottomSheet(
    context: context,
    useRootNavigator: true,
    expand: true,
    builder: (context) {
      return Container();
    },
    containerWidget: (ctx, animation, child) {
      return Consumer(
        builder: (context, ref, child) {
          return StatefulBuilder(
            builder: (context, setState) {
              return GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: SafeArea(
                  bottom: false,
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                    child: CreateGoalView(ctx, goal: goal, edit: edit),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );

  if (![null, false].contains(edit)) setState!(() {});
}

class CreateGoalView extends ConsumerStatefulWidget {
  const CreateGoalView(this.ctx, {Key? key, this.goal, this.edit}) : super(key: key);

  final Goal? goal;
  final bool? edit;

  /// Custom BuildContext to make sure that the new Navigator doesn't
  /// interact with the main one and the WillPopScope activates.
  final BuildContext ctx;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateGoalViewState();
}

class _CreateGoalViewState extends ConsumerState<CreateGoalView> {
  late Goal? _goal;

  @override
  void initState() {
    super.initState();

    _goal = widget.goal;

    if (_goal == null) {
      _goal = Goal(
        id: '0',
        title: '',
        deadline: DateTime.now(),
        requiredAmount: 0,
        currentAmount: 0,
        transactions: [],
        currency: Currency.from(json: defaultCurrency),
        image: '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return CGViewOne(widget.ctx, _goal!, widget.edit);
            },
          );
        },
      ),
    );
  }
}
