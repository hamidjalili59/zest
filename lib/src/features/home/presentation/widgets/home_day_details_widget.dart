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
    const double progress = 0.92;
    const double size = 180.0;
    const double strokeWidth = 18.0;
    final radius = (size - strokeWidth) / 2;
    final center = Offset(size / 2, size / 2);

    const rotationAngle = -pi / 2;

    final trackPaint = Paint()
      ..shader = const SweepGradient(
        colors: [Color(0xFFFE6D32), Color(0xFFFF723C)],
        transform: GradientRotation(rotationAngle),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = const SweepGradient(
        colors: [Color(0xFF3AB791), Color(0xFF48CBA3)],
        transform: GradientRotation(rotationAngle),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    return RadialProgressChart(
      progress: progress,
      size: size,
      strokeWidth: strokeWidth,
      progressPaint: progressPaint,
      trackPaint: trackPaint,
      centerWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D4F61),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Calories',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF5A6B7B),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
