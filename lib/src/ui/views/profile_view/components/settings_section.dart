import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/views/adjust_monthly_spending_limit_view/adjust_monthly_spending_limit_view.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kSmallPadding),
      decoration: BoxDecoration(
        boxShadow: cardBoxShadow,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      ),
      child: Card(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return AdjustMonthlySpendingLimitView();
                  }),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(kDefaultBorderRadius)),
                  color: Theme.of(context).cardColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Adjust Monthly Spending Limit',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Container(
                      child: HeroIcon(
                        HeroIcons.chevronRight,
                        size: 21,
                        solid: true,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 0),
            Container(
              padding: const EdgeInsets.only(
                  left: kDefaultPadding, right: kDefaultPadding, top: kDefaultPadding, bottom: kSmallPadding),
              color: Theme.of(context).cardColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    child: Container(
                      child: HeroIcon(
                        HeroIcons.externalLink,
                        size: 21,
                        solid: true,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: kSmallPadding, horizontal: kDefaultPadding),
              color: Theme.of(context).cardColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Privacy Policy',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    child: Container(
                      child: HeroIcon(
                        HeroIcons.externalLink,
                        size: 21,
                        solid: true,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: kSmallPadding, bottom: kDefaultPadding, left: kDefaultPadding, right: kDefaultPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(kDefaultBorderRadius)),
                color: Theme.of(context).cardColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Support',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    child: Container(
                      child: HeroIcon(
                        HeroIcons.externalLink,
                        size: 21,
                        solid: true,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
