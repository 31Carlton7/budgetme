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
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/ui/components/back_button.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/transaction_card.dart';

class TransactionHistoryView extends ConsumerStatefulWidget {
  const TransactionHistoryView({Key? key, required this.goal}) : super(key: key);

  final Goal goal;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends ConsumerState<TransactionHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: BMBackButton(),
        ),
        actions: [
          const HeroIcon(
            HeroIcons.download,
            solid: false,
            size: 27,
            color: BudgetMeLightColors.transparent,
          ),
        ],
        title: Text(
          widget.goal.title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: kSmallPadding, left: kDefaultPadding, right: kDefaultPadding),
          child: _content(context),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    if (widget.goal.transactions.isNotEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: [
            _transactionsList(context),
          ],
        ),
      );
    }

    return Center(
      child: Text(
        BudgetMeLocalizations.of(context)!.noTransactions,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _transactionsList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        boxShadow: cardBoxShadow,
      ),
      child: Card(
        child: Column(
          children: [
            for (var item in widget.goal.transactions)
              TransactionCard(
                context: context,
                transaction: item,
                currency: widget.goal.currency,
              ),
          ],
        ),
      ),
    );
  }
}
