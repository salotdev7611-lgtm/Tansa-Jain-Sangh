import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  final List<Offset> points;

  DottedLinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    const dashWidth = 5;
    const dashSpace = 5;

    for (int i = 0; i < points.length - 1; i++) {
      Offset start = points[i];
      Offset end = points[i + 1];

      double distance = (end - start).distance;
      Offset direction = (end - start) / distance;

      double current = 0;
      while (current < distance) {
        final p1 = start + direction * current;
        final p2 = start + direction * (current + dashWidth);
        canvas.drawLine(p1, p2, paint);
        current += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PersonNode extends StatelessWidget {
  final String name;
  final String image;

  const PersonNode({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundImage: AssetImage(image),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(fontSize: 12),
        )
      ],
    );
  }
}
