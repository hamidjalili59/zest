import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:zest/src/features/home/presentation/widgets/calorie_chart.dart';

const _accentA = Color(0xFF22D3EE);
const _accentB = Color(0xFF22C55E);

class HomeDayDetailsWidget extends StatelessWidget {
  const HomeDayDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const double progress = 0.72;
    const double size = 190.0;
    const double strokeWidth = 18.0;
    final radius = (size - strokeWidth) / 2;
    final center = Offset(size / 2, size / 2);
    const rotationAngle = -pi / 2;

    final trackPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = const SweepGradient(
        colors: [_accentA, _accentB],
        transform: GradientRotation(rotationAngle),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    return Center(
      child: RadialProgressChart(
        progress: progress,
        size: size,
        strokeWidth: strokeWidth,
        progressPaint: progressPaint,
        trackPaint: trackPaint,
        centerWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              '72%',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text('Calories', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
