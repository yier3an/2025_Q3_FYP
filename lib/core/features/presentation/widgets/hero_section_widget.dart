import 'package:flutter/material.dart';
import 'package:my_website/core/utils/context_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSectionWidget extends StatelessWidget {
  const HeroSectionWidget({
    super.key,
    this.onGetStarted,
    this.ctaBg,
    this.ctaFg,
  });

  /// Called when "Get Started" is tapped
  final VoidCallback? onGetStarted;

  /// Button colors (optional)
  final Color? ctaBg; // background
  final Color? ctaFg; // text/icon

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 40 : 80,
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextSection(context),
                const SizedBox(height: 32),
                Image.asset(
                  'assets/images/app_screenshots/fypPromoPic.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 2, child: _buildTextSection(context)),
                const SizedBox(width: 40),
                Expanded(
                  flex: 3,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 520),
                    child: Image.asset(
                      'assets/images/app_screenshots/fypPromoPic.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTextSection(BuildContext context) {
    final bool isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'App That Pushes You',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: isMobile ? double.infinity : 500,
          child: Text(
            "Make workouts engaging and fun with Wise Workout.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                  height: 1.6,
                ),
          ),
        ),
        const SizedBox(height: 32),

        Wrap(
          spacing: 16,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // << Get Started button (now colorable + calls onGetStarted) >>
            SizedBox(
              width: 160,
              height: 50,
              child: FilledButton(
                onPressed: onGetStarted,
                style: FilledButton.styleFrom(
                  backgroundColor: ctaBg ?? Colors.white,
                  foregroundColor: ctaFg ?? Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Get Started'),
              ),
            ),

            // Watch Video
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () async {
                  final url = Uri.parse(
                      'https://www.youtube.com/');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_outline),
                    SizedBox(width: 8),
                    Text('Watch Video'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
