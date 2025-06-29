import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:responsive_framework/responsive_framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 8,
            children: [
              SizedBox(height: 4),
              DayCounterWidget(key: widget.key),
              const Placeholder(),
            ],
          ),
        ),
      ),
    );
  }
}

class DayCounterWidget extends StatefulWidget {
  const DayCounterWidget({super.key});

  @override
  State<DayCounterWidget> createState() => _DayCounterWidgetState();
}

class _DayCounterWidgetState extends State<DayCounterWidget> {
  final boxSize = Size(48, 54);
  final today = DateTime.now();
  final dateList = List<DateTime>.empty(growable: true);

  @override
  void initState() {
    dateList.clear();
    for (int i = -3; i <= 25; i++) {
      final date = today.add(Duration(days: i));
      dateList.add(date);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 16,
          end: 8,
          top: 4,
          bottom: 4,
        ),
        child: Row(
          spacing: 8,
          children: List.generate(
            dateList.length,
            (index) => DecoratedBox(
              decoration: BoxDecoration(
                border: dateList[index] == today
                    ? null
                    : Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(
                  ResponsiveValue<double>(
                    context,
                    defaultValue: 12,
                    conditionalValues: [
                      Condition.equals(name: TABLET, value: 12),
                      Condition.equals(name: DESKTOP, value: 14),
                    ],
                  ).value,
                ),
                boxShadow: dateList[index] == today
                    ? [BoxShadow(spreadRadius: .1, blurRadius: 3)]
                    : null,
                color: dateList[index] == today ? Color(0xff242424) : Colors.transparent,
              ),
              child: SizedBox(
                height: ResponsiveValue<double>(
                  context,
                  defaultValue: boxSize.height,
                  conditionalValues: [
                    Condition.equals(
                      name: TABLET,
                      value: boxSize.height * 1.25,
                    ),
                    Condition.equals(
                      name: DESKTOP,
                      value: boxSize.height * 1.5,
                    ),
                  ],
                ).value,
                width: ResponsiveValue<double>(
                  context,
                  defaultValue: boxSize.width,
                  conditionalValues: [
                    Condition.equals(name: TABLET, value: boxSize.width * 1.25),
                    Condition.equals(name: DESKTOP, value: boxSize.width * 1.5),
                  ],
                ).value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.E().format(
                        dateList[index],
                      ),
                      style: TextTheme.of(context).labelMedium?.copyWith(
                        color: dateList[index] == today
                            ? Colors.white60
                            : Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      dateList[index].day.toString(),
                      style: TextTheme.of(context).titleSmall?.copyWith(
                        color: dateList[index] == today ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
