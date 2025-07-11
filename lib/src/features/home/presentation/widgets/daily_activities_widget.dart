import 'package:flutter/material.dart';
import 'package:zest/src/core/constants/app_theme.dart';

class DailyActivitiesWidget extends StatelessWidget {
  const DailyActivitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'title': 'cycling',
        'color': Colors.green,
        'icon': Icons.cyclone_outlined,
        'value': '30 min',
      },
      {
        'title': 'push-ups',
        'color': Colors.blue,
        'icon': Icons.hdr_strong_outlined,
        'value': '10 x 3',
      },
      {
        'title': 'crunches',
        'color': Colors.green,
        'icon': Icons.sports_gymnastics_outlined,
        'value': '25 x 3',
      },
    ];
    return Container(
      width: 350,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(0.05.toAlpha()),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today Activities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 64,
                child: Row(
                  spacing: 24,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ColoredBox(
                        color: (activities[index]['color'] as Color).withAlpha(
                          80,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            activities[index]['icon'] as IconData,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        activities[index]['title'] as String,
                        style: TextTheme.of(context).titleMedium,
                      ),
                    ),
                    Text(
                      activities[index]['value'] as String,
                      style: TextTheme.of(context).bodyMedium?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
