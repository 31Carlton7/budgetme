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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';

// Project imports:
import 'package:budgetme/src/config/constants.dart';
import 'package:budgetme/src/config/themes/light_theme/light_color_palette.dart';
import 'package:budgetme/src/lang/budgetme_localizations.dart';
import 'package:budgetme/src/models/goal.dart';
import 'package:budgetme/src/ui/components/box_shadow.dart';

class TimeLeftCard extends ConsumerStatefulWidget {
  const TimeLeftCard(this.goal, {Key? key}) : super(key: key);

  final Goal goal;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TimeLeftCardState();
}

class _TimeLeftCardState extends ConsumerState<TimeLeftCard> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();

    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTimeChange);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onTimeChange(Timer timer) {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  DateTime calculateStartOfNextWeek(DateTime time) {
    final daysUntilNextWeek = 8 - time.weekday;
    return DateTime(time.year, time.month, time.day + daysUntilNextWeek);
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final deadline = Jiffy(widget.goal.deadline);
    final ref = Jiffy(deadline);

    final months = strDigits(ref.diff(_currentTime, Units.MONTH) as int);
    final days =
        strDigits((ref.diff((_currentTime), Units.DAY) as int) - ((ref.diff(_currentTime, Units.MONTH) as int) * 30));
    final hours =
        strDigits((ref.diff(_currentTime, Units.HOUR) as int) - ((ref.diff(_currentTime, Units.DAY) as int) * 24));
    final minutes =
        strDigits((ref.diff(_currentTime, Units.MINUTE) as int) - ((ref.diff(_currentTime, Units.HOUR) as int) * 60));
    final seconds =
        strDigits((ref.diff(_currentTime, Units.SECOND) as int) - ((ref.diff(_currentTime, Units.MINUTE) as int) * 60));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        boxShadow: cardBoxShadow,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                BudgetMeLocalizations.of(context)!.timeLeft,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: kSmallPadding),
              if (DateTime.now().isAfter(widget.goal.deadline))
                Center(
                  child: Text(
                    BudgetMeLocalizations.of(context)!.outOfTime,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if ((ref.diff(_currentTime, Units.MONTH) as int) >= 1)
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 40,
                              decoration: BoxDecoration(
                                color: BudgetMeLightColors.gray[1000],
                                borderRadius: BorderRadius.circular(kSmallBorderRadius),
                              ),
                              child: Center(
                                child: Text(
                                  months.substring(0, 1),
                                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(width: kSmallPadding / 2),
                            Container(
                              height: 70,
                              width: 40,
                              decoration: BoxDecoration(
                                color: BudgetMeLightColors.gray[1000],
                                borderRadius: BorderRadius.circular(kSmallBorderRadius),
                              ),
                              child: Center(
                                child: Text(
                                  months.substring(1, 2),
                                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: kSmallPadding / 2),
                        Text(
                          BudgetMeLocalizations.of(context)!.months,
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  if ((ref.diff((_currentTime), Units.DAY) as int) >= 1) const SizedBox(width: kDefaultPadding),
                  if ((ref.diff((_currentTime), Units.DAY) as int) >= 1)
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 40,
                              decoration: BoxDecoration(
                                color: BudgetMeLightColors.gray[1000],
                                borderRadius: BorderRadius.circular(kSmallBorderRadius),
                              ),
                              child: Center(
                                child: Text(
                                  days.substring(0, 1),
                                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(width: kSmallPadding / 2),
                            Container(
                              height: 70,
                              width: 40,
                              decoration: BoxDecoration(
                                color: BudgetMeLightColors.gray[1000],
                                borderRadius: BorderRadius.circular(kSmallBorderRadius),
                              ),
                              child: Center(
                                child: Text(
                                  days.substring(1, 2),
                                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: kSmallPadding / 2),
                        Text(
                          BudgetMeLocalizations.of(context)!.days,
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  if ((ref.diff(_currentTime, Units.HOUR) as int) >= 1) const SizedBox(width: kDefaultPadding),
                  if ((ref.diff(_currentTime, Units.HOUR) as int) >= 1)
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 40,
                              decoration: BoxDecoration(
                                color: BudgetMeLightColors.gray[1000],
                                borderRadius: BorderRadius.circular(kSmallBorderRadius),
                              ),
                              child: Center(
                                child: Text(
                                  hours.substring(0, 1),
                                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(width: kSmallPadding / 2),
                            Container(
                              height: 70,
                              width: 40,
                              decoration: BoxDecoration(
                                color: BudgetMeLightColors.gray[1000],
                                borderRadius: BorderRadius.circular(kSmallBorderRadius),
                              ),
                              child: Center(
                                child: Text(
                                  hours.substring(1, 2),
                                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: kSmallPadding / 2),
                        Text(
                          BudgetMeLocalizations.of(context)!.hours,
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  if ((ref.diff(_currentTime, Units.MINUTE) as int) >= 1 && int.parse(months) < 1)
                    const SizedBox(width: kDefaultPadding),
                  if ((ref.diff(_currentTime, Units.MINUTE) as int) >= 1 && int.parse(months) < 1)
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 40,
                              decoration: BoxDecoration(
                                color: BudgetMeLightColors.gray[1000],
                                borderRadius: BorderRadius.circular(kSmallBorderRadius),
                              ),
                              child: Center(
                                child: Text(
                                  minutes.substring(0, 1),
                                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(width: kSmallPadding / 2),
                            Container(
                              height: 70,
                              width: 40,
                              decoration: BoxDecoration(
                                color: BudgetMeLightColors.gray[1000],
                                borderRadius: BorderRadius.circular(kSmallBorderRadius),
                              ),
                              child: Center(
                                child: Text(
                                  minutes.substring(1, 2),
                                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: kSmallPadding / 2),
                        Text(
                          BudgetMeLocalizations.of(context)!.minutes,
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  if ((ref.diff(_currentTime, Units.SECOND) as int) >= 1 && int.parse(days) < 1)
                    const SizedBox(width: kDefaultPadding),
                  if ((ref.diff(_currentTime, Units.SECOND) as int) >= 1 && int.parse(days) < 1)
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 40,
                              decoration: BoxDecoration(
                                color: BudgetMeLightColors.gray[1000],
                                borderRadius: BorderRadius.circular(kSmallBorderRadius),
                              ),
                              child: Center(
                                child: Text(
                                  seconds.substring(0, 1),
                                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(width: kSmallPadding / 2),
                            Container(
                              height: 70,
                              width: 40,
                              decoration: BoxDecoration(
                                color: BudgetMeLightColors.gray[1000],
                                borderRadius: BorderRadius.circular(kSmallBorderRadius),
                              ),
                              child: Center(
                                child: Text(
                                  seconds.substring(1, 2),
                                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: kSmallPadding / 2),
                        Text(
                          BudgetMeLocalizations.of(context)!.seconds,
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
