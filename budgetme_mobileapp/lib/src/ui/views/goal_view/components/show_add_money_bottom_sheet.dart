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

import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/models/transaction.dart';
import 'package:budgetme/src/providers/balance_repository_provider.dart';
import 'package:budgetme/src/providers/goal_repository_provider.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/close_button.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

Future<bool> showAddMoneyBottomSheet(BuildContext context, Goal goal) async {
  var addRemoveGroupValue = 0;
  var title = BudgetMeLocalizations.of(context)!.add;
  var glComplete = false;

  var hideFromActivity = false;

  final controller = TextEditingController();
  final focusNode = FocusNode();

  if (goal.currentAmount >= goal.requiredAmount) {
    addRemoveGroupValue = 1;
    title = BudgetMeLocalizations.of(context)!.remove;
  }

  await showCustomModalBottomSheet(
    context: context,
    useRootNavigator: true,
    expand: true,
    backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
    builder: (context) {
      return Container(
        color: BudgetMeLightColors.white,
      );
    },
    containerWidget: (context, anim, child) {
      return Consumer(
        builder: (context, ref, child) {
          return StatefulBuilder(
            builder: (context, setState) {
              return GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Container(
                  margin: const EdgeInsets.only(top: 45),
                  decoration: BoxDecoration(
                    color: Theme.of(context).bottomSheetTheme.backgroundColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(kLargeBorderRadius),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: kLargePadding, left: kLargePadding, right: kLargePadding),
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: const Size(double.infinity, 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const <Widget>[BMCloseButton()],
                        ),
                      ),
                      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
                      extendBodyBehindAppBar: false,
                      body: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$title Money',
                              style: Theme.of(context).textTheme.headline2?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: kLargePadding),
                            Row(
                              children: [
                                if (goal.currentAmount > 0 && goal.currentAmount < goal.requiredAmount)
                                  Expanded(
                                    child: CupertinoSlidingSegmentedControl(
                                      groupValue: addRemoveGroupValue,
                                      thumbColor: Theme.of(context).cardTheme.color!,
                                      children: {
                                        0: PlatformText(BudgetMeLocalizations.of(context)!.add),
                                        1: PlatformText(BudgetMeLocalizations.of(context)!.remove),
                                      },
                                      onValueChanged: (val) {
                                        setState(() {
                                          addRemoveGroupValue = val as int;

                                          if (val == 0) {
                                            title = BudgetMeLocalizations.of(context)!.add;
                                          } else {
                                            title = BudgetMeLocalizations.of(context)!.remove;
                                          }

                                          controller.selection = TextSelection.fromPosition(
                                            TextPosition(offset: controller.text.length),
                                          );
                                        });
                                      },
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: kLargePadding),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: AutoSizeTextField(
                                    controller: controller,
                                    keyboardType: TextInputType.number,
                                    scrollPhysics: const NeverScrollableScrollPhysics(),
                                    wrapWords: false,
                                    maxLength: 7,
                                    textAlign: TextAlign.center,
                                    focusNode: focusNode,
                                    autofocus: true,
                                    inputFormatters: [
                                      CurrencyTextInputFormatter(symbol: goal.currency.symbol, decimalDigits: 0),
                                    ],
                                    style: Theme.of(context).textTheme.headline1?.copyWith(
                                          fontSize: 75,
                                          fontWeight: FontWeight.w800,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                    cursorColor: BudgetMeLightColors.primary,
                                    maxLines: 1,
                                    obscureText: false,
                                    showCursor: false,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      isDense: true,
                                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                      fillColor: BudgetMeLightColors.transparent,
                                      hintText: '${goal.currency.symbol}0',
                                      hintStyle: Theme.of(context).textTheme.headline1?.copyWith(
                                            fontSize: 75,
                                            fontWeight: FontWeight.w800,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            DottedLine(dashColor: Theme.of(context).primaryColor),
                            const SizedBox(height: kLargePadding),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  BudgetMeLocalizations.of(context)!.hideFrom,
                                  style: Theme.of(context).textTheme.headline6?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                PlatformSwitch(
                                  value: hideFromActivity,
                                  onChanged: (val) {
                                    setState(() {
                                      hideFromActivity = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 31),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BMPrimaryButton(
                                  containerWidth: 150,
                                  gradient: BudgetMeLightColors.primaryGradient,
                                  textColor: BudgetMeLightColors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  buttonText: title,
                                  boxShadow: primaryBoxShadow,
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    final goalRepo = ref.watch(goalRepositoryProvider.notifier);
                                    final balanceRepo = ref.watch(balanceRepositoryProvider);
                                    var amount = int.parse(controller.text.replaceAll(RegExp(r"\D"), ""));

                                    if (amount >= (goal.requiredAmount - goal.currentAmount) &&
                                        addRemoveGroupValue == 0) {
                                      amount = goal.requiredAmount - goal.currentAmount;
                                      await balanceRepo.increaseTotalMoneySaved(amount.toDouble());

                                      final transaction = Transaction(
                                        id: const Uuid().v4(),
                                        title: BudgetMeLocalizations.of(context)!.transaction,
                                        amount: amount,
                                        time: DateTime.now(),
                                        remove: false,
                                      );

                                      List<Transaction> transactions() {
                                        if (hideFromActivity) return goal.transactions;
                                        return [transaction, ...goal.transactions];
                                      }

                                      goal = goal.copyWith(
                                        currentAmount: goal.requiredAmount,
                                        image: goal.image,
                                        transactions: transactions(),
                                      );

                                      await goalRepo.updateGoal(goal);
                                    } else if (amount >= goal.currentAmount && addRemoveGroupValue == 1) {
                                      amount = goal.currentAmount;
                                      await balanceRepo.decreaseRemainingBalance(amount.toDouble());

                                      final transaction = Transaction(
                                        id: const Uuid().v4(),
                                        title: BudgetMeLocalizations.of(context)!.transaction,
                                        amount: amount,
                                        time: DateTime.now(),
                                        remove: true,
                                      );

                                      List<Transaction> transactions() {
                                        if (hideFromActivity) return goal.transactions;
                                        return [transaction, ...goal.transactions];
                                      }

                                      goal = goal.copyWith(
                                        currentAmount: 0,
                                        image: goal.image,
                                        transactions: transactions(),
                                      );

                                      await goalRepo.updateGoal(goal);
                                    } else if (addRemoveGroupValue == 0) {
                                      var newCurrentAmount = goal.currentAmount + amount;
                                      balanceRepo.increaseTotalMoneySaved(amount.toDouble());

                                      final transaction = Transaction(
                                        id: const Uuid().v4(),
                                        title: BudgetMeLocalizations.of(context)!.transaction,
                                        amount: amount,
                                        time: DateTime.now(),
                                        remove: false,
                                      );

                                      List<Transaction> transactions() {
                                        if (hideFromActivity) return goal.transactions;
                                        return [transaction, ...goal.transactions];
                                      }

                                      goal = goal.copyWith(
                                        currentAmount: newCurrentAmount,
                                        image: goal.image,
                                        transactions: transactions(),
                                      );

                                      await goalRepo.updateGoal(goal);
                                    } else {
                                      var newCurrentAmount = goal.currentAmount - amount;
                                      await balanceRepo.decreaseRemainingBalance(amount.toDouble());
                                      print('y');

                                      final transaction = Transaction(
                                        id: const Uuid().v4(),
                                        title: BudgetMeLocalizations.of(context)!.transaction,
                                        amount: amount,
                                        time: DateTime.now(),
                                        remove: true,
                                      );

                                      List<Transaction> transactions() {
                                        if (hideFromActivity) return goal.transactions;
                                        return [transaction, ...goal.transactions];
                                      }

                                      goal = goal.copyWith(
                                        currentAmount: newCurrentAmount,
                                        transactions: transactions(),
                                      );

                                      await goalRepo.updateGoal(goal);
                                    }

                                    glComplete = goal.currentAmount == goal.requiredAmount;

                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );

  return glComplete;
}
