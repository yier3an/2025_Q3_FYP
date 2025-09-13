import 'package:flutter/material.dart';

class FooterSectionWidget extends StatelessWidget {
  const FooterSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              children: [
                // top row of columns
                Wrap(
                  spacing: 32,
                  runSpacing: 24,
                  alignment: WrapAlignment.spaceBetween,
                  children: const [
                    _BrandCol(),
                    _LinksCol(
                      heading: 'Company',
                      items: ['About', 'Blog', 'Press'],
                    ),
                    _LinksCol(
                      heading: 'Help',
                      items: ['Support', 'Privacy Policy', 'Terms of Service', 'FAQ'],
                    ),
                    _ContactCol(),
                    _SubscribeCol(),
                  ],
                ),
                const SizedBox(height: 20),
                // divider & copyright
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '© 2025 Wise Workout. All rights reserved.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandCol extends StatelessWidget {
  const _BrandCol();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const CircleAvatar(radius: 12, backgroundColor: Colors.white),
            const SizedBox(width: 8),
            Text('Wise Workout',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    )),
          ]),
          const SizedBox(height: 6),
          Text(
            'Trusted by Fitness Enthusiasts Worldwide',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white60),
          ),
        ],
      ),
    );
  }
}

class _LinksCol extends StatelessWidget {
  final String heading;
  final List<String> items;
  const _LinksCol({required this.heading, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  )),
          const SizedBox(height: 10),
          for (final it in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: InkWell(
                onTap: () {
                  // TODO: route/scroll to page
                },
                child: Text(it, style: const TextStyle(color: Colors.white70)),
              ),
            ),
        ],
      ),
    );
  }
}

class _ContactCol extends StatelessWidget {
  const _ContactCol();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact Info',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  )),
          const SizedBox(height: 10),
          const Text('help@wiseworkout.com', style: TextStyle(color: Colors.white70)),
          const Text('Singapore', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _SubscribeCol extends StatelessWidget {
  const _SubscribeCol();

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return SizedBox(
      width: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stay Updated',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  )),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Enter Your Email',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white10,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white60),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    // TODO: send to newsletter service
                    final email = controller.text.trim();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Subscribed: $email')),
                    );
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  child: const Text('Subscribe'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
