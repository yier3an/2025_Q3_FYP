
import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/simple_line_chart.dart';
import '../widgets/simple_donut_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Light purple for the small metric squares
    final lightPurple = const Color(0xFFEAE1FF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Metrics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  // Row of four small squares inside Quick Metrics
                  Row(
                    children: [
                      Expanded(child: StatCard(title: 'Total Clients', value: '281', icon: Icons.people_alt, background: lightPurple, square: true)),
                      const SizedBox(width: 16),
                      Expanded(child: StatCard(title: 'Positive Reviews', value: '92', icon: Icons.thumb_up_alt_outlined, background: lightPurple, square: true)),
                      const SizedBox(width: 16),
                      Expanded(child: StatCard(title: 'Chats', value: '23', icon: Icons.chat_bubble_outline, background: lightPurple, square: true)),
                      const SizedBox(width: 16),
                      Expanded(child: StatCard(title: 'Cases completed', value: '712', icon: Icons.verified_outlined, background: lightPurple, square: true)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Example charts area to mimic your mockups
                  Expanded(
                    child: Row(
                      children: const [
                        Expanded(child: SimpleLineChart(data: [3, 8, 5, 12, 7, 9, 14, 10])),
                        SizedBox(width: 16),
                        Expanded(child: SimpleDonutChart(values: [45, 30, 15, 10], labels: ['Pink', 'Blue', 'Yellow', 'Purple'])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
