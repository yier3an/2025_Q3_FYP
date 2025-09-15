
import 'package:flutter/material.dart';

class SimpleDonutChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  const SimpleDonutChart({super.key, required this.values, required this.labels});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            return Row(
              children: [
                Expanded(
                  child: CustomPaint(
                    painter: _DonutPainter(values),
                    child: Center(
                      child: Text(
                        '${values.fold<double>(0, (p, e) => p + e).round()}\nTotal',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(values.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(width: 12, height: 12, color: _palette[i % _palette.length]),
                            const SizedBox(width: 8),
                            Expanded(child: Text('${labels[i]} (${values[i].round()})')),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

const _palette = [
  Color(0xFF90CAF9), // blue-ish
  Color(0xFFFFF59D), // yellow-ish
  Color(0xFFFFAB91), // orange-ish
  Color(0xFFB39DDB), // purple-ish
];

class _DonutPainter extends CustomPainter {
  final List<double> values;
  _DonutPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (p, e) => p + e);
    if (total <= 0) return;

    final center = size.center(Offset.zero);
    final radius = (size.shortestSide / 2) * 0.85;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double start = -90.0; // start at top
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.35
      ..strokeCap = StrokeCap.butt;

    for (int i = 0; i < values.length; i++) {
      final sweep = 360.0 * (values[i] / total);
      paint.color = _palette[i % _palette.length];
      canvas.drawArc(rect, radians(start), radians(sweep), false, paint);
      start += sweep;
    }
  }

  double radians(double deg) => deg * 3.1415926535 / 180.0;

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => oldDelegate.values != values;
}
