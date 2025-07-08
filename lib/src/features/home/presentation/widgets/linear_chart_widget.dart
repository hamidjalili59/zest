import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:zest/src/core/constants/app_theme.dart';

class CalorieChartWidget extends StatefulWidget {
  const CalorieChartWidget({super.key});

  @override
  State<CalorieChartWidget> createState() => _CalorieChartWidgetState();
}

class _CalorieChartWidgetState extends State<CalorieChartWidget> {
  double _percentage = 88.0;
  bool _showSecondaryChart = true;

  // داده‌های نمودار اصلی (سبز)
  final List<double> _primaryChartData = [0.1, 0.2, 0.6, 0.4, 0.8, 0.75, 0.85];
  // داده‌های نمودار دوم (نارنجی)
  final List<double> _secondaryChartData = [0.3, 0.4, 0.35, 0.5, 0.45, 0.6, 0.55];

  final List<String> _dayLabels = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calories Burned',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_percentage.toInt()}%',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: CustomPaint(
              painter: _ChartPainter(
                primaryData: _primaryChartData,
                secondaryData: _secondaryChartData,
                showSecondary: _showSecondaryChart,
                labels: _dayLabels,
                progress: _percentage / 100.0,
              ),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 20),
          Slider(
            value: _percentage,
            min: 0,
            max: 100,
            divisions: 100,
            label: '${_percentage.toInt()}%',
            activeColor: const Color(0xFF35C6A0),
            inactiveColor: const Color(0xFF35C6A0).withOpacity(0.2),
            onChanged: (double value) {
              setState(() {
                _percentage = value;
              });
            },
          ),
          // سوییچ برای کنترل نمایش نمودار دوم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Show Previous Week',
                style: TextStyle(color: Colors.black54),
              ),
              Switch(
                value: _showSecondaryChart,
                onChanged: (bool value) {
                  setState(() {
                    _showSecondaryChart = value;
                  });
                },
                activeColor: const Color(0xFFFE6D32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> primaryData;
  final List<double>? secondaryData;
  final bool showSecondary;
  final List<String> labels;
  final double progress;

  _ChartPainter({
    required this.primaryData,
    this.secondaryData,
    this.showSecondary = false,
    required this.labels,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final chartHeight = size.height * 0.8;
    final labelHeight = size.height * 0.2;

    // ترسیم نمودار دوم (نارنجی) در پس‌زمینه - اگر فعال باشد
    if (showSecondary && secondaryData != null) {
      final orangeLinePaint = Paint()
        ..color = const Color(0xFFFE6D32)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      final orangeFillPaint = Paint()
        ..style = PaintingStyle.fill
        ..shader = ui.Gradient.linear(
          Offset(0, 0),
          Offset(0, chartHeight),
          [
            const Color(0xFFFF723C).withOpacity(0.4),
            const Color(0xFFFE6D32).withOpacity(0.0),
          ],
        );
      _drawChartLine(canvas, size, secondaryData!, orangeLinePaint, orangeFillPaint, progress);
    }

    // ترسیم نمودار اصلی (سبز)
    final greenLinePaint = Paint()
      ..color = const Color(0xFF35C6A0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final greenFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, chartHeight),
        [
          const Color(0xFF35C6A0).withOpacity(0.4),
          const Color(0xFF35C6A0).withOpacity(0.0),
        ],
      );
    _drawChartLine(canvas, size, primaryData, greenLinePaint, greenFillPaint, progress);

    // ترسیم لیبل‌های محور X
    _drawLabels(canvas, size, progress);
  }

  // تابع کمکی برای ترسیم یک خط نمودار
  void _drawChartLine(Canvas canvas, Size size, List<double> data, Paint linePaint, Paint fillPaint, double progress) {
    final chartHeight = size.height * 0.8;
    final linePath = Path();
    final fillPath = Path();
    final stepX = size.width / (data.length - 1);
    final visibleDataCount = (data.length * progress).ceil();

    if (visibleDataCount < 2) return;

    final points = <Offset>[];
    for (int i = 0; i < visibleDataCount; i++) {
      final x = stepX * i;
      final y = chartHeight - data[i] * chartHeight;
      points.add(Offset(x, y));
    }

    linePath.moveTo(points.first.dx, points.first.dy);
    fillPath.moveTo(points.first.dx, chartHeight);
    fillPath.lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = (i + 2 < points.length) ? points[i + 2] : p2;

      final cp1x = p1.dx + (p2.dx - p0.dx) / 6;
      final cp1y = p1.dy + (p2.dy - p0.dy) / 6;
      final cp2x = p2.dx - (p3.dx - p1.dx) / 6;
      final cp2y = p2.dy - (p3.dy - p1.dy) / 6;

      linePath.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
      fillPath.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
    }

    fillPath.lineTo(points.last.dx, chartHeight);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  // تابع کمکی برای ترسیم لیبل‌ها
  void _drawLabels(Canvas canvas, Size size, double progress) {
    final chartHeight = size.height * 0.8;
    final labelHeight = size.height * 0.2;
    final stepX = size.width / (labels.length - 1);
    final visibleLabelCount = (labels.length * progress).ceil();

    for (int i = 0; i < visibleLabelCount; i++) {
      final label = labels[i];
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final x = stepX * i - textPainter.width / 2;
      final y = chartHeight + labelHeight * 0.2;
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return primaryData != oldDelegate.primaryData ||
        secondaryData != oldDelegate.secondaryData ||
        showSecondary != oldDelegate.showSecondary ||
        progress != oldDelegate.progress;
  }
}