import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:zest/src/features/home/presentation/widgets/calorie_chart.dart';

class HomeDayDetailsWidget extends StatefulWidget {
  const HomeDayDetailsWidget({super.key});

  @override
  State<HomeDayDetailsWidget> createState() => _HomeDayDetailWidgetState();
}

class _HomeDayDetailWidgetState extends State<HomeDayDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return const CalorieCounter();
  }
}

class CalorieCounter extends StatefulWidget {
  const CalorieCounter({super.key});

  @override
  State<CalorieCounter> createState() => _CalorieCounterState();
}

class _CalorieCounterState extends State<CalorieCounter> {
  @override
  Widget build(BuildContext context) {
    const progress = 0.92;
    return RadialProgressChart(
      progress: progress,
      size: 180,
      strokeWidth: 18,
      progressPaint: Paint()
        ..shader =
            const SweepGradient(
              colors: [Color(0xFF3cff8f), Color(0xFF289e5b)],
              startAngle: -pi / 2,
              endAngle: (2 * pi) * 0.8,
            ).createShader(
              Rect.fromCircle(
                center: const Offset(90, 90),
                radius: (180 - 18) / 2,
              ),
            )
        ..strokeWidth = 18
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt,
      trackColor: const Color(0xFF2c3e50),
      centerWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.black26,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Calories',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black26,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final int y;
  final int x;
  final String text;
  final Color color;

  ChartData(this.y, this.x, this.text, this.color);
}
