import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/side_nav.dart';
import '../widgets/metric_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideNav(currentRoute: '/dashboard'),
          Expanded(
            child: Container(
              decoration: AppTheme.dashboardGradient,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  margin: const EdgeInsets.all(22),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          const Text('Admin Dashboard',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                          const Spacer(),
                          FilledButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text('Quick Metrics',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),

                      const SizedBox(height: 10),
                      // Metric cards
                      LayoutBuilder(
                        builder: (context, c) {
                          final isNarrow = c.maxWidth < 900;
                          return GridView.count(
                            crossAxisCount: isNarrow ? 2 : 4,
                            shrinkWrap: true,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.8,
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
                              MetricCard(icon: Icons.download_outlined, value: '12,281', label: 'Total Downloads'),
                              MetricCard(icon: Icons.attach_money, value: '\$12,982', label: 'Sales'),
                              MetricCard(icon: Icons.chat_bubble_outline, value: '12,281', label: 'Comments'),
                              MetricCard(icon: Icons.person_3_outlined, value: '2032', label: 'Number of Reports'),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Charts
                      LayoutBuilder(
                        builder: (_, c) {
                          final isStack = c.maxWidth < 1100;
                          return isStack
                              ? Column(
                                  children: [
                                    _AreaChartCard(),
                                    const SizedBox(height: 16),
                                    _DonutCard(),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Expanded(child: _AreaChartCard()),
                                    SizedBox(width: 16),
                                    SizedBox(width: 380, child: _DonutCard()),
                                  ],
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AreaChartCard extends StatelessWidget {
  const _AreaChartCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minX: 0, maxX: 6, minY: 0, maxY: 20,
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                  const labels = ['2013','2014','2015','2016','2017','2018','2019'];
                  final idx = v.toInt().clamp(0, labels.length - 1);
                  return Text(labels[idx], style: const TextStyle(fontSize: 10));
                })),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: AppTheme.purple,
                  barWidth: 3,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [AppTheme.purple.withOpacity(.35), Colors.transparent],
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    ),
                  ),
                  spots: const [
                    FlSpot(0, 5), FlSpot(1, 14), FlSpot(2, 18),
                    FlSpot(3, 2), FlSpot(4, 3), FlSpot(5, 5), FlSpot(6, 6),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DonutCard extends StatelessWidget {
  const _DonutCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 260,
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 52,
              sections: [
                PieChartSectionData(value: 40, title: 'Pink', color: const Color(0xFFFF8AAE), radius: 80),
                PieChartSectionData(value: 35, title: 'Blue', color: const Color(0xFF8AB4FF), radius: 80),
                PieChartSectionData(value: 25, title: 'Yellow', color: const Color(0xFFFFDE6B), radius: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
