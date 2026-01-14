import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'calendar_screen.dart';
import 'journal_screen.dart';

class ChartOfDayScreen extends StatelessWidget {
  const ChartOfDayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Purple swirly background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Color(0xFF8b5cf6),
                  Color(0xFF6366f1),
                  Color(0xFF4c1d95),
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Icon(Icons.menu_book, color: Colors.white, size: 40),
                      const SizedBox(width: 12),
                      const Text(
                        'LUMI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Navigation tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Chart of\nthe day',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CalendarScreen()),
                          );
                        },
                        child: const Text('Calendar',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const JournalScreen()),
                          );
                        },
                        child: const Text('Journal',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // "Today, people are feeling..."
                const Text(
                  'Today, people are\nfeeling...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 60),
                // Pie chart
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CustomPaint(
                    painter: PieChartPainter(),
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 40),
                // Footer
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Privacy Policy',
                          style: TextStyle(color: Colors.white)),
                      SizedBox(width: 40),
                      Text('Terms & Conditions',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Pie chart painter
class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Data: [Angry, Sad, Joyful, Confused, Neutral]
    final List<PieData> data = [
      PieData('Anger', 0.25, const Color(0xFFef4444)), // Red
      PieData('Sad', 0.20, const Color(0xFF3b82f6)), // Blue
      PieData('Joyful', 0.25, const Color(0xFFfbbf24)), // Yellow
      PieData('Confused', 0.15, Colors.grey), // Grey
      PieData('Neutral', 0.15, Colors.grey[600]!), // Dark grey
    ];

    double startAngle = -math.pi / 2;

    for (var slice in data) {
      final sweepAngle = 2 * math.pi * slice.percentage;

      final paint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw label
      final labelAngle = startAngle + sweepAngle / 2;
      final labelRadius = radius * 0.7;
      final labelX = center.dx + labelRadius * math.cos(labelAngle);
      final labelY = center.dy + labelRadius * math.sin(labelAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: slice.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PieData {
  final String label;
  final double percentage;
  final Color color;

  PieData(this.label, this.percentage, this.color);
}