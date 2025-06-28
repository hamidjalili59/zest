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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16, end: 8,top: 4,bottom: 4),
        child: Row(
          spacing: 8,
          children: List.generate(
            16,
            (index) => DecoratedBox(
              decoration: BoxDecoration(
                border: index == 0
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
                boxShadow: index == 0
                    ? [BoxShadow(spreadRadius: .1, blurRadius: 3)]
                    : null,
                color: index == 0 ? Colors.black : Colors.transparent,
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
                        DateTime.now().add(Duration(days: index)),
                      ),
                      style: TextTheme.of(context).labelMedium?.copyWith(
                        color: index == 0
                            ? Colors.white60
                            : Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      DateTime.now().add(Duration(days: index)).day.toString(),
                      style: TextTheme.of(context).titleMedium?.copyWith(
                        color: index == 0 ? Colors.white : Colors.black,
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
