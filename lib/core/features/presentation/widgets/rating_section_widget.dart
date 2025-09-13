import 'package:flutter/material.dart';

class RatingsSectionWidget extends StatelessWidget {
  const RatingsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // You can tweak these values or fetch them from Firestore later
    const metrics = <_Metric>[
      _Metric(value: '10,000+', label: 'Active Users in\nSingapore'),
      _Metric(value: '4.6★',   label: 'Average Rating\nfrom Test Users'),
      _Metric(value: '3,200+',  label: 'Challenges\nCompleted in\nBeta'),
      _Metric(value: '2,000+',  label: 'Fitness\nProfessionals'),
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Trusted by Fitness Enthusiasts Worldwide',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 28),
              // Responsive row of cards
              Wrap(
                spacing: 24,      // horizontal gap
                runSpacing: 24,   // vertical wrap gap
                alignment: WrapAlignment.center,
                children: metrics
                    .map((m) => _MetricCard(metric: m))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final _Metric metric;
  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    // fixed width for nice grid feel; wrap will handle smaller screens
    return SizedBox(
      width: 320,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              metric.value,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              metric.label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric {
  final String value;
  final String label;
  const _Metric({required this.value, required this.label});
}
