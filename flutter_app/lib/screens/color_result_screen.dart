import 'package:flutter/material.dart';
import '../services/lumi_service.dart';
import 'chart_of_day_screen.dart';
import 'calendar_screen.dart';
import 'journal_screen.dart';

class ColorResultScreen extends StatelessWidget {
  final Map<String, dynamic> prediction;

  const ColorResultScreen({Key? key, required this.prediction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lumiService = LumiService();
    final emotion = prediction['emotion'] as String? ?? 'Neutral';
    final summary = prediction['summary'] as String? ?? '';
    final hue = prediction['hue'] as int?;
    final color = lumiService.hueToColor(hue);

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ChartOfDayScreen()),
                          );
                        },
                        child: const Text('Chart of\nthe day',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
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
                const SizedBox(height: 80),
                // "Your color is..." text
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFc4b5fd),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Your color is...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Emotion label
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFc4b5fd),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    emotion,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Color orb
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.6),
                        blurRadius: 40,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
                if (summary.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      summary,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 40),
                // "See what others got" button
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChartOfDayScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFc4b5fd),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'See what others\ngot',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
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
          ),
        ],
      ),
    );
  }
}
