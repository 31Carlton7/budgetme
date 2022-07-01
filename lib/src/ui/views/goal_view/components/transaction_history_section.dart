import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/transaction_card.dart';
import 'package:budgetme/src/ui/views/transaction_history_view/transaction_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class TransactionHistorySection extends ConsumerWidget {
  const TransactionHistorySection(this.goal, {Key? key}) : super(key: key);

  final Goal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      decoration: BoxDecoration(
        boxShadow: cardBoxShadow,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: kMediumPadding),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    Text(
                      'Transaction History',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return TransactionHistoryView(goal: goal);
                            },
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'See All',
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          HeroIcon(
                            HeroIcons.chevronRight,
                            size: 21,
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            solid: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              if (goal.transactions.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Text(
                    'No transactions have been made...yet!',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              for (var item in goal.transactions)
                TransactionCard(
                  context: context,
                  transaction: item,
                  currency: goal.currency,
                )
            ],
          ),
        ),
      ),
    );
  }
}
