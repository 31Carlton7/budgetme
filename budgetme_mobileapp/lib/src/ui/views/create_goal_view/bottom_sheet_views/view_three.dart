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
import 'package:intl/intl.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/ui/components/back_button.dart' as b;
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:budgetme/src/ui/views/create_goal_view/bottom_sheet_views/view_four.dart';

class CGViewThree extends ConsumerStatefulWidget {
  const CGViewThree(this.ctx, this.goal, this.edit, {Key? key}) : super(key: key);

  final BuildContext ctx;
  final Goal goal;
  final bool? edit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CGViewThreeState();
}

class _CGViewThreeState extends ConsumerState<CGViewThree> {
  late Goal _goal;
  late DateTime _selectedDate;

  bool isEnabled = true;

  @override
  void initState() {
    super.initState();
    _goal = widget.goal;

    if (_goal.deadline.isAfter(DateTime.now())) {
      _selectedDate = _goal.deadline;
    } else {
      _selectedDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: b.BMBackButton(),
        ),
        leadingWidth: 57,
        actions: [
          PlatformTextButton(
            child: PlatformText(
              BudgetMeLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () {
              Navigator.pop(widget.ctx);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    BudgetMeLocalizations.of(context)!.whenDeadlineQ,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kDefaultPadding),
            GestureDetector(
              onTap: () async {
                final initialDate = _selectedDate.add(const Duration(minutes: 1));
                final firstDate = DateTime.now();
                final lastDate = DateTime(firstDate.year + 100, 12, 31);

                if (Platform.isIOS) {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    elevation: 0,
                    useRootNavigator: true,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 300,
                              child: CupertinoTheme(
                                data: CupertinoThemeData(
                                  brightness: MediaQuery.of(context).platformBrightness,
                                ),
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  initialDateTime: initialDate,
                                  minimumDate: firstDate,
                                  maximumDate: lastDate,
                                  onDateTimeChanged: (dt) {
                                    setState(() {
                                      _selectedDate = dt;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  _selectedDate = (await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: firstDate,
                        lastDate: lastDate,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Theme.of(context).primaryColor, // header background color
                                onPrimary: BudgetMeLightColors.white, // header text color
                                onSurface: Theme.of(context).colorScheme.primary, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: Theme.of(context).primaryColor, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      )) ??
                      DateTime.now().add(const Duration(days: 1));

                  setState(() {});
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: BudgetMeLightColors.primary[1000],
                ),
                child: Row(
                  children: [
                    Text(
                      _selectedDate.toString() == 'null'
                          ? ('August 31st, ' + DateTime.now().year.toString())
                          : DateFormat.yMMMMd().format(_selectedDate),
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: _selectedDate.toString() == 'null'
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).primaryColor,
                          ),
                    )
                  ],
                ),
              ),
            ),
            const Spacer(flex: 1),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 23.0, right: 24, bottom: kDefaultPadding * 2),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3.25,
                  child: BMPrimaryButton(
                    textColor: BudgetMeLightColors.white,
                    borderRadius: BorderRadius.circular(40),
                    gradient: BudgetMeLightColors.primaryGradient,
                    boxShadow: primaryBoxShadow,
                    padding: EdgeInsets.zero,
                    alignment: MainAxisAlignment.center,
                    buttonText: BudgetMeLocalizations.of(context)!.next,
                    onPressed: isEnabled
                        ? () {
                            _goal = _goal.copyWith(deadline: _selectedDate.subtract(const Duration(minutes: 1)));

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CGViewFour(widget.ctx, _goal, widget.edit);
                                },
                              ),
                            );
                          }
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
