import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/transaction.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

class TransactionCard extends ConsumerWidget {
  const TransactionCard({
    Key? key,
    required this.context,
    required this.transaction,
    required this.currency,
  }) : super(key: key);

  final BuildContext context;
  final Transaction transaction;
  final Currency currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String amountString() {
      if (transaction.remove) return '-${formatAmount(transaction.amount, currency)}';
      return '+${formatAmount(transaction.amount, currency)}';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(kSmallPadding * 0.9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: !transaction.remove ? BudgetMeLightColors.success[1000] : BudgetMeLightColors.error[1000],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: !transaction.remove
                    ? HeroIcon(
                        HeroIcons.trendingUp,
                        size: 24,
                        color: BudgetMeLightColors.success,
                        solid: true,
                      )
                    : HeroIcon(
                        HeroIcons.trendingDown,
                        size: 24,
                        color: BudgetMeLightColors.error,
                        solid: true,
                      ),
              ),
            ),
            const SizedBox(width: kSmallPadding),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  DateFormat.yMMMMd().format(transaction.time),
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                color: !transaction.remove ? BudgetMeLightColors.success[1000] : BudgetMeLightColors.error[1000],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                amountString(),
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: !transaction.remove ? BudgetMeLightColors.success : BudgetMeLightColors.error,
                    ),
              ),
            ),
            // const SizedBox(width: 7),
            // HeroIcon(
            //   HeroIcons.chevronRight,
            //   size: 21,
            //   solid: true,
            //   color: Theme.of(context).colorScheme.secondaryContainer,
            // ),
          ],
        ),
      ),
    );
  }
}
