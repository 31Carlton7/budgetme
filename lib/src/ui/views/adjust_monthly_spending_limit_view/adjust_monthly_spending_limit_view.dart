import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/providers/balance_repository_provider.dart';
import 'package:budgetme/src/ui/components/back_button.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdjustMonthlySpendingLimitView extends ConsumerWidget {
  const AdjustMonthlySpendingLimitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          'Adjust Monthly Spending Limit',
          style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: BMBackButton(),
        ),
        leadingWidth: 38,
      ),
      body: _content(context, ref),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref) {
    final repo = ref.read(balanceRepositoryProvider);
    final _controller = TextEditingController(text: repo.balance.toInt().toString());
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
            child: Text(
              'Please note that increasing your weekly spending will make it harder to achieve goals and it is discouraged.',
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: kSmallPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kSmallPadding),
          child: Text(
            'New Monthly Spending Limit',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: TextField(
            autofocus: false,
            controller: _controller,
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontWeight: FontWeight.w400,
                ),
            keyboardType: TextInputType.number,
            maxLength: 5,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: BudgetMeLightColors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: BudgetMeLightColors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: BudgetMeLightColors.transparent,
                ),
              ),
              fillColor: BudgetMeLightColors.gray[1000],
            ),
          ),
        ),
        const SizedBox(height: kSmallPadding),
        Align(
          alignment: Alignment.center,
          child: BMPrimaryButton(
            buttonText: 'Save',
            textColor: Theme.of(context).primaryColor,
            color: BudgetMeLightColors.transparent,
            containerWidth: MediaQuery.of(context).size.width / 3.25,
            borderRadius: BorderRadius.circular(999),
            padding: EdgeInsets.zero,
            alignment: MainAxisAlignment.center,
            onPressed: () {
              ref.read(balanceRepositoryProvider).setBalance(double.parse(_controller.text));
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ),
      ],
    );
  }
}
