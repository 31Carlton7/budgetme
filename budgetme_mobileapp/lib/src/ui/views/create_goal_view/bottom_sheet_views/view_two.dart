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

// Package imports:
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/ui/components/back_button.dart' as b;
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:budgetme/src/ui/views/create_goal_view/bottom_sheet_views/view_three.dart';

class CGViewTwo extends ConsumerStatefulWidget {
  const CGViewTwo(this.ctx, this.goal, this.edit, {Key? key}) : super(key: key);

  final BuildContext ctx;
  final Goal goal;
  final bool? edit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CGViewTwoState();
}

class _CGViewTwoState extends ConsumerState<CGViewTwo> {
  late TextEditingController _controller;
  late Goal _goal;

  bool isEnabled = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _goal = widget.goal;

    _controller.addListener(() {
      final _isEnabled = _controller.text.isNotEmpty;

      setState(() => isEnabled = _isEnabled);
    });

    if (_goal.requiredAmount > 0) {
      _controller.text = _goal.requiredAmount.toString();
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
                    BudgetMeLocalizations.of(context)!.howMuchNeededQ,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kDefaultPadding),
            TextField(
              autofocus: true,
              controller: _controller,
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: BudgetMeLightColors.primary,
                    fontWeight: FontWeight.w400,
                  ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                hintText: '2300',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: BudgetMeLightColors.transparent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: BudgetMeLightColors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: BudgetMeLightColors.transparent,
                  ),
                ),
                hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                fillColor: BudgetMeLightColors.primary[1000],
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
                            _goal = _goal.copyWith(requiredAmount: int.parse(_controller.text.trim()));

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CGViewThree(widget.ctx, _goal, widget.edit);
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
