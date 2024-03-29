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

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:unsplash_client/unsplash_client.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/providers/unsplash_service_provider.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';
import 'package:budgetme/src/ui/components/close_button.dart';
import 'package:budgetme/src/ui/components/primary_button.dart';
import 'package:budgetme/src/ui/views/create_goal_view/create_goal_view.dart';

Future<Goal> showImageSelectionBottomSheet(BuildContext context, Goal goal) async {
  Future<Goal> _btmSheet = showCupertinoModalBottomSheet<Goal>(
    context: context,
    useRootNavigator: true,
    expand: true,
    backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
    builder: (context) {
      return GoalImageSelectorView(goal);
    },
  );

  return _btmSheet;
}

class GoalImageSelectorView extends ConsumerStatefulWidget {
  const GoalImageSelectorView(this.goal, {Key? key}) : super(key: key);

  final Goal goal;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoalImageSelectorViewState();
}

class _GoalImageSelectorViewState extends ConsumerState<GoalImageSelectorView> {
  late Goal _goal;

  final controller = TextEditingController();
  final focusNode = FocusNode();

  var webDeviceGroupValue = 0;
  var isEnabled = true;
  var photos = <Photo>[];
  var selectedImage = -1;
  var imgText = '';

  String noImageText() {
    if (photos.isEmpty) {
      if (imgText.isNotEmpty) {
        return BudgetMeLocalizations.of(context)!.noResults;
      } else if (imgText.isEmpty) {
        return BudgetMeLocalizations.of(context)!.searchForImage;
      }
    }

    return BudgetMeLocalizations.of(context)!.searchForImage;
  }

  var _selectedImage = '';
  var _photographer = '';
  var _photographerLink = '';

