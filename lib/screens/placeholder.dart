import 'package:flutter/material.dart';
import '../widgets/side_nav.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String route;
  const PlaceholderScreen({super.key, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNav(currentRoute: route),
          const SizedBox(width: 0),
          Expanded(
            child: Center(
              child: Text('$title (Prototype placeholder)',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
