import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:zest/src/core/constants/app_theme.dart';
import 'package:zest/src/features/home/constants/home_constants.dart';

const _todayBg = Color(0xFF1E7F66);

class DayCounterWidget extends StatefulWidget {
  const DayCounterWidget({super.key});

  @override
  State<DayCounterWidget> createState() => _DayCounterWidgetState();
}

class _DayCounterWidgetState extends State<DayCounterWidget> {
  final today = DateTime.now();
  final dateList = <DateTime>[];

  @override
  void initState() {
    super.initState();
    dateList.clear();
    for (
      int i = -HomeConstants.kPastDaysCount;
      i <= HomeConstants.kFutureDaysCount;
      i++
    ) {
      dateList.add(today.add(Duration(days: i)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: HomeConstants.kDayCounterPadding,
        child: Row(
          children: List.generate(dateList.length, (index) {
            final isToday =
                dateList[index].day == today.day &&
                dateList[index].month == today.month &&
                dateList[index].year == today.year;
            final isAfter = dateList[index].isAfter(today);
            return Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isToday ? _todayBg : Colors.transparent,
                border: isToday
                    ? null
                    : Border.all(
                        color: isAfter ? Colors.white10 : Colors.white12,
                      ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isToday
                    ? [
                        BoxShadow(
                          color: _todayBg.withAlpha(0.35.toAlpha()),
                          blurRadius: 12,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              width: 64,
              height: 74,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E().format(dateList[index]),
                    style: TextStyle(
                      color: isToday ? Colors.white70 : Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dateList[index].day.toString(),
                    style: TextStyle(
                      color: isToday ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
