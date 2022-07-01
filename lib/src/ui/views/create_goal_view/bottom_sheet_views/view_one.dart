import 'dart:io';

import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:budgetme/src/ui/views/create_goal_view/bottom_sheet_views/view_two.dart';
import 'package:budgetme/src/ui/views/create_goal_view/components/show_image_selection_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:uuid/uuid.dart';

class CGViewOne extends ConsumerStatefulWidget {
  const CGViewOne(this.ctx, this.goal, this.edit, {Key? key}) : super(key: key);

  /// Custom BuildContext to make sure that the new Navigator doesn't
  /// interact with the main one and the WillPopScope activates.
  final BuildContext ctx;
  final Goal goal;
  final bool? edit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CGViewOneState();
}

class _CGViewOneState extends ConsumerState<CGViewOne> {
  late TextEditingController _controller;
  late Goal _goal;

  bool isEnabled = true;

  @override
  void initState() {
    super.initState();
    _goal = widget.goal;
    _controller = TextEditingController(text: _goal.title);

    _controller.addListener(() {
      final _isEnabled = _controller.text.isNotEmpty && _goal.image != '';

      setState(() => isEnabled = _isEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
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
              Navigator.pop(widget.ctx);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: SingleChildScrollView(
          child: SizedBox(
            height: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 2),
                  child: GestureDetector(
                    onTap: () async {
                      _goal = await showImageSelectionBottomSheet(widget.ctx, _goal);

                      if (_goal.image != '' && _controller.text.isNotEmpty) isEnabled = true;

                      setState(() {});
                    },
                    child: _goal.image == ''
                        ? Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              color: BudgetMeLightColors.primary[1000],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: HeroIcon(
                                HeroIcons.camera,
                                size: 32,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        : Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: BudgetMeLightColors.primary[1000],
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _goal.image.contains('http')
                                    ? NetworkImage(_goal.image)
                                    : FileImage(
                                        File(
                                          goalImagePath(_goal),
                                        ),
                                      ) as ImageProvider,
                              ),
                            ),
                            child: _goal.image == ''
                                ? Center(
                                    child: HeroIcon(
                                      HeroIcons.camera,
                                      size: 32,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                : null,
                          ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'What are you saving for?',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kDefaultPadding * 2),
                TextField(
                  autofocus: true,
                  controller: _controller,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: BudgetMeLightColors.primary,
                        fontWeight: FontWeight.w400,
                      ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    hintText: 'Vacation',
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
                    hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                    fillColor: BudgetMeLightColors.primary[1000],
                  ),
                ),
                const Spacer(),
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
                        boxShadow: primaryBoxShadow,
                        padding: EdgeInsets.zero,
                        alignment: MainAxisAlignment.center,
                        buttonText: 'Next',
                        onPressed: isEnabled
                            ? () async {
                                _goal = _goal.copyWith(
                                  id: [null, false].contains(widget.edit) ? const Uuid().v4() : null,
                                  title: _controller.text.trim(),
                                );

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CGViewTwo(widget.ctx, _goal, widget.edit);
                                    },
                                  ),
                                );
                              }
                            : null,
                      ),
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
