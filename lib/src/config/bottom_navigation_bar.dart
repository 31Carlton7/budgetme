import 'package:budgetme/src/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  final int currentIndex;
  final void Function(int) onTabTapped;

  const BottomNavBar(this.currentIndex, this.onTabTapped, {Key? key}) : super(key: key);
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  static const _iconSize = 27.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kSmallPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(kLargeBorderRadius)),
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onTabTapped,
        elevation: 0,
        backgroundColor: Theme.of(context).cardTheme.color,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondaryContainer,
        selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor, size: 24),
        items: const [
          BottomNavigationBarItem(
            label: '',
            tooltip: '',
            activeIcon: HeroIcon(HeroIcons.home, size: _iconSize, solid: true),
            icon: HeroIcon(HeroIcons.home, size: _iconSize, solid: true),
          ),
          BottomNavigationBarItem(
            label: '',
            tooltip: '',
            activeIcon: HeroIcon(HeroIcons.plus, size: _iconSize),
            icon: HeroIcon(HeroIcons.plus, size: _iconSize),
          ),
          BottomNavigationBarItem(
            label: '',
            tooltip: '',
            activeIcon: HeroIcon(HeroIcons.user, size: _iconSize, solid: true),
            icon: HeroIcon(HeroIcons.user, size: _iconSize, solid: true),
          ),
        ],
      ),
    );
  }
}
