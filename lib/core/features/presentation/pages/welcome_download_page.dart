import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:my_website/core/features/presentation/widgets/background_widget.dart';
import 'package:my_website/core/features/presentation/widgets/navbar_widget.dart';
import 'package:my_website/core/features/presentation/pages/home_page.dart';

class WelcomeDownloadPage extends StatelessWidget {
  const WelcomeDownloadPage({super.key});

  static const path = '/welcome';

  @override
  Widget build(BuildContext context) {
    // Read "name" from GoRouter extras; fallback if missing
    final extra = GoRouterState.of(context).extra;
    final String name =
        (extra is Map && extra['name'] is String && (extra['name'] as String).trim().isNotEmpty)
            ? (extra['name'] as String).trim()
            : 'there';

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundWidget(),
          SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const NavbarWidget(),
                    const SizedBox(height: 24),

                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.96),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
                          child: Column(
                            children: [
                              // Logo
                              SizedBox(
                                height: 56,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'WISE WORKOUT',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              Text(
                                'Welcome $name!',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 12),

                              Text(
                                'Your one-stop solution to fitness, wellness, and motivation.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.black54),
                              ),
                              const SizedBox(height: 12),

                              Text(
                                'Click the download button below to start the download:',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.black45),
                              ),
                              const SizedBox(height: 28),

                              Wrap(
                                spacing: 20,
                                runSpacing: 12,
                                alignment: WrapAlignment.center,
                                children: [
                                  _DownloadPill(
                                    label: 'App Store',
                                    onTap: () => _openUrl('https://apps.apple.com/'),
                                  ),
                                  _DownloadPill(
                                    label: 'Google Play',
                                    onTap: () => _openUrl('https://play.google.com/'),
                                  ),
                                  _DownloadPill(
                                    label: 'Download APK',
                                    onTap: () => _openUrl('https://example.com/app.apk'),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 28),
                              TextButton(
                                onPressed: () => context.go(HomePage.path),
                                child: const Text('Back to homescreen'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _DownloadPill extends StatelessWidget {
  const _DownloadPill({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: FilledButton.tonal(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label),
      ),
    );
  }
}
