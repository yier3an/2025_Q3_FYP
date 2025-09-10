import 'package:flutter/material.dart';
import 'shared_header.dart';

class MapTabPage extends StatelessWidget {
  const MapTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedHeader(),
      body: const Center(child: Text('Map with gym locations (mock)')),
    );
  }
}
