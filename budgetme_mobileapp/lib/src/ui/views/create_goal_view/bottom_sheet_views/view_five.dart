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
import 'dart:io';

// Flutter imports:
import 'package:budgetme/src/providers/ad_state_provider.dart';
import 'package:budgetme/src/providers/unsplash_service_provider.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/providers/goal_repository_provider.dart';
import 'package:budgetme/src/ui/components/back_button.dart' as b;
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:budgetme/src/ui/views/create_goal_view/create_goal_view.dart';

class CGViewFive extends ConsumerStatefulWidget {
  const CGViewFive(this.ctx, this.goal, this.edit, {Key? key}) : super(key: key);

  final BuildContext ctx;
  final Goal goal;
  final bool? edit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CGViewFiveState();
}

class _CGViewFiveState extends ConsumerState<CGViewFive> {
  late Goal _goal;
  late Currency _selectedCurrency;

  late InterstitialAd _interstitialAd;
  bool _isAdLoaded = false;

  void _initAd() {
    InterstitialAd.load(
      adUnitId: ref.read(adStateProvider).createEditInterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  bool isEnabled = true;

  @override
  void initState() {
    super.initState();

    _initAd();

    _goal = widget.goal;

    _selectedCurrency = _goal.currency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: b.BMBackButton(),
        ),
        leadingWidth: 57,
        actions: [
          PlatformTextButton(
            child: PlatformText(
              BudgetMeLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () {
              Navigator.pop(widget.ctx);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 4),
            Row(
              children: [
                Text(
                  BudgetMeLocalizations.of(context)!.prefCurr,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            const SizedBox(height: kDefaultPadding),
            GestureDetector(
              onTap: () async {
                showCurrencyPicker(
                  context: context,
                  showFlag: true,
                  showCurrencyName: true,
                  showCurrencyCode: true,
                  onSelect: (curr) {
                    setState(() {
                      _selectedCurrency = curr;
                    });
                  },
                  theme: CurrencyPickerThemeData(),
                  inputDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    hintText: BudgetMeLocalizations.of(context)!.search,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: BudgetMeLightColors.primary[300],
                        ),
                    fillColor: BudgetMeLightColors.primary[1000],
                  ),
                );
              },
              child: Container(
                height: 50,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: BudgetMeLightColors.primary[1000],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCurrency.name + ' (' + _selectedCurrency.code + ')',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    Text(
                      _selectedCurrency.symbol,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: BudgetMeLightColors.primary[300],
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 1),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 23.0, right: 24, bottom: kDefaultPadding * 2),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3.25,
                  child: BMPrimaryButton(
                    textColor: BudgetMeLightColors.white,
                    borderRadius: BorderRadius.circular(40),
                    gradient: BudgetMeLightColors.primaryGradient,
                    boxShadow: cardBoxShadow,
                    padding: EdgeInsets.zero,
                    alignment: MainAxisAlignment.center,
                    buttonText: BudgetMeLocalizations.of(context)!.finish,
                    onPressed: isEnabled
                        ? () async {
                            if (_goal.image.contains('images.unsplash.com')) {
                              final cl = ref.read(unsplashServiceProvider).client;

                              // Triggers download event
                              cl.photos.download(unsplashImageID).go();

                              final imgResp = await get(Uri.parse(_goal.image));
                              final imgId = const Uuid().v4();

                              var documentDirectory = await getApplicationDocumentsDirectory();
                              final imgPath = '/BudgetMe_GoalImages/$imgId';
                              final firstPath = documentDirectory.path + '/BudgetMe_GoalImages';
                              final filePathAndName = documentDirectory.path + imgPath;

                              await Directory(firstPath).create(recursive: true);
                              final file2 = File(filePathAndName);
                              file2.writeAsBytesSync(imgResp.bodyBytes);

                              _goal = _goal.copyWith(image: imgPath);
                            }

                            _goal = _goal.copyWith(currency: _selectedCurrency);

                            if ([null, false].contains(widget.edit)) {
                              await ref.read(goalRepositoryProvider.notifier).addGoal(_goal);
                            } else {
                              await ref.read(goalRepositoryProvider.notifier).updateGoal(_goal);
                            }

                            // If they don't have pro, show ad
                            if (_isAdLoaded) {
                              // await _interstitialAd.show();
                            }

                            cgViewDone = true;
                            Navigator.pop(widget.ctx);
                          }
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
