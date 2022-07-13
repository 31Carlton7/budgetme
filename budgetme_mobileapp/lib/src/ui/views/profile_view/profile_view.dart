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
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PurchaseProCard(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
          child: Text(
            BudgetMeLocalizations.of(context)!.statistics(month).toCamelCase(),
            style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        MonthlySavingsCard(),
        Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding * 2, right: kDefaultPadding * 2, top: kMediumPadding),
          child: Text(
            BudgetMeLocalizations.of(context)!.settings,
            style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        SettingsSection(),
        Center(
          child: Text(
            BudgetMeLocalizations.of(context)!.version(kAppVersionNumber),
            style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
