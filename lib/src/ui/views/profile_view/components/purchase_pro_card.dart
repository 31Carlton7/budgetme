import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/show_purchase_pro_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class PurchaseProCard extends ConsumerWidget {
  const PurchaseProCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await showPurchaseProBottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        margin: const EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          gradient: BudgetMeLightColors.primaryGradient,
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          boxShadow: primaryBoxShadow,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Purchase Pro 😎',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontWeight: FontWeight.w700, color: BudgetMeLightColors.white),
                ),
                HeroIcon(HeroIcons.arrowRight, color: BudgetMeLightColors.white),
              ],
            ),
            const SizedBox(height: kSmallPadding),
            Text(
              'Unlock unlimited Goals, Spending Activity Downloads and more for just \$2.99! 😆 Pay once, Pay forever!',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w500, color: BudgetMeLightColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
