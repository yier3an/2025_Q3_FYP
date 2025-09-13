import 'package:flutter/material.dart';
import 'package:my_website/core/features/presentation/widgets/background_widget.dart';
import 'package:my_website/core/features/presentation/widgets/features_section_widget.dart';
import 'package:my_website/core/features/presentation/widgets/footer_widget.dart';
import 'package:my_website/core/features/presentation/widgets/navbar_widget.dart';
import 'package:my_website/core/features/presentation/widgets/hero_section_widget.dart';
import 'package:my_website/core/features/presentation/widgets/pricing_section_widget.dart';
import 'package:my_website/core/features/presentation/widgets/rating_section_widget.dart';
import 'package:my_website/core/features/presentation/widgets/review_widget.dart';
import 'package:my_website/core/features/presentation/widgets/video_section_widget.dart';
import 'package:my_website/core/features/presentation/pages/login_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  static const String path = '/home';

  // Keys for sections
  final heroKey = GlobalKey();
  final ratingsKey = GlobalKey();
  final featuresKey = GlobalKey();
  final videoKey = GlobalKey();
  final reviewKey = GlobalKey();
  final pricingKey = GlobalKey();
  final footerKey = GlobalKey();

  // Helper to scroll to a section
  void _scrollToSection(GlobalKey key){
    final ctx = key.currentContext;
    if(ctx != null){
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
Widget build(BuildContext context) {
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
                  NavbarWidget(
                    onHomePressed:      () => _scrollToSection(heroKey),
                    onFeaturesPressed:  () => _scrollToSection(featuresKey),
                    onScreenshotsPressed: () => _scrollToSection(videoKey),
                    onFaqPressed:       () => _scrollToSection(reviewKey),
                    onPricingPressed:   () => _scrollToSection(pricingKey),
                    onContactPressed:   () => _scrollToSection(footerKey),
                    //onLoginPressed:     () => context.go(LoginPage.path),
                  ),

                  const SizedBox(height: 16),

                  HeroSectionWidget(
                    onGetStarted: () => _scrollToSection(pricingKey),
                    ctaBg: Colors.white,
                    ctaFg: Colors.black87,
                  ),
                  
                  const SizedBox(height: 48),

                  RatingsSectionWidget(key: ratingsKey),
                  const SizedBox(height: 48),

                  FeaturesSectionWidget(key: featuresKey),
                  const SizedBox(height: 48),

                  VideoSectionWidget(key: videoKey),
                  const SizedBox(height: 48),

                  ReviewSectionWidget(key: reviewKey),
                  const SizedBox(height: 48),

                  PricingSectionWidget(key: pricingKey),
                  const SizedBox(height: 48),

                  FooterSectionWidget(key: footerKey),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

}
