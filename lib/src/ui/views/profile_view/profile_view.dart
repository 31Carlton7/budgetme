import 'package:flutter/material.dart';

import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/ui/components/back_button.dart';
import 'package:budgetme/src/ui/components/monthly_savings_card.dart';
import 'package:budgetme/src/ui/views/profile_view/components/purchase_pro_card.dart';
import 'package:budgetme/src/ui/views/profile_view/components/settings_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timezone/timezone.dart' as tz;

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
          'Profile',
          style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: BMBackButton(),
        ),
        leadingWidth: 38,
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
          padding: const EdgeInsets.only(left: kDefaultPadding * 2),
          child: Text(
            '$month Statistics',
            style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        MonthlySavingsCard(),
        Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding * 2, top: kMediumPadding),
          child: Text(
            'Settings',
            style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        SettingsSection(),
        Center(
          child: Text(
            'Version 1.0.0 (1)',
            style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
