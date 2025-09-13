import 'package:flutter/material.dart';
import 'package:my_website/core/features/presentation/pages/signup_page.dart';
import 'package:go_router/go_router.dart';

class PricingSectionWidget extends StatelessWidget {
  const PricingSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Choose Your Plan',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: const [
                  _PlanCard(
                    accent: Color(0xFFBFC7FF),
                    headerIcon: Icons.person,
                    title: 'Basic',
                    priceLine: 'Free (Forever)',
                    features: [
                      'Create account & personalized profile',
                      'Daily workout plans (basic)',
                      'Manual workout logging',
                      'Smart reminders (workout & rest)',
                      'Basic analytics (weekly summary, streaks)',
                      'Explore nearby exercise corners & gyms',
                      'Social feed: share, like & comment',
                      'Follow friends and view activities',
                    ],
                  ),
                  _PlanCard(
                    accent: Color(0xFF8FA2FF),
                    headerIcon: Icons.star,
                    title: 'Wise Workout Plus',
                    priceLine: 'S\$5.99/mo  |  S\$49.99/yr',
                    highlighted: true,
                    features: [
                      'Wearable integration (Fitbit, Garmin, Apple Watch)',
                      'Advanced analytics (graphs, comparisons, heatmaps)',
                      'Goal streak tracking with deeper insights',
                      'Custom workout templates (save & reuse)',
                      'Pro content access (verified trainers)',
                      'Priority support',
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Color accent;
  final IconData headerIcon;
  final String title;
  final String priceLine;
  final List<String> features;
  final bool highlighted;

  const _PlanCard({
    required this.accent,
    required this.headerIcon,
    required this.title,
    required this.priceLine,
    required this.features,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Colors.white.withOpacity(highlighted ? 0.18 : 0.12);

    return SizedBox(
      width: 420,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withOpacity(0.35), width: highlighted ? 2 : 1),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: accent.withOpacity(0.25),
                  child: Icon(headerIcon, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              priceLine,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, size: 18, color: Colors.lightGreenAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                              height: 1.4,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: () {
                  context.go(SignUpPage.path);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.9)),
                  foregroundColor: const WidgetStatePropertyAll(Colors.black87),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                ),
                child: const Text('Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
