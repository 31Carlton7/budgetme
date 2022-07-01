import 'dart:io';

import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:budgetme/src/ui/views/create_goal_view/create_goal_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddGoalButton extends ConsumerWidget {
  const AddGoalButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IconData icon() {
      if (Platform.isIOS) return CupertinoIcons.square_pencil;

      return Icons.edit_note;
    }

    return Container(
      margin: const EdgeInsets.only(right: kDefaultPadding, bottom: kDefaultPadding),
      child: BMPrimaryButton(
        containerWidth: 65,
        containerHeight: 65,
        gradient: BudgetMeLightColors.primaryGradient,
        shape: const CircleBorder(),
        boxShadow: primaryBoxShadow,
        padding: EdgeInsets.zero,
        alignment: MainAxisAlignment.center,
        prefixIcon: Icon(icon(), size: 27, color: BudgetMeLightColors.white),
        onPressed: () async {
          HapticFeedback.mediumImpact();

          return showCreateGoalView(context);
        },
      ),
    );
  }
}
