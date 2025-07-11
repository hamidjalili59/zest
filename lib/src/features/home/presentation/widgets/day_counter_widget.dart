import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:responsive_framework/responsive_framework.dart';

import 'package:zest/src/core/constants/general_constants.dart';
import 'package:zest/src/features/home/constants/home_constants.dart';

class DayCounterWidget extends StatefulWidget {
  const DayCounterWidget({super.key});

  @override
  State<DayCounterWidget> createState() => _DayCounterWidgetState();
}

class _DayCounterWidgetState extends State<DayCounterWidget> {
  final today = DateTime.now();
  final dateList = List<DateTime>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    dateList.clear();
    for (
      int i = -HomeConstants.kPastDaysCount;
      i <= HomeConstants.kFutureDaysCount;
      i++
    ) {
      final date = today.add(Duration(days: i));
      dateList.add(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: HomeConstants.kDayCounterPadding,
        child: Row(
          spacing: GeneralConstants.kMediumSpacing,
          children: List.generate(dateList.length, (index) {
            final isToday = dateList[index] == today;
            final isAfter = dateList[index].isAfter(today);
            return DecoratedBox(
              decoration: BoxDecoration(
                border: isToday
                    ? null
                    : Border.all(
                        color: isAfter
                            ? GeneralConstants.kDisabledBorderColor
                            : GeneralConstants.kLightBorderColor,
                      ),
                borderRadius: BorderRadius.circular(
                  ResponsiveValue<double>(
                    context,
                    defaultValue: GeneralConstants.kDefaultBorderRadius,
                    conditionalValues: [
                      Condition.equals(
                        name: TABLET,
                        value: GeneralConstants.kDefaultBorderRadius,
                      ),
                      Condition.equals(
                        name: DESKTOP,
                        value: GeneralConstants.kDesktopBorderRadius,
                      ),
                    ],
                  ).value,
                ),
                boxShadow: isToday ? HomeConstants.kTodayBoxShadow : null,
                color: isToday
                    ? GeneralConstants.kPrimaryDarkColor
                    : isAfter
                    ? GeneralConstants.kDisabledBorderColor
                    : Colors.transparent,
              ),
              child: SizedBox(
                height: ResponsiveValue<double>(
                  context,
                  defaultValue: HomeConstants.kDayCounterBoxSize.height,
                  conditionalValues: [
                    Condition.equals(
                      name: TABLET,
                      value:
                          HomeConstants.kDayCounterBoxSize.height *
                          HomeConstants.kTabletSizeMultiplier,
                    ),
                    Condition.equals(
                      name: DESKTOP,
                      value:
                          HomeConstants.kDayCounterBoxSize.height *
                          HomeConstants.kDesktopSizeMultiplier,
                    ),
                  ],
                ).value,
                width: ResponsiveValue<double>(
                  context,
                  defaultValue: HomeConstants.kDayCounterBoxSize.width,
                  conditionalValues: [
                    Condition.equals(
                      name: TABLET,
                      value:
                          HomeConstants.kDayCounterBoxSize.width *
                          HomeConstants.kTabletSizeMultiplier,
                    ),
                    Condition.equals(
                      name: DESKTOP,
                      value:
                          HomeConstants.kDayCounterBoxSize.width *
                          HomeConstants.kDesktopSizeMultiplier,
                    ),
                  ],
                ).value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.E().format(dateList[index]),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isToday
                            ? GeneralConstants.kSecondaryTextColorLight
                            : isAfter
                            ? GeneralConstants.kSubtleDisabledTextColor
                            : GeneralConstants.kSubtleTextColor,
                      ),
                    ),
                    Text(
                      dateList[index].day.toString(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isToday
                            ? GeneralConstants.kPrimaryTextColorLight
                            : isAfter
                            ? GeneralConstants.kSubtleDisabledTextColor
                            : GeneralConstants.kPrimaryTextColorDark,
                        fontWeight: GeneralConstants.kSemiBoldFontWeight,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
