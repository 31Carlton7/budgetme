import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/providers/balance_repository_provider.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthlySavingsCard extends ConsumerWidget {
  const MonthlySavingsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(balanceRepositoryProvider);
    final balance = repo.balance.toString();
    final remainingBalance = repo.remainingBalance.toString();
    final totalMoneySaved = repo.totalMoneySaved.toString();
    final currency = Currency.from(json: repo.currency).symbol;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kSmallPadding),
      decoration: BoxDecoration(
        boxShadow: cardBoxShadow,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kMediumPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Remaining Balance',
                        style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text.rich(
                        TextSpan(
                          text: currency + remainingBalance,
                          style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                          children: [
                            TextSpan(
                              text: ' of ${currency + balance}',
                              style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Container(
                          width: 60,
                          height: 46,
                          decoration: BoxDecoration(
                            color: BudgetMeLightColors.gray[1000],
                          ),
                        ),
                        Container(
                          width: ((repo.remainingBalance / repo.balance) * 60),
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: BudgetMeLightColors.primaryGradient,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Total Saved',
                        style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        currency + totalMoneySaved,
                        style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Container()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
