import 'dart:math';

import 'package:flutter/material.dart';

class RadialProgressChart extends StatelessWidget {
  final double progress;

  final double size;

  final double strokeWidth;

  final Paint progressPaint;

  final Color trackColor;

  final Widget centerWidget;

  const RadialProgressChart({
    super.key,
    required this.progress,
    required this.centerWidget,
    this.size = 180.0,
    this.strokeWidth = 15.0,
    required this.progressPaint,
    this.trackColor = Colors.black26,
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
              trackColor: trackColor,
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
  final Color trackColor;

  _RadialChartPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressPaint,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * pi,
      false,
      trackPaint,
    );

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
        trackColor != oldDelegate.trackColor;
  }
}
