import 'package:flutter/material.dart';

class ReviewSectionWidget extends StatefulWidget {
  const ReviewSectionWidget({super.key});

  @override
  State<ReviewSectionWidget> createState() => _ReviewSectionWidgetState();
}

class _ReviewSectionWidgetState extends State<ReviewSectionWidget> {
  late PageController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sample data — swap with Firestore later
    const reviews = <_Review>[
      _Review('Sarah L.', 'Super fast and responsive. Shipped in weeks.'),
      _Review('Marcus T.', 'UI is clean and smooth. Great iteration speed.'),
      _Review('Jeanine K.', 'Loved the polish and attention to detail!'),
      _Review('Aman P.', 'Performance is great even on older phones.'),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        // Responsive “cards-per-screen” via viewportFraction
        final w = c.maxWidth;
        final fraction = w >= 1100 ? 0.33 : (w >= 750 ? 0.48 : 0.9);

        // Create controller per layout to keep fraction in sync
        _controller = PageController(viewportFraction: fraction);

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Testimonials',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Carousel
                  SizedBox(
                    height: 220,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: reviews.length,
                      padEnds: false,
                      itemBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _ReviewCard(reviews[i]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final _Review r;
  const _ReviewCard(this.r);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(radius: 20), // placeholder avatar
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          )),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      r.text,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                                height: 1.5,
                              ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < 5 ? Icons.star : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Review {
  final String name;
  final String text;
  const _Review(this.name, this.text);
}
