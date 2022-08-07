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
import 'package:budgetme/src/providers/pro_user_repository_provider.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timezone/timezone.dart' as tz;

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/extensions.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/ui/components/back_button.dart';
import 'package:budgetme/src/ui/components/monthly_savings_card.dart';
import 'package:budgetme/src/ui/views/profile_view/components/purchase_pro_card.dart';
import 'package:budgetme/src/ui/views/profile_view/components/settings_section.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final _iap = InAppPurchase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          BudgetMeLocalizations.of(context)!.profile,
          style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: BMBackButton(),
        ),
        leadingWidth: 57,
      ),
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    final _mth = tz.TZDateTime.now(tz.local);
    final month = Jiffy(_mth).MMMM;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ref.read(proUserRepositoryProvider).proUser ? Container() : const PurchaseProCard(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
            child: Text(
              BudgetMeLocalizations.of(context)!.statistics(month).toCamelCase(),
              style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const MonthlySavingsCard(),
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding * 2, right: kDefaultPadding * 2, top: kMediumPadding),
            child: Text(
              BudgetMeLocalizations.of(context)!.settings,
              style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SettingsSection(),
          GestureDetector(
            onTap: () async {
              await _iap.restorePurchases();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kSmallPadding),
              decoration: BoxDecoration(
                boxShadow: cardBoxShadow,
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              ),
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Restore Purchases',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Text(
              BudgetMeLocalizations.of(context)!.version(kAppVersionNumber),
              style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Center(
            child: Text(
              'BudgetMe Pro',
              style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