  @override
  void initState() {
    super.initState();

    _goal = widget.goal;

    setState(() {
      isEnabled = selectedImage >= 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cl = ref.read(unsplashServiceProvider).client;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Padding(
        padding: const EdgeInsets.only(top: kLargePadding),
        child: Scaffold(
          backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const <Widget>[BMCloseButton()],
              ),
            ),
          ),
          extendBodyBehindAppBar: false,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Row(
                      children: [
                        Text(
                          BudgetMeLocalizations.of(context)!.selectImage,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSmallPadding),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoSlidingSegmentedControl(
                            groupValue: webDeviceGroupValue,
                            thumbColor: Theme.of(context).cardTheme.color!,
                            children: {
                              0: PlatformText(BudgetMeLocalizations.of(context)!.web),
                              1: PlatformText(BudgetMeLocalizations.of(context)!.device),
                            },
                            onValueChanged: (val) async {
                              if (val == 1) {
                                final ImagePicker _picker = ImagePicker();
                                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

                                _selectedImage = image!.path.substring(image.path.indexOf('/tmp') + 4);
                                _goal = _goal.copyWith(image: _selectedImage);

                                Navigator.pop(context, _goal);
                              }

                              setState(() {
                                webDeviceGroupValue = val as int;

                                controller.selection = TextSelection.fromPosition(
                                  TextPosition(offset: controller.text.length),
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  if (webDeviceGroupValue == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      child: CupertinoSearchTextField(
                        style: CupertinoTheme.of(context).textTheme.textStyle,
                        controller: controller,
                        focusNode: focusNode,
                        onSubmitted: (str) async {
                          setState(() {
                            imgText = 'loading';
                          });

                          var kPhotos = await cl.search
                              .photos(str, orientation: PhotoOrientation.landscape, perPage: 30)
                              .goAndGet();

                          setState(() {
                            photos = kPhotos.results;
                          });
                        },
                      ),
                    ),
                  const SizedBox(height: kDefaultPadding),
                  if (photos.isEmpty && webDeviceGroupValue == 0)
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                            child: Text(
                              noImageText(),
                              style: Theme.of(context).textTheme.headline6,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (photos.isNotEmpty)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 1.5),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (selectedImage == index) {
                                    selectedImage = -1;
                                    isEnabled = false;
                                  } else {
                                    selectedImage = index;
                                    _photographer = photos[index].user.username;
                                    _photographerLink = photos[index].user.links.html.toString();

                                    // Image has not been downloaded necessarily until last
                                    // Screen's button 'finish' has been pressed. However,
                                    // a variable is set to trigger the download event when this
                                    // happens
                                    unsplashImageID = photos[index].id;

                                    // Download reference comes later in code
                                    _selectedImage = photos[index].urls.regular.toString();
                                    isEnabled = true;
                                  }
                                });
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.only(right: 1.5, bottom: 1.5),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    // Uses urls endpoint to quickly display image
                                    image: NetworkImage(photos[index].urls.small.toString()),
                                  ),
                                ),
                                child: selectedImage == index
                                    ? Center(
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: BudgetMeLightColors.black.withOpacity(0.5),
                                          ),
                                          child: const HeroIcon(
                                            HeroIcons.check,
                                            color: BudgetMeLightColors.white,
                                            size: 30,
                                            solid: true,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
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
                      buttonText: BudgetMeLocalizations.of(context)!.done,
                      onPressed: isEnabled
                          ? () async {
                              _goal = _goal.copyWith(
                                image: _selectedImage,
                                photographer: _photographer,
                                photographerLink: _photographerLink,
                              );

                              Navigator.pop(context, _goal);
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
    );
  }
}

const double _kPreviousPageVisibleOffset = 10;

const Radius _kDefaultTopRadius = Radius.circular(12);
const BoxShadow _kDefaultBoxShadow = BoxShadow(blurRadius: 10, color: Colors.black12, spreadRadius: 5);

class _CupertinoBottomSheetContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Radius topRadius;
  final BoxShadow? shadow;

  const _CupertinoBottomSheetContainer({
    Key? key,
    required this.child,
    this.backgroundColor,
    required this.topRadius,
    this.shadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topSafeAreaPadding = MediaQuery.of(context).padding.top;
    final topPadding = _kPreviousPageVisibleOffset + topSafeAreaPadding;
    final _shadow = shadow ?? _kDefaultBoxShadow;
    final _backgroundColor = backgroundColor ?? CupertinoTheme.of(context).scaffoldBackgroundColor;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: topRadius),
        child: Container(
          decoration: BoxDecoration(color: _backgroundColor, boxShadow: [_shadow]),
          width: double.infinity,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true, // Remove top Safe Area
            child: child,
          ),
        ),
      ),
    );
  }
}

Future<T> showCupertinoModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  double? closeProgressThreshold,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor,
  bool expand = false,
  AnimationController? secondAnimation,
  Curve? animationCurve,
  Curve? previousRouteAnimationCurve,
  bool useRootNavigator = false,
  bool bounce = true,
  bool? isDismissible,
  bool enableDrag = true,
  Radius topRadius = _kDefaultTopRadius,
  Duration? duration,
  RouteSettings? settings,
  Color? transitionBackgroundColor,
  BoxShadow? shadow,
}) async {
  assert(debugCheckHasMediaQuery(context));
  final hasMaterialLocalizations = Localizations.of<MaterialLocalizations>(context, MaterialLocalizations) != null;
  final barrierLabel = hasMaterialLocalizations ? MaterialLocalizations.of(context).modalBarrierDismissLabel : '';

  final result = await Navigator.of(context, rootNavigator: useRootNavigator).push(
    CupertinoModalBottomSheetRoute<T>(
      builder: builder,
      containerBuilder: (context, _, child) => _CupertinoBottomSheetContainer(
        child: child,
        backgroundColor: backgroundColor,
        topRadius: topRadius,
        shadow: shadow,
      ),
      secondAnimationController: secondAnimation,
      expanded: expand,
      closeProgressThreshold: closeProgressThreshold,
      barrierLabel: barrierLabel,
      elevation: elevation,
      bounce: bounce,
      shape: shape,
      clipBehavior: clipBehavior,
      isDismissible: isDismissible ?? expand == false ? true : false,
      modalBarrierColor: barrierColor ?? Colors.black12,
      enableDrag: enableDrag,
      topRadius: topRadius,
      animationCurve: animationCurve,
      previousRouteAnimationCurve: previousRouteAnimationCurve,
      duration: duration,
      settings: settings,
      transitionBackgroundColor: transitionBackgroundColor ?? Colors.black,
    ),
  );
  return result!;
}
