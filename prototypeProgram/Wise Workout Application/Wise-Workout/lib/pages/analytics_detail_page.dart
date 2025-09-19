import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsDetailPage extends StatelessWidget {
  final String title;
  final List<double> data; // 7 values for last 7 days
  final String unit;       // e.g., "km", "kcal", "sessions"

  const AnalyticsDetailPage({
    super.key,
    required this.title,
    required this.data,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = data.isEmpty ? 0.0 : data.reduce((a, b) => a > b ? a : b);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last 7 days', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (maxVal == 0 ? 1 : maxVal * 1.2),
                  barTouchData: BarTouchData(enabled: true),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, meta) {
                          const days = ['M','T','W','T','F','S','S'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(days[v.toInt() % days.length]),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: data.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value,
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.purple,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total: ${data.fold<double>(0, (s, v) => s + v).toStringAsFixed(1)} $unit',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
