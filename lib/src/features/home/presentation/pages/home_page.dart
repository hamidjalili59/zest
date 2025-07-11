import 'package:flutter/material.dart';
import 'package:zest/src/core/constants/general_constants.dart';
import 'package:zest/src/features/home/presentation/widgets/daily_activities_widget.dart' show DailyActivitiesWidget;
import 'package:zest/src/features/home/presentation/widgets/day_counter_widget.dart';
import 'package:zest/src/features/home/presentation/widgets/home_day_details_widget.dart';
import 'package:zest/src/features/home/presentation/widgets/home_navigation_bar_widget.dart';
import 'package:zest/src/features/home/presentation/widgets/linear_chart_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const HomeBottomNavigationBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: GeneralConstants.kMediumSpacing,
            children: [
              const SizedBox(height: GeneralConstants.kSmallSpacing),
              DayCounterWidget(key: widget.key),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: GeneralConstants.kLargePadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: GeneralConstants.kLargePadding,
                  children: [const HomeDayDetailsWidget()],
                ),
              ),
              DailyActivitiesWidget(),
              CalorieChartWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
