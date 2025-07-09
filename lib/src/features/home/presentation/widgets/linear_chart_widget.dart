import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:zest/src/core/constants/app_theme.dart';

class CalorieChartWidget extends StatefulWidget {
  const CalorieChartWidget({super.key});

  @override
  State<CalorieChartWidget> createState() => _CalorieChartWidgetState();
}

class _CalorieChartWidgetState extends State<CalorieChartWidget> {
  double _percentage = 88.0;
  bool _showSecondaryChart = true;

  final List<double> _primaryChartData = [0.1, 0.2, 0.6, 0.4, 0.8, 0.75, 0.85];
  final List<double> _secondaryChartData = [
    0.3,
    0.4,
    0.35,
    0.5,
    0.45,
    0.6,
    0.55,
  ];
  final List<String> _dayLabels = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];

  OverlayEntry? _overlayEntry;
  int? _tappedIndex;
  ChartType? _tappedChartType;

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showOverlay(BuildContext context, Offset globalPosition) {
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: globalPosition.dx + 10,
        top: globalPosition.dy - 30,
        child: Material(
          color: Colors.transparent,
          child: _tappedIndex != null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${_dayLabels[_tappedIndex!]} - '
                    '${_tappedChartType == ChartType.primary ? (_primaryChartData[_tappedIndex!] * 100).toInt() : (_secondaryChartData[_tappedIndex!] * 100).toInt()}%',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _tappedIndex = null;
      _tappedChartType = null;
    });
  }

  void _handleInteraction(Offset localPosition, Offset globalPosition) {
    // از localPosition برای محاسبه ایندکس نقطه در نمودار استفاده می‌کنیم.
    // مطمئن می‌شویم که localPosition در محدوده نمودار است.
    if (localPosition.dx < 0 ||
        localPosition.dx > 350 || // 350 عرض تقریبی Container
        localPosition.dy < 0 ||
        localPosition.dy > 120) {
      // 120 ارتفاع CustomPaint
      _hideOverlay();
      return;
    }

    final chartWidth = 350.0 - 2 * 24.0; // عرض نمودار بدون padding اصلی
    final stepX = chartWidth / (_primaryChartData.length - 1);
    final chartHeight = 120 * 0.8; // ارتفاع واقعی نمودار برای نقاط

    final index = (localPosition.dx / stepX).round().clamp(
      0,
      _primaryChartData.length - 1,
    );

    double primaryY = chartHeight - _primaryChartData[index] * chartHeight;
    double secondaryY = _showSecondaryChart
        ? chartHeight - _secondaryChartData[index] * chartHeight
        : double.infinity;

    ChartType currentChartType;
    if ((localPosition.dy - primaryY).abs() <
        (localPosition.dy - secondaryY).abs()) {
      currentChartType = ChartType.primary;
    } else {
      currentChartType = ChartType.secondary;
    }

    // فقط در صورتی که ایندکس یا نوع نمودار تغییر کرده باشد، setState را فراخوانی می‌کنیم
    // این کار از بازسازی‌های غیرضروری جلوگیری می‌کند.
    if (_tappedIndex != index || _tappedChartType != currentChartType) {
      setState(() {
        _tappedIndex = index;
        _tappedChartType = currentChartType;
      });
    }
    _showOverlay(context, globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the platform is web/desktop or mobile
    final isDesktopOrWeb =
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.fuchsia;

    return Container(
      width: 350,
      padding: const EdgeInsets.all(24.0),
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
          // Wrap CustomPaint with MouseRegion and GestureDetector
          MouseRegion(
            onHover: isDesktopOrWeb
                ? (details) {
                    _handleInteraction(details.localPosition, details.position);
                  }
                : null,
            onExit: isDesktopOrWeb
                ? (details) {
                    _hideOverlay();
                  }
                : null,
            child: GestureDetector(
              onPanDown: !isDesktopOrWeb
                  ? (details) {
                      _handleInteraction(
                        details.localPosition,
                        details.globalPosition,
                      );
                    }
                  : null,
              onPanUpdate: !isDesktopOrWeb
                  ? (details) {
                      _handleInteraction(
                        details.localPosition,
                        details.globalPosition,
                      );
                    }
                  : null,
              onPanEnd: !isDesktopOrWeb
                  ? (details) {
                      _hideOverlay();
                    }
                  : null,
              onTapUp: !isDesktopOrWeb
                  ? (details) {
                      // برای زمانی که فقط یک Tap کوتاه انجام می‌شود، overlay را پنهان کنید
                      _hideOverlay();
                    }
                  : null,
              child: SizedBox(
                height: 120,
                child: CustomPaint(
                  painter: _ChartPainter(
                    primaryData: _primaryChartData,
                    secondaryData: _secondaryChartData,
                    showSecondary: _showSecondaryChart,
                    labels: _dayLabels,
                    progress: _percentage / 100.0,
                    tappedIndex: _tappedIndex,
                    tappedChartType: _tappedChartType,
                  ),
                  size: Size.infinite,
                ),
              ),
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
            inactiveColor: const Color(0xFF35C6A0).withAlpha(0.2.toAlpha()),
            onChanged: (double value) {
              setState(() {
                _percentage = value;
              });
            },
          ),
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

enum ChartType { primary, secondary }

class _ChartPainter extends CustomPainter {
  final List<double> primaryData;
  final List<double>? secondaryData;
  final bool showSecondary;
  final List<String> labels;
  final double progress;
  final int? tappedIndex;
  final ChartType? tappedChartType;

  _ChartPainter({
    required this.primaryData,
    this.secondaryData,
    this.showSecondary = false,
    required this.labels,
    required this.progress,
    this.tappedIndex,
    this.tappedChartType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final chartHeight = size.height * 0.8;
    //final labelHeight = size.height * 0.2; // این متغیر در اینجا مستقیماً استفاده نمی‌شود

    if (showSecondary && secondaryData != null) {
      final orangeLinePaint = Paint()
        ..color = const Color(0xFFFE6D32)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      final orangeFillPaint = Paint()
        ..style = PaintingStyle.fill
        ..shader =
            ui.Gradient.linear(const Offset(0, 0), Offset(0, chartHeight), [
              const Color(0xFFFF723C).withAlpha(0.4.toAlpha()),
              const Color(0xFFFE6D32).withAlpha(0.0.toAlpha()),
            ]);
      _drawChartLine(
        canvas,
        size,
        secondaryData!,
        orangeLinePaint,
        orangeFillPaint,
        progress,
        ChartType.secondary,
      );
    }

    final greenLinePaint = Paint()
      ..color = const Color(0xFF35C6A0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final greenFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader =
          ui.Gradient.linear(const Offset(0, 0), Offset(0, chartHeight), [
            const Color(0xFF35C6A0).withAlpha(0.4.toAlpha()),
            const Color(0xFF35C6A0).withAlpha(0.0.toAlpha()),
          ]);
    _drawChartLine(
      canvas,
      size,
      primaryData,
      greenLinePaint,
      greenFillPaint,
      progress,
      ChartType.primary,
    );

    _drawLabels(canvas, size, progress);

    if (tappedIndex != null) {
      final stepX = size.width / (primaryData.length - 1);
      final x = stepX * tappedIndex!;
      double y;
      Color dotColor;

      if (tappedChartType == ChartType.primary) {
        y = chartHeight - primaryData[tappedIndex!] * chartHeight;
        dotColor = const Color(0xFF35C6A0);
      } else if (tappedChartType == ChartType.secondary &&
          secondaryData != null) {
        y = chartHeight - secondaryData![tappedIndex!] * chartHeight;
        dotColor = const Color(0xFFFE6D32);
      } else {
        return;
      }

      final dotPaint = Paint()
        ..color = dotColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 5.0, dotPaint);
    }
  }

  void _drawChartLine(
    Canvas canvas,
    Size size,
    List<double> data,
    Paint linePaint,
    Paint fillPaint,
    double progress,
    ChartType chartType,
  ) {
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
        progress != oldDelegate.progress ||
        tappedIndex != oldDelegate.tappedIndex ||
        tappedChartType != oldDelegate.tappedChartType;
  }
}
