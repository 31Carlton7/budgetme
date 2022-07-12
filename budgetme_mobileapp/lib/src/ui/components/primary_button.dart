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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/dark_theme/dark_color_palette.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';

const EdgeInsets _kButtonPadding = EdgeInsets.all(16.0);
const EdgeInsets _kBackgroundButtonPadding = EdgeInsets.symmetric(
  vertical: 14.0,
  horizontal: 64.0,
);

class BMPrimaryButton extends ConsumerStatefulWidget {
  const BMPrimaryButton({
    Key? key,
    this.prefixIcon,
    this.suffixIcon,
    this.buttonText,
    this.iconColor,
    this.shape,
    this.textColor,
    this.padding,
    this.border,
    this.color,
    this.gradient,
    this.iconSize,
    this.boxShadow,
    this.iconPadding,
    this.containerHeight,
    this.containerWidth,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.minSize = kMinInteractiveDimensionCupertino,
    this.pressedOpacity = 0.3,
    this.borderRadius,
    this.alignment,
    this.onPressed,
  })  : assert(pressedOpacity == null || (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        super(key: key);

  final Widget? prefixIcon, suffixIcon;
  final String? buttonText;
  final BorderSide? border;
  final EdgeInsetsGeometry? padding;
  final Color? color, textColor, iconColor;
  final Color disabledColor;
  final LinearGradient? gradient;
  final double? iconSize, iconPadding, containerWidth, containerHeight;
  final VoidCallback? onPressed;
  final List<BoxShadow>? boxShadow;
  final double? minSize;
  final double? pressedOpacity;
  final BorderRadius? borderRadius;
  final MainAxisAlignment? alignment;
  final ShapeBorder? shape;
  bool get enabled => onPressed != null;

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
  }
}

class _PrimaryButtonState extends ConsumerState<BMPrimaryButton> with SingleTickerProviderStateMixin {
  static const Duration kFadeOutDuration = Duration(milliseconds: 10);
  static const Duration kFadeInDuration = Duration(milliseconds: 100);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController.drive(CurveTween(curve: Curves.decelerate)).drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(BMPrimaryButton old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) return;
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(0.3, duration: kFadeOutDuration)
        : _animationController.animateTo(0.0, duration: kFadeInDuration);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final bool enabled = widget.enabled;

    Widget prefixIconWidget() {
      if (widget.prefixIcon == null) return Container();

      return Container(child: widget.prefixIcon);
    }

    Widget suffixIconWidget() {
      if (widget.suffixIcon == null) return Container();

      return Container(
        padding: const EdgeInsets.only(left: 16.0),
        child: widget.suffixIcon,
      );
    }

    Widget textWidget() {
      if (widget.buttonText == null) return Container();

      return Text(
        widget.buttonText!,
        style: Theme.of(context).textTheme.button?.copyWith(
              color: enabled
                  ? (widget.textColor ??
                      ((widget.color!).value == Theme.of(context).primaryColor.value
                          ? BudgetMeLightColors.white
                          : Theme.of(context).colorScheme.primary))
                  : Theme.of(context).colorScheme.secondaryContainer,
            ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: Semantics(
        button: true,
        child: ConstrainedBox(
          constraints: widget.minSize == null
              ? const BoxConstraints()
              : BoxConstraints(
                  minWidth: widget.minSize!,
                  minHeight: widget.minSize!,
                ),
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: widget.shape ??
                  RoundedRectangleBorder(
                      borderRadius: widget.borderRadius ?? BorderRadius.circular(kDefaultBorderRadius),
                      side: widget.border ?? BorderSide.none),
              gradient: widget.color == null
                  ? ((widget.gradient != null) && enabled != true)
                      ? context.isDarkMode
                          ? LinearGradient(colors: [BudgetMeDarkColors.gray[800]!, BudgetMeDarkColors.gray[800]!])
                          : LinearGradient(colors: [BudgetMeLightColors.gray[200]!, BudgetMeLightColors.gray[200]!])
                      : widget.gradient
                  : null,
              color: widget.gradient == null
                  ? ((widget.color != null) && enabled != true
                      ? Theme.of(context).colorScheme.secondary
                      : widget.color ?? Theme.of(context).primaryColor)
                  : null,
              shadows: enabled ? widget.boxShadow : null,
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                height: widget.containerHeight ?? 50.0,
                width: widget.containerWidth ?? size.width,
                padding: widget.padding ??
                    (![BudgetMeLightColors.transparent, null].contains(widget.color)
                        ? _kButtonPadding
                        : _kBackgroundButtonPadding),
                child: ![BudgetMeLightColors.transparent, null].contains(widget.color)
                    ? Row(
                        mainAxisAlignment: widget.alignment ?? MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          prefixIconWidget(),
                          textWidget(),
                          suffixIconWidget(),
                        ],
                      )
                    : widget.prefixIcon != null
                        ? Row(
                            mainAxisAlignment: widget.alignment ?? MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              prefixIconWidget(),
                              textWidget(),
                              suffixIconWidget(),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: widget.alignment ?? MainAxisAlignment.center,
                            children: [
                              textWidget(),
                            ],
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
