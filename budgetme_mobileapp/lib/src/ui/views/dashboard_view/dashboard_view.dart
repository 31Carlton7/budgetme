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
import 'package:flutter/services.dart';

// Package imports:
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/providers/balance_repository_provider.dart';
import 'package:budgetme/src/providers/goal_repository_provider.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/monthly_savings_card.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:budgetme/src/ui/views/create_goal_view/create_goal_view.dart';
import 'package:budgetme/src/ui/views/dashboard_view/components/add_goal_button.dart';
import 'package:budgetme/src/ui/views/dashboard_view/components/goal_card.dart';
import 'package:budgetme/src/ui/views/profile_view/profile_view.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  void _updateUserCurrency() async {
    final locale = Localizations.localeOf(context);
    final format = NumberFormat.simpleCurrency(locale: locale.toString());
    final currencyName = format.currencyName;
    final currency = Currency.from(json: currencies.where((element) => element['code'] == currencyName).first);

    await ref.read(balanceRepositoryProvider).setCurrency(currency);
  }

  IconData icon() {
    if (Platform.isIOS) return CupertinoIcons.square_pencil;

    return Icons.edit_note;
  }

  @override
  Widget build(BuildContext context) {
    _updateUserCurrency();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).canvasColor,
      floatingActionButton: AddGoalButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          BudgetMeLocalizations.of(context)!.dashboard,
          style: Theme.of(context).textTheme.headline2?.copyWith(fontWeight: FontWeight.w600, fontSize: 32),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileView(),
                  ),
                );
              },
              child: Icon(
                PlatformIcons(context).accountCircle,
                size: 32,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: _content(context, ref),
      ),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref) {
    if (ref.watch(goalRepositoryProvider).isEmpty) {
      return Column(
        children: [
          _monthlySavingsCard(context),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Platform.localeName.substring(0, 2) == 'en'
                  ? Text.rich(
                      TextSpan(
                        text: 'Press the ',
                        style: Theme.of(context).textTheme.headline6,
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: BMPrimaryButton(
                                containerWidth: 30,
                                containerHeight: 30,
                                gradient: BudgetMeLightColors.primaryGradient,
                                shape: const CircleBorder(),
                                boxShadow: primaryBoxShadow,
                                padding: EdgeInsets.zero,
                                alignment: MainAxisAlignment.center,
                                prefixIcon: Icon(icon(), size: 18, color: BudgetMeLightColors.white),
                                onPressed: () async {
                                  HapticFeedback.mediumImpact();

                                  return await showCreateGoalView(context);
                                },
                              ),
                            ),
                          ),
                          TextSpan(
                            text: ' to create a new Goal!',
                          ),
                        ],
                      ),
                    )
                  : Text(
                      BudgetMeLocalizations.of(context)!.pressThePBtn,
                      style: Theme.of(context).textTheme.headline6,
                    ),
            ),
          ),
          SizedBox(height: kDefaultPadding * 4),
        ],
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: kDefaultPadding),
        child: _body(context, ref),
      ),
    );
  }

  Widget _body(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _monthlySavingsCard(context),
        if (ref.watch(goalRepositoryProvider).isNotEmpty)
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kSmallPadding),
                child: Text(
                  BudgetMeLocalizations.of(context)!.savingsGoals,
                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        for (var item in ref.watch(goalRepositoryProvider)) GoalCard(item, setState),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _monthlySavingsCard(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          BudgetMeLocalizations.of(context)!.monthlySavings,
          style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        tilePadding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        collapsedIconColor: Theme.of(context).iconTheme.color,
        iconColor: Theme.of(context).iconTheme.color,
        children: [
          MonthlySavingsCard(),
        ],
      ),
    );
  }
}
