import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zest/src/core/constants/app_theme.dart';

// const _cardBg = Color(0x0FFFFFFF);

class DailyActivitiesWidget extends StatelessWidget {
  const DailyActivitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'title': 'دوچرخه',
        'color': Colors.green,
        'icon': Icons.directions_bike,
        'value': '30 min',
      },
      {
        'title': 'شنا',
        'color': Colors.orange,
        'icon': Icons.pool,
        'value': '20 min',
      },
      {
        'title': 'پیاده‌روی',
        'color': Colors.teal,
        'icon': Icons.directions_walk,
        'value': '40 min',
      },
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(0.03.toAlpha()),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today Activities',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...activities.map((a) => _ActivityRow(a)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final Map a;
  const _ActivityRow(this.a);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: (a['color'] as Color).withAlpha(0.12.toAlpha()),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(a['icon'] as IconData, color: a['color'] as Color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              a['title'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            a['value'] as String,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
