
import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'shared_header.dart';

class MapTabPage extends StatelessWidget {
  const MapTabPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedHeader(
        onSettings: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage())),
      ),
      body: const Center(child: Text('Map placeholder')),
    );
  }
}
