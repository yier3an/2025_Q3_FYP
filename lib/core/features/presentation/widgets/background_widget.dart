import 'package:flutter/material.dart';
import 'package:my_website/core/theme/app_color.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
          colors: [
          Color(0xFF3E0066), // deep purple (top)
          Color(0xFF9B4DFF), // lighter purple (bottom)
          ],
        ),
      ),

    );
  }
}
