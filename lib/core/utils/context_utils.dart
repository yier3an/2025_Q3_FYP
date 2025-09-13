import 'package:flutter/cupertino.dart';

extension ContextUtils on BuildContext {
  bool get isMobile {
    final screenWidth = MediaQuery.of(this).size.width;
    final isMobile = screenWidth < 768;
    return isMobile;
  }
}