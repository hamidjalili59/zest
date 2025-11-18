import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zest/src/core/constants/app_theme.dart';
import 'package:zest/src/core/constants/router_paths.dart';
import 'package:zest/src/features/home/presentation/widgets/day_counter_widget.dart';
import 'package:zest/src/features/home/presentation/widgets/home_day_details_widget.dart';
import 'package:zest/src/features/home/presentation/widgets/daily_activities_widget.dart';
import 'package:zest/src/features/home/presentation/widgets/home_scaffold_widget.dart';
import 'package:zest/src/features/home/presentation/widgets/linear_chart_widget.dart';

// const _kBg = Color(0xFF0F1216);
// const _kGlass = Color(0x1AFFFFFF); // opacity small
const _kGlassBorder = Color(0x22FFFFFF);
const _kAccent1 = Color(0xFF22D3EE);
const _kAccent2 = Color(0xFF22C55E);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;
    return HomeScaffold(
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -60,
            child: _Blob(size: 260, colors: [_kAccent1, _kAccent2]),
          ),
          Positioned(
            bottom: -120,
            right: -90,
            child: _Blob(size: 320, colors: [_kAccent2, _kAccent1]),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const _TitleAndSubtitle(),
                      const Spacer(),
                      _ProfileAction(),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Content
                  Expanded(child: isWide ? _DesktopLayout() : _MobileLayout()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.colors});
  final double size;
  final List<Color> colors;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: colors.map((c) => c.withAlpha(0.25.toAlpha())).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleAndSubtitle extends StatelessWidget {
  const _TitleAndSubtitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Zest',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [_kAccent1, _kAccent2],
              ).createShader(Rect.fromLTWH(0, 0, 200, 0)),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Dashboard — رژیم و فعالیتِ امروز',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}

class _ProfileAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(0.04.toAlpha()),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _kGlassBorder),
          ),
          child: Row(
            children: const [
              Icon(
                Icons.calendar_today_outlined,
                color: Colors.white70,
                size: 18,
              ),
              SizedBox(width: 8),
              Text('هفتگی', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () => context.push(RouterPaths.mealSuggestions),
          style: ElevatedButton.styleFrom(
            backgroundColor: _kAccent1,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          icon: const Icon(Icons.auto_awesome, size: 18),
          label: const Text('AI Meals'),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white12,
          child: const Icon(Icons.person, color: Colors.white70),
        ),
      ],
    );
  }
}

/// Desktop layout: three columns
class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // left column
        Flexible(
          flex: 3,
          child: Column(
            children: const [
              DayCounterWidget(),
              SizedBox(height: 18),
              HomeDayDetailsWidget(), // radial card
            ],
          ),
        ),
        const SizedBox(width: 18),
        // center column (main)
        Flexible(
          flex: 5,
          child: SingleChildScrollView(
            child: Column(
              children: const [
                CalorieChartWidget(), // large chart card
                SizedBox(height: 18),
                DailyActivitiesWidget(),
              ],
            ),
          ),
        ),
        const SizedBox(width: 18),
        // right column
        Flexible(
          flex: 3,
          child: Column(
            children: const [
              _MiniInfoCard(title: 'Weekly Activity'),
              SizedBox(height: 18),
              _MiniInfoCard(title: 'Water Intake'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mobile layout (stacked)
class _MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        DayCounterWidget(),
        SizedBox(height: 12),
        HomeDayDetailsWidget(),
        SizedBox(height: 12),
        CalorieChartWidget(),
        SizedBox(height: 12),
        DailyActivitiesWidget(),
        SizedBox(height: 12),
        _MiniInfoCard(title: 'Weekly Activity'),
        SizedBox(height: 32),
      ],
    );
  }
}

/// یک کارت ساده‌ی اطلاعاتی (قابل توسعه)
class _MiniInfoCard extends StatelessWidget {
  final String title;
  const _MiniInfoCard({required this.title});
  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      height: null,
      width: null,
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '99%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [_kAccent1, _kAccent2],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _kAccent2.withAlpha(0.3.toAlpha()),
                        blurRadius: 8,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.show_chart, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// کامپوننت کارت شیشه‌ای مشترک
class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  const _GlassCard({
    required this.child,
    this.padding,
    this.width,
    this.height,
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(0.03.toAlpha()),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _kGlassBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 20,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
