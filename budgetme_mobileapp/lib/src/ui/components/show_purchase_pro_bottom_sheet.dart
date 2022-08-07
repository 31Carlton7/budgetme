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

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';

String budgetmeProID = 'budgetme_pro_version';

Future<void> showPurchaseProBottomSheet(BuildContext context) async {
  final locale = Localizations.localeOf(context);
  final format = NumberFormat.simpleCurrency(locale: locale.toString());
  // ignore: unused_local_variable
  final currencySymbol = format.currencySymbol;

  await showCustomModalBottomSheet(
    context: context,
    useRootNavigator: true,
    expand: true,
    builder: (context) {
      return Container();
    },
    containerWidget: (context, animation, child) {
      return const PurchaseProView();
    },
  );
}

class PurchaseProView extends ConsumerStatefulWidget {
  const PurchaseProView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PurchaseProViewState();
}

class _PurchaseProViewState extends ConsumerState<PurchaseProView> {
  /// IAP Plugin Interface
  final _iap = InAppPurchase.instance;

  /// Is the API available on the device
  bool _available = true;

  /// Products for sale
  List<ProductDetails> _products = [];

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _getProducts() async {
    Set<String> ids = {budgetmeProID};
    final resp = await _iap.queryProductDetails(ids);

    setState(() {
      _products = resp.productDetails;
    });
  }

  void _initialize() async {
    _available = await _iap.isAvailable();

    if (_available) {
      await _getProducts();
    }
  }

  void _buyProduct(ProductDetails prod) {
    final purchaseParam = PurchaseParam(productDetails: prod);

    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
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
                  BudgetMeLocalizations.of(context)!.cancel,
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
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Container(
                  height: 160,
                  width: 160,
                  decoration: const BoxDecoration(
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
                  BudgetMeLocalizations.of(context)!.unlimitedGoals,
                  style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: kDefaultPadding * 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Text(
                    BudgetMeLocalizations.of(context)!.unlockText('2.99 USD'),
                    style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 23.0, right: 24, bottom: kDefaultPadding * 2),
                    child: Column(
                      children: [
                        const SizedBox(height: kDefaultPadding),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: 65,
                          child: BMPrimaryButton(
                            textColor: BudgetMeLightColors.white,
                            borderRadius: BorderRadius.circular(40),
                            gradient: BudgetMeLightColors.primaryGradient,
                            boxShadow: primaryBoxShadow,
                            padding: EdgeInsets.zero,
                            alignment: MainAxisAlignment.center,
                            buttonText: BudgetMeLocalizations.of(context)!.purchase,
                            onPressed: _available
                                ? () {
                                    _buyProduct(_products[0]);
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(height: kDefaultPadding * 2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
