
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  final List<double> data;
  final EdgeInsets padding;
  const SimpleLineChart({super.key, required this.data, this.padding = const EdgeInsets.all(12)});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
        ),
        padding: padding,
        child: CustomPaint(
          painter: _LinePainter(data),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> data;
  _LinePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = Colors.white;
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)), bg);

    // Axes
    final axisPaint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;
    // Horizontal guide lines (4)
    for (int i = 1; i <= 4; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), axisPaint);
    }

    if (data.isEmpty) return;
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final span = (maxVal - minVal).abs() < 1e-6 ? 1.0 : (maxVal - minVal);

    final line = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = (size.width) * (i / (data.length - 1));
      final norm = (data[i] - minVal) / span;
      final y = size.height - norm * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, line);

    // Dots
    final dot = Paint()..color = Colors.black87;
    for (int i = 0; i < data.length; i++) {
      final x = (size.width) * (i / (data.length - 1));
      final norm = (data[i] - minVal) / span;
      final y = size.height - norm * size.height;
      canvas.drawCircle(Offset(x, y), 3, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) => oldDelegate.data != data;
}
