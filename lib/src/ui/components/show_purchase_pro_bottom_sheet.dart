import 'package:flutter/material.dart';

import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<void> showPurchaseProBottomSheet(BuildContext context) async {
  await showCustomModalBottomSheet(
    context: context,
    useRootNavigator: true,
    expand: true,
    builder: (context) {
      return Container();
    },
    containerWidget: (context, animation, child) {
      return Consumer(
        builder: (context, ref, child) {
          return SafeArea(
            bottom: false,
            child: Material(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              child: Scaffold(
                appBar: AppBar(
                  actions: [
                    PlatformTextButton(
                      child: PlatformText(
                        'Cancel',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(kAppIcon)),
                      ),
                    ),
                    const SizedBox(height: kSmallPadding),
                    Text(
                      'Pro',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    const SizedBox(height: kSmallPadding),
                    Text(
                      'Unlimited Goals',
                      style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: kDefaultPadding * 2),
                    Text.rich(
                      TextSpan(
                        text: 'Unlock your ',
                        style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                            text: 'true self',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                          ),
                          TextSpan(
                            text: ' with unlimited goals for a one-time purchase of just \$2.99! 😎',
                            style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 23.0, right: 24, bottom: kDefaultPadding * 2),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: 65,
                            child: BMPrimaryButton(
                              textColor: BudgetMeLightColors.white,
                              borderRadius: BorderRadius.circular(40),
                              gradient: BudgetMeLightColors.primaryGradient,
                              boxShadow: primaryBoxShadow,
                              padding: EdgeInsets.zero,
                              alignment: MainAxisAlignment.center,
                              buttonText: 'PURCHASE',
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
