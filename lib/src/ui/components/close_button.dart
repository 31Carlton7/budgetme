import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class BMCloseButton extends ConsumerWidget {
  const BMCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: HeroIcon(
        HeroIcons.x,
        size: 24,
        color: Theme.of(context).colorScheme.primary,
        solid: false,
      ),
    );
  }
}
