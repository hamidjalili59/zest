// src/features/home/presentation/widgets/calorie_chart.dart
import 'dart:math' show pi;
import 'package:flutter/material.dart';

class RadialProgressChart extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Paint progressPaint;
  final Paint trackPaint;
  final Widget centerWidget;

  const RadialProgressChart({
    super.key,
    required this.progress,
    required this.centerWidget,
    required this.progressPaint,
    required this.trackPaint,
    this.size = 180.0,
    this.strokeWidth = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RadialChartPainter(
              progress: progress,
              strokeWidth: strokeWidth,
              progressPaint: progressPaint,
              trackPaint: trackPaint,
            ),
          ),
        ),
        centerWidget,
      ],
    );
  }
}

class _RadialChartPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Paint progressPaint;
  final Paint trackPaint;

  _RadialChartPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressPaint,
    required this.trackPaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    // track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * pi,
      false,
      trackPaint,
    );

    // progress
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadialChartPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        strokeWidth != oldDelegate.strokeWidth ||
        progressPaint != oldDelegate.progressPaint ||
        trackPaint != oldDelegate.trackPaint;
  }
}
