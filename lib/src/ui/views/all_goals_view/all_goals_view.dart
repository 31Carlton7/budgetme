import 'dart:io';

import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/providers/goal_repository_provider.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:budgetme/src/ui/views/all_goals_view/components/add_goal_button.dart';
import 'package:budgetme/src/ui/views/all_goals_view/components/goal_card.dart';
import 'package:budgetme/src/ui/components/monthly_savings_card.dart';
import 'package:budgetme/src/ui/views/create_goal_view/create_goal_view.dart';
import 'package:budgetme/src/ui/views/profile_view/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllGoalsView extends ConsumerStatefulWidget {
  const AllGoalsView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllGoalsViewState();
}

class _AllGoalsViewState extends ConsumerState<AllGoalsView> {
  IconData icon() {
    if (Platform.isIOS) return CupertinoIcons.square_pencil;

    return Icons.edit_note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).canvasColor,
      floatingActionButton: AddGoalButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).canvasColor,
        title: Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: Text(
            AppLocalizations.of(context)!.dashboard,
            style: Theme.of(context).textTheme.headline2?.copyWith(fontWeight: FontWeight.w600, fontSize: 32),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: kDefaultPadding + kSmallPadding),
            child: GestureDetector(
              onTap: () {
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
              child: Text.rich(
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
                padding: const EdgeInsets.only(left: kDefaultPadding * 2, top: kSmallPadding, bottom: kSmallPadding),
                child: Text(
                  'Savings Goals',
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
          'Monthly Savings',
          style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        tilePadding: const EdgeInsets.only(left: kDefaultPadding * 2),
        collapsedIconColor: Theme.of(context).iconTheme.color,
        iconColor: Theme.of(context).iconTheme.color,
        children: [
          MonthlySavingsCard(),
        ],
      ),
    );
  }
}
