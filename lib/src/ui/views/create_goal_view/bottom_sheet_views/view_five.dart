import 'dart:io';

import 'package:flutter/material.dart';

import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/providers/goal_repository_provider.dart';
import 'package:budgetme/src/ui/components/back_button.dart' as b;
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:budgetme/src/ui/views/create_goal_view/create_goal_view.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

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

  bool isEnabled = true;

  @override
  void initState() {
    super.initState();
    _goal = widget.goal;

    _selectedCurrency = _goal.currency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: kSmallPadding),
          child: b.BMBackButton(),
        ),
        leadingWidth: 35,
        actions: [
          PlatformTextButton(
            child: PlatformText(
              'Cancel',
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
                  'Select Your Preferred Currency',
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
                    hintText: 'Search',
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
                    buttonText: 'Finish',
                    onPressed: isEnabled
                        ? () async {
                            if (_goal.image.contains('images.unsplash.com')) {
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
